({
    doInit: function (component, event, helper) {

        let action = component.get("c.getModelMetrics");
        action.setParams({
            "modelId" : component.get("v.modelId"),
            "dataType" : component.get("v.dataType")
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            if (state === "SUCCESS") {
                let dataset = component.get("v.dataset");
                console.log(dataset);

                let metrics = JSON.parse(a.getReturnValue());
                console.log(metrics);

                metrics.metricsData.f1.forEach(function (f1, key){
                    dataset.labelSummary.labels[key].f1 = f1;
                });

                metrics.metricsData.confusionMatrix.forEach(function (confusion, key) {
                    dataset.labelSummary.labels[key].confusion = confusion;
                });

                component.set("v.data", metrics);

                let action2 = component.get("c.getLearningCurves");

                action2.setParams({
                    "modelId": component.get("v.modelId"),
                    "dataType": component.get("v.dataType")
                });

                action2.setCallback(this, function (a) {
                    let LCdata = JSON.parse(a.getReturnValue()).data;
                    console.log("learning curves original");
                    console.log(LCdata);

                    if (!LCdata) {
                        return; //we're done here
                    }

                    LCdata.forEach(function (epochRow) {
                        epochRow.open = false;
                        epochRow.labelData = [];
                        epochRow.metricsData.labels.forEach(function (label, key) {
                            var thisData = {
                                "label": label,
                                "f1": epochRow.metricsData.f1[key],
                                "confusionRaw": epochRow.metricsData.confusionMatrix[key]
                            };
                            epochRow.labelData[key] = thisData;
                            thisData.confusionFormatted = helper.formatConfusion(label, thisData.confusionRaw, epochRow.metricsData.labels, epochRow.epochResults);

                        });
                    });

                    console.log(LCdata);
                    component.set("v.LCdata", LCdata);
                    component.set("v.done", true);
                    //put the highest epoch onto the dataset's labelSummary object for ConfusionFormatted
                    dataset.labelSummary.labels.forEach( (label, key) => {
                        dataset.labelSummary.labels[key].confusionFormatted = LCdata[LCdata.length-1].labelData[key].confusionFormatted;
                    })
                    console.log(dataset);
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
        console.log(event);
        var data = component.get("v.LCdata");
        var epochIndex = event.target.id - 1;
        console.log(epochIndex);
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
        console.log(data);
        component.set("v.LCdata", data);
    },
})