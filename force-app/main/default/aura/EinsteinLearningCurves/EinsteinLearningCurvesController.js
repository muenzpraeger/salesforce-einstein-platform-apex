({
    doInit: function (component, event, helper) {
        console.log("init");

        let action = component.get("c.getLearningCurves");
        action.setParams({ "modelId": component.get("v.modelId") });

        action.setCallback(this, function (a) {
            let data = a.getReturnValue();
            console.log(data);

            // if (!data.data) {
            //     return; //we're done here
            // }
            // //will get overwritten if we get back anything useful
            // //e is for epoch and that's good enough for me
            // for (let e = 0; e < data.data.length; e++) {
            //     data.data[e].preparedData = {
            //         "f1": [],
            //         "confusion": [],
            //         "examples": []
            //     };
            //     for (let k = 0; k < data.data[e].metricsData.labels.length; k++) {
            //         data.data[e].preparedData.f1.push({
            //             "label": data.data[e].metricsData.labels[k],
            //             "value": data.data[e].metricsData.f1[k]
            //         });
            //         data.data[e].preparedData.confusion.push({
            //             "label": data.data[e].metricsData.labels[k],
            //             "value": data.data[e].metricsData.confusionMatrix[k].toString()
            //         });
            //     }
            // }
            // console.log(data);
            // component.set("v.data", data);
            //component.set("v.counterIndex", counter);
        });

        $A.enqueueAction(action);
    }
})