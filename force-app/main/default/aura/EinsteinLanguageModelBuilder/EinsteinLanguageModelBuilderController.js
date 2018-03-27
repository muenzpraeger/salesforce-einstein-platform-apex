/* globals _ */
({
    doInit: function (component, event, helper) {
        var action = component.get("c.getObjectOptions");
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log(JSON.parse(a.getReturnValue()));
                component.set("v.objects", _.sortBy(JSON.parse(a.getReturnValue()), ['label', 'name']));
            } else if (state === "ERROR") {
                console.log(a.getError());
                component.find("leh").passErrors(a.getError());
            }
        });
        $A.enqueueAction(action);
    },

    getFields: function (component, event, helper) {
        var source = component.get("c.getObjectFields");
        source.setParams({
            "objectName": component.get("v.selectedObject"),
            "sourceOrLabel": "Source"
        });
        source.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log(a);
                component.set("v.sourceFields", _.sortBy(JSON.parse(a.getReturnValue()), ['label', 'name']));
            } else if (state === "ERROR") {
                console.log(a.getError());
                component.find("leh").passErrors(a.getError());
            }
        });
        $A.enqueueAction(source);

        var target = component.get("c.getObjectFields");
        target.setParams({
            "objectName": component.get("v.selectedObject"),
            "sourceOrLabel": "Label"
        });
        target.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log(a);
                component.set("v.classificationFields", JSON.parse(a.getReturnValue()));
            } else if (state === "ERROR") {
                console.log(a.getError());
                component.find("leh").passErrors(a.getError());
            }
        });
        $A.enqueueAction(target);
    },

    createFile: function (component, event, helper) {

        var action = component.get("c.saveFileToFiles");
        action.setParams({
            obj: component.get("v.selectedObject"),
            src: component.get("v.selectedSourceField"),
            classify: component.get("v.selectedclassificationField")
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log(a.getReturnValue());
                component.set("v.CV", a.getReturnValue());
            } else if (state === "ERROR") {
                console.log(a.getError());
                component.find("leh").passErrors(a.getError());
            }
        });
        $A.enqueueAction(action);

    },

    viewFile: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.CV").Id
        });
        navEvt.fire();
    },

    previewFile: function (component, event, helper) {
        $A.get('e.lightning:openFiles').fire({
            recordIds: [component.get("v.CV.ContentDocumentId")]
        });
    },

    createDataset: function (component, event, helper) {
        var self = this;

        //first, create the distribution
        var action = component.get("c.writeCD");
        action.setParams({
            contentDocumentId: component.get("v.CV.ContentDocumentId"),
            name: component.get("v.CV.Title")
        });
        action.setCallback(self, function (a) {
            if (a.getState() === "SUCCESS") {
                console.log(a.getReturnValue());
                //then set this as the url, then call Einstein to pick it up
                var send = component.get("c.createDatasetFromUrl");
                send.setParams({
                    url: a.getReturnValue().ContentDownloadUrl,
                    dataType: component.get("v.dataType")
                });
                send.setCallback(self, function (b) {
                    if (b.getState() === "SUCCESS") {
                        console.log(b.getReturnValue());
                        // $A.get("e.ltng:sendMessage")
                        //     .setParams({ "message": "message", "newDataset": "EinsteinDatasetCreation" })
                        //     .fire();
                        $A.get("e.force:showToast").setParams({ "type": "success", "message": "Dataset Created!" }).fire();
                    } else if (b.getState() === "ERROR") {
                        console.log(b.getError());
                        component.find("leh").passErrors(b.getError());
                    }
                })

                $A.enqueueAction(send);
            } else if (a.getState() === "ERROR") {
                console.log(a.getError());
                component.find("leh").passErrors(a.getError());
            }
        });
        $A.enqueueAction(action);
    },
})
