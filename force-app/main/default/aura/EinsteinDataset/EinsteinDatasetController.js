({
  onModelsTab: function(component, event, helper) {
    helper.getModelsByDataset(component);
    component.set("v.currentTab", "models");
  },

  onLabelsTab: function(component, event, helper) {
    component.set("v.currentTab", "labels");
    //added to update the model count
    helper.getModelsByDataset(component);
  },

  onRefresh: function(component, event, helper) {
    helper.getModelsByDataset(component);
  },

  onDeleteDataset: function(component, event, helper) {
    var action = component.get("c.deleteDataset");
    var dataset = component.get("v.dataset");
    action.setParams({
      datasetId: dataset.id,
      dataType: dataset.type
    });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            alert("Error message: " + errors[0].message);
          }
        } else {
          console.log("Unknown error");
        }
      }
      var event = component.getEvent("databaseEvent");
      event.fire();
    });
    $A.enqueueAction(action);
  },

  openMetrics : function(component, event, helper) {
    console.log("opening metrics for type " + component.get("v.dataset.type"));
    // $A.createComponent("c:einsteinModelMetrics", {
    //     "modelId": event.getSource().get("v.name"),
    //     "dataset" : component.get("v.dataset"),
    //     "dataType" : component.get("v.dataset.type")
    //   },
    //   function (content, status) {
    //     if (status === "SUCCESS") {
    //       component.find('overlayLib').showCustomModal({
    //         header: `Metrics for ${component.get("v.dataset.name")}/${event.getSource().get("v.name")}`,
    //         body: content,
    //         showCloseButton: true,
    //         cssClass: "slds-modal_large"
    //       })
    //     }
    //   });
    $A.get("e.force:navigateToComponent")
    .setParams({
      componentDef: "c:einsteinModelMetrics",
      componentAttributes: {
        "modelId": event.getSource().get("v.name"),
        "dataset" : component.get("v.dataset"),
        "dataType" : component.get("v.dataset.type"),
        "header": `Metrics for ${component.get("v.dataset.name")}/${event.getSource().get("v.name")}`
      }
    })
    .fire();
  },


  onTrainModel: function(component, event, helper) {
    var action = component.get("c.trainDataset");
    var dataset = component.get("v.dataset");
    action.setParams({
      datasetId: dataset.id,
      modelName: dataset.name + " model",
      dataType: dataset.type
    });
    action.setCallback(this, function(response) {
      if (response.getState() === "ERROR") {
        console.log(response.getError());
        component.find("leh").passErrors(response.getError());
      } else if (response.getState()==="SUCCESS"){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          title: "Success!",
          type: "success",
          message:
            "The model id for the training is " +
            response.getReturnValue() +
            ". Go to the model tab for seeing the training progress."
        });
        toastEvent.fire();
      }
    });
    $A.enqueueAction(action);
  },

  onReTrainModel: function (component, event, helper) {
    var action = component.get("c.retrainDataset");
    var dataset = component.get("v.dataset");
    action.setParams({
      modelId: component.get("v.models")[0].modelId,
      //modelName: dataset.name + " model",
      dataType: dataset.type
    });
    action.setCallback(this, function (response) {
      if (response.getState() === "ERROR") {
        console.log(response.getError());
        component.find("leh").passErrors(response.getError());
      } else if (response.getState() === "SUCCESS") {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          title: "Success!",
          type: "success",
          message:
            "The model id for the training is " +
            response.getReturnValue() +
            ". Go to the model tab for seeing the training progress."
        });
        toastEvent.fire();
      }
    });
    $A.enqueueAction(action);
  },

  doInit : function(component, event, helper) {
    let dataset = component.get("v.dataset");
    if (dataset.type==='image'){
      component.set("v.iconName", "utility:preview");
    } else if (dataset.type === 'text-intent'){
      component.set("v.iconName", "utility:signpost");
    } else if (dataset.type === 'text-sentiment') {
      component.set("v.iconName", "utility:like");
    } else if (dataset.type === 'image-detection') {
      component.set("v.iconName", "utility:zoomin");
    } else {
      component.set("v.iconName", "utility:preview");
    }
  },
});
