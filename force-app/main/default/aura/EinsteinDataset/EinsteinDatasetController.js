({
  onModelsTab: function(component, event, helper) {
    helper.getModelsByDataset(component);
    component.set("v.currentTab", "models");
  },

  onLabelsTab: function(component, event, helper) {
    component.set("v.currentTab", "labels");
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

  onTrainModel: function(component, event, helper) {
    var action = component.get("c.trainDataset");
    var dataset = component.get("v.dataset");
    action.setParams({
      datasetId: dataset.id,
      modelName: dataset.name + " model",
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
      } else {
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
  }
});
