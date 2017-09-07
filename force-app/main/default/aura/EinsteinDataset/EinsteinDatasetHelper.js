({
  getModelsByDataset: function(component) {
    var action = component.get("c.getModels");
    var dataset = component.get("v.dataset");
    action.setParams({
      datasetId: dataset.id,
      dataType: dataset.type
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
      component.set("v.models", response.getReturnValue());
    });
    var event = component.getEvent("waitingEvent");
    event.fire();
    $A.enqueueAction(action);
  }
});
