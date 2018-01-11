({
  predict: function(component) {
    var action = component.get("c.predictSentiment");
    var modelId = component.get("v.modelId");
    var phrase = component.get("v.phrase");
    action.setParams({
      modelId: modelId,
      phrase: phrase
    });
    action.setCallback(this, function(a) {
      var event = component.getEvent("waitingEvent");
      event.fire();
      var state = a.getState();
      console.log(state);
      if (state === "ERROR") {
        var errors = a.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            alert("An error has occurred: " + errors[0].message);
          }
        }
        console.log(errors);
        return;
      }
      var result = a.getReturnValue();
      var rawPredictions = JSON.stringify(result, null, 4);
      var predictions = [];
      if (result && result.probabilities.length) {
        for (var i = 0; i < result.probabilities.length; i++) {
          predictions.push({
            label: result.probabilities[i].label,
            formattedProbability:
              "" + Math.round(result.probabilities[i].probability * 100) + "%"
          });
        }
        component.set("v.predictions", predictions);
        component.set("v.rawPredictions", rawPredictions);
      }
    });
    component.set("v.predictions", null);
    component.set("v.rawPredictions", null);
    var event = component.getEvent("waitingEvent");
    event.fire();
    $A.enqueueAction(action);
  }
});
