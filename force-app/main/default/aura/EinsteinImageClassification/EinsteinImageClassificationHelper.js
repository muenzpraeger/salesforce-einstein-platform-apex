({
  upload: function(component, fileName, base64Data) {
    var action = component.get("c.predictImageClassification");
    var modelId = component.get("v.modelId");
    action.setParams({
      modelId: modelId,
      base64: base64Data
    });
    action.setCallback(this, function(a) {
      component.set("v.spinnerWaiting", false);
      var state = a.getState();
      console.log(state);
      if (state === "ERROR") {
        console.log(a.getError());
        alert("An error has occurred");
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
    component.set("v.spinnerWaiting", true);
    $A.enqueueAction(action);
  }
});