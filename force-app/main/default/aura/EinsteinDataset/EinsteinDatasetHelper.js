({
  getModelsByDataset: function(component) {
    var action = component.get("c.getModels");
    var dataset = component.get("v.dataset");
    var datasetType = dataset.type;
    action.setParams({
      datasetId: dataset.id,
      dataType: datasetType
    });
    action.setCallback(this, function(response) {
      var event = component.getEvent("waitingEvent");
      event.fire();
      var state = response.getState();
      console.log(state);
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
      //Need to handle null response if user clicks tab before
      //training an actual model
      var resp = response.getReturnValue();
      if (resp && resp.length > 0) {
        component.set("v.models", response.getReturnValue());
        event = component.getEvent("modelEvent");
        event.setParams({
          type: datasetType,
          models: response.getReturnValue()
        });
        event.fire();
      } else {
        console.log("No model.");
      }
    });
    var event = component.getEvent("waitingEvent");
    event.fire();
    $A.enqueueAction(action);
  }
});
