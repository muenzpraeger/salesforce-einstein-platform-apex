/* globals _ , ResizeObserver */

({
    upload: function (component) {
        console.log("in the upload function");
        var dataType = component.get("v.dataType");

        component.set("v.markupPending", true);

        var action = this.actionBuilder(component);
        
        if (action==null) {
            return;
        }
        
        action.setParams(this.paramBuilder(component));

        action.setCallback(this, function (a) {
            if (a.getState() === "ERROR") {
                component.find("leh").passErrors(a.getError());
            }
            var result = a.getReturnValue();
            console.log(result);

            var rawPredictions = JSON.stringify(result, null, 4);
            component.set("v.rawPredictions", rawPredictions);

            // if we got anything back
            if (result && result.probabilities.length) {
                //special handling for detection visualization
                if (dataType === 'image-detection'){
                    component.set("v.predictions", result);
                    var ro = new ResizeObserver(entries => {
                        this.generateSvg(component, result);
                    });
                    var img = component.find("imgItself").getElement();
                    ro.observe(img);
                } else { //all other prediction types
                    var predictions = [];

                    for (var i = 0; i < result.probabilities.length; i++) {
                        predictions.push({
                            label: result.probabilities[i].label,
                            formattedProbability:
                                "" + Math.round(result.probabilities[i].probability * 100) + "%"
                        });
                    }
                    component.set("v.predictions", predictions);
                }
            }
        });
        component.set("v.predictions", null);
        component.set("v.rawPredictions", null);
        $A.enqueueAction(action);
    },

    //decides what to do based on datatype
    actionBuilder : function(component) {
        var action;
        var dataType = component.get("v.dataType");
        const files = component.get("v.files");

        if (dataType === 'image' || dataType === 'image-multi-label') {
            if (files.length > 0 && files[0].length > 0){
                action = component.get("c.predictImageClassification");
            } else if (component.get("v.imageURL")){
                action = component.get("c.predictImageClassificationURL");
            }
        } else if (dataType === 'text-intent') {
            action = component.get("c.predictIntent");
        } else if (dataType === 'text-sentiment'){
            action = component.get("c.predictSentiment");
        } else if (dataType === 'image-detection'){
            if (files.length > 0 && files[0].length > 0) {
                action = component.get("c.predictImageDetection");
            } else if (component.get("v.imageURL")) {
                action = component.get("c.predictImageDetectionURL");
            }
        }
        return action;
    },

    paramBuilder : function(component) {
        var dataType = component.get("v.dataType");
        const files = component.get("v.files");
        var params = {
            modelId: component.get("v.modelId")
        };
        
        if (dataType === 'text-intent' || dataType === 'text-sentiment'){
            params.phrase = component.get("v.phrase");
        } else if (dataType === 'image' || dataType === 'image-multi-label' || dataType === 'image-detection' ){
            if (files.length > 0 && files[0].length > 0) {
                params.base64 = component.get("v.pictureSrc").match(/,(.*)$/)[1];
            } else if (component.get("v.imageURL")) {
                params.url = component.get("v.pictureSrc");
            }
        }



        return params;
    },



    // image detection stuff


    generateSvg: function (component, result) {
        console.log("generating svg");

        var imgContainer = component.find("imgContainer").getElement();
        while (imgContainer.firstChild) {
            imgContainer.removeChild(imgContainer.firstChild);
        }
        var img = component.find("imgItself").getElement();

        var proportion = img.clientHeight / img.naturalHeight;
        if (proportion > 1) {
            proportion = 1;
        }

        var probabilities = result.probabilities;

        var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
        var svgNS = svg.namespaceURI;

        var leftPos = img.offsetLeft;
        var topPos = img.offsetTop;

        var colors = this.buildColorCoding(probabilities);

        probabilities.forEach(function (probability) {
            var color = colors[probability.label];
            // create polygon for box
            var polygon = document.createElementNS(svgNS, "polygon");
            polygon.setAttribute(
                "style",
                "stroke:" + color + ";stroke-width:3;fill-opacity:0"
            );
            var points = [];
            points.push(
                (probability.boundingBox.minX * proportion + leftPos) +
                "," +
                (probability.boundingBox.minY * proportion + topPos)
            );
            points.push(
                (probability.boundingBox.maxX * proportion + leftPos) +
                "," +
                (probability.boundingBox.minY * proportion + topPos)
            );
            points.push(
                (probability.boundingBox.maxX * proportion + leftPos) +
                "," +
                (probability.boundingBox.maxY * proportion + topPos)
            );
            points.push(
                (probability.boundingBox.minX * proportion + leftPos) +
                "," +
                (probability.boundingBox.maxY * proportion + topPos)
            );
            polygon.setAttribute("points", points.join(" "));

            svg.appendChild(polygon);

            // create text box
            var div = document.createElement("div");
            div.setAttribute(
                "style",
                "position:absolute;top:" +
                probability.boundingBox.maxY * proportion +
                "px;left:" +
                (probability.boundingBox.minX * proportion + leftPos) +
                "px;width:" +
                (probability.boundingBox.maxX - probability.boundingBox.minX) *
                proportion +
                "px;text-align:center;color:" +
                color +
                ";"
            );
            div.innerHTML = probability.label;
            imgContainer.appendChild(div);
        }, this);
        component.set("v.markupPending", false);

        imgContainer.appendChild(svg);
    },

    getObjectHighlightColor: function (label) {
        if (label === "Astro") {
            return "red";
        }
        return "yellow";
    },

    // generates a palette of high-contract colors
    buildColorCoding: function (probabilities) {
        var colors = {};
        var uniqueLabels = _.uniq(_.map(probabilities, 'label'));

        var colorArray = [
            '#e6194b',
            '#3cb44b',
            '#ffe119',
            '#0082c8',
            '#f58231',
            '#911eb4',
            '#46f0f0',
            '#f032e6',
            '#d2f53c',
            '#fabebe',
            '#008080',
            '#e6beff',
            '#aa6e28',
            '#fffac8',
            '#800000',
            '#aaffc3',
            '#808000',
            '#ffd8b1',
            '#000080',
            '#808080',
            '#FFFFFF',
            '#000000'
        ]

        for (var i = 0; i < uniqueLabels.length; i++) {
            colors[uniqueLabels[i]] = colorArray[i];
        }

        console.log(colors);

        return colors;
    }

});