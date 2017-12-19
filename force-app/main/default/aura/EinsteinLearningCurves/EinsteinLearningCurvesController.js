({
    doInit: function (component, event, helper) {
        console.log("init learning curves for " + component.get("v.dataType"));

        let action = component.get("c.getLearningCurves");
        action.setParams({
            "modelId": component.get("v.modelId"),
            "dataType": component.get("v.dataType")
        });

        action.setCallback(this, function (a) {
            let data = a.getReturnValue();
            console.log("learning curves");
            console.log(data);

            if (!data) {
                return; //we're done here
            }
            //will get overwritten if we get back anything useful
            //e is for epoch and that's good enough for me
            for (let e = 0; e < data.length; e++) {
                data[e].preparedData = {
                    "f1": [],
                    "confusion": [],
                    "examples": []
                };
                for (let k = 0; k < data[e].metricsData.labels.length; k++) {
                    data[e].preparedData.f1.push({
                        "label": data[e].metricsData.labels[k],
                        "value": data[e].metricsData.f1[k]
                    });
                    data[e].preparedData.confusion.push({
                        "label": data[e].metricsData.labels[k],
                        "value": data[e].metricsData.confusionMatrix[k].toString()
                    });
                }
            }
            console.log(data);
            component.set("v.data", data);
            //component.set("v.counterIndex", counter);
        });

        $A.enqueueAction(action);
    }
})