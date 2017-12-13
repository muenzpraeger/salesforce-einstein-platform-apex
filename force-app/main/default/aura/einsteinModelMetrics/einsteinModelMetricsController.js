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
                let metrics = a.getReturnValue();
                let dataset = component.get("v.dataset");

                component.set("v.data", metrics);
                component.set("v.done", true);

                try {
                    for (let i = 0; i < dataset.labelSummary.labels.length; i++) {
                        dataset.labelSummary.labels[i].f1 = metrics.f1[i];
                        dataset.labelSummary.labels[i].confusionMatrix = metrics.confusionMatrix[i];
                    }
                } catch (err) {
                    console.log(err);
                    console.log("no data available for this model");
                }

                component.set("v.dataset", dataset);
            } else if (state === "ERROR") {
                component.find("leh").passErrors(a.getError());
                console.log(a.getError());
                component.set("v.done", true);
            }
        });
        $A.enqueueAction(action);

    }
})