({
    onCreateDataset: function (component, event, helper) {
        helper.onCreateDataset(component);
    },

    doInit : function(component, event, helper) {
        //get the userID and store it for possible attachments.  Very cacheable here!
        var action = component.get("c.getMyUserId");
        action.setStorable();
        action.setCallback(this, function (a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log(a);
                component.set("v.userId", a.getReturnValue());
            } else if (state === "ERROR") {
                component.find("leh").passErrors(a.getError());
                console.log(a.getError());
            }
        });
        $A.enqueueAction(action);

        //set icons and allowed files
        let dataType = component.get("v.dataType");
        if (dataType === 'image') {
            component.set("v.iconName", "utility:preview");
            component.set("v.filesAllowed", ".zip");
        } else if (dataType === 'text-intent') {
            component.set("v.iconName", "utility:signpost");
            component.set("v.filesAllowed", ".csv");
        } else if (dataType === 'text-sentiment') {
            component.set("v.iconName", "utility:like");
            component.set("v.filesAllowed", ".csv");
        } else if (dataType === 'image-detection') {
            component.set("v.iconName", "utility:zoomin");
            component.set("v.filesAllowed", ".zip");
        } else if (dataType === 'image-multi-label') {
            component.set("v.iconName", "utility:richtextbulletedlist");
            component.set("v.filesAllowed", ".zip");
        } else {
            component.set("v.iconName", "utility:preview");
        }

        helper.setDefaultUrl(component);
    },

    switchDefaultUrl : function(component, event, helper) {
        helper.setDefaultUrl(component);
    },

    handleUploadFinished : function(component, event, helper) {
        console.log("upload finished!");
        console.log(event.getParam("files")[0].documentId);
        //public static ContentDistribution writeCD(id contentDocumentId, string name){
        let doc = event.getParam("files")[0];
        var action = component.get("c.writeCD");
        action.setParams({
            contentDocumentId: doc.documentId,
            name: doc.name
        });
        action.setCallback(this, function(a){
            var state = a.getState();
            if (state === "SUCCESS") {
                console.log(a.getReturnValue());
                //then set this as the url, then call Einstein to pick it up
                component.set("v.fileUrl", a.getReturnValue().ContentDownloadUrl);
                helper.onCreateDataset(component);
            } else if (state === "ERROR") {
                console.log(a.getError());
                component.find("leh").passErrors(a.getError());
            }
        });
        $A.enqueueAction(action);

    },
})
