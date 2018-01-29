({
    doInit: function (component, event, helper) {
        let dataset = component.get("v.dataset");

        let action = component.get("c.getModelMetrics");
        action.setParams({
            "modelId" : component.get("v.modelId"),
            "dataType" : component.get("v.dataType")
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            if (state === "SUCCESS") {

                let metrics = JSON.parse(a.getReturnValue());
                component.set("v.data", metrics);
                console.log("here are the model metrics:");
                console.log(metrics);

                //because there's not f1 in the metricsdata for object detection
                if (metrics.metricsData.f1){
                    metrics.metricsData.f1.forEach(function (f1, key){
                        dataset.labelSummary.labels[key].f1 = f1;
                    });
                }

                if (metrics.metricsData.confusionMatrix){
                    // image, language
                    metrics.metricsData.confusionMatrix.forEach(function (confusion, key) {
                        dataset.labelSummary.labels[key].confusion = confusion;
                    });
                } else if (metrics.metricsData.confusionMatrices) {
                    // multi image
                    dataset.labelSummary.labels.forEach((datasetLabel, key) => {
                        dataset.labelSummary.labels[key].confusion = metrics.metricsData.confusionMatrices[datasetLabel.name];
                    })
                }


                let action2 = component.get("c.getLearningCurves");

                action2.setParams({
                    "modelId": component.get("v.modelId"),
                    "dataType": component.get("v.dataType")
                });

                action2.setCallback(this, function (a) {
                    let LCdata = JSON.parse(a.getReturnValue()).data;

                    console.log("here are the original learning curves");
                    console.log(LCdata);

                    //transforamtions to tear out the array-style for multi-image
                    if (component.get("v.dataType")=='image-multi-label'){
                        LCdata = helper.expandMultiImageLC(LCdata);
                    }

                    if (component.get("v.dataType")=='image-detection'){
                        LCdata = helper.formatDetectionData(LCdata);
                    }

                    if (!LCdata) {
                        return; //we're done here
                    }

                    LCdata.forEach(function (epochRow) {
                        epochRow.open = false;
                        epochRow.labelData = [];

                        //there's not labels for object detction, so we'll create them
                        epochRow.metricsData.labels.forEach(function (label, key) {
                            var thisData = {
                                "label": label,
                                "f1": epochRow.metricsData.f1[key]
                                //"confusionRaw": epochRow.metricsData.confusionMatrix[key]
                            };
                            if (epochRow.metricsData.confusionMatrix){
                                thisData.confusionRaw = epochRow.metricsData.confusionMatrix[key];
                            } else if (epochRow.metricsData.confusionMatrices){
                                thisData.confusionRaw = epochRow.metricsData.confusionMatrices[thisData.label];
                            }
                            epochRow.labelData[key] = thisData;
                            if (thisData.confusionRaw){
                                //if there's any confusion, let's format it
                                thisData.confusionFormatted = helper.formatConfusion(label, thisData.confusionRaw, epochRow.metricsData.labels, epochRow.epochResults);
                            }

                        });
                    });

                    component.set("v.LCdata", LCdata);
                    component.set("v.done", true);
                    if (component.get("v.dataType") == 'image-multi-label') {
                        // don't put the confusion matrix in the top section since it's postive/negative.  You can just pull it from the higheest epoch
                    } else if (component.get("v.dataType") == 'image-detection') {
                        // put the f1 from the last epoch on the top-level model metrics
                        dataset.labelSummary.labels.forEach((label, key) => {
                            dataset.labelSummary.labels[key].f1 = LCdata[LCdata.length - 1].labelData[key].f1;
                        });
                    } else {
                        //put the highest epoch onto the dataset's labelSummary object for ConfusionFormatted
                        dataset.labelSummary.labels.forEach( (label, key) => {
                            dataset.labelSummary.labels[key].confusionFormatted = LCdata[LCdata.length-1].labelData[key].confusionFormatted;
                        });
                    }
                    component.set("v.dataset", dataset);

                    //component.set("v.counterIndex", counter);
                });

                $A.enqueueAction(action2);

            } else if (state === "ERROR") {
                component.find("leh").passErrors(a.getError());
                console.log(a.getError());
                component.set("v.done", true);
            }
        });
        $A.enqueueAction(action);

    },

    getEpochDetails: function (component, event) {
        var data = component.get("v.LCdata");
        var epochIndex = event.target.id;
        //close all
        data.forEach(function (row, index) {
            if (row.open && index != epochIndex) {
                // you opened some other one, close this one
                row.open = false;
            } else if (row.open && index == epochIndex) {
                // you're trying to toggle closed the currently open one
                row.open = false
            } else if (!row.open && index == epochIndex) {
                // it was closed and you're trying to open it
                row.open = true;
            }
        });
        component.set("v.LCdata", data);
    },
})