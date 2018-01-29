({
    onCreateDataset: function (component) {
        var action = component.get("c.createDatasetFromUrl");
        var url = component.find("fileUrl").get("v.value");
        var dataType = component.get("v.dataType");

        console.log('dataType is ' + dataType);
        var self = this;
        action.setParams({
            url: url,
            dataType: dataType
        });
        action.setCallback(this, function (response) {
            var event = component.getEvent("waitingEvent");
            event.fire();
            var state = response.getState();
            if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        return alert(errors[0].message);
                    }
                } else {
                    return console.log("Unknown error");
                }
            } else if (state = "SUCCESS"){
                console.log(response.getReturnValue());
                $A.get("e.ltng:sendMessage")
                    .setParams({"message" : "message", "newDataset" : "EinsteinDatasetCreation"})
                    .fire();
                $A.get("e.force:showToast").setParams({"type" : "success", "message" : "Dataset Created!"}).fire();
            }
        });
        var event = component.getEvent("waitingEvent");
        event.fire();
        $A.enqueueAction(action);
    },

    setDefaultUrl : function(component) {
        if (component.get("v.dataType") === 'image'){
            component.set("v.fileUrl", "http://einstein.ai/images/mountainvsbeach.zip");
        } else if (component.get("v.dataType") === 'image-multi-label') {
            component.set("v.fileUrl", "http://einstein.ai/images/mountainvsbeach.zip");
        } else if (component.get("v.dataType") === 'text-intent'){
            component.set("v.fileUrl", "http://einstein.ai/text/case_routing_intent.csv");
        } else if (component.get("v.dataType")=== 'image-detection'){
            component.set("v.fileUrl", "https://einstein.ai/images/alpine.zip");
        }
    },
})
