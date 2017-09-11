({
  changeSpinner: function(component) {
    var spinner = component.get("v.spinnerWaiting");
    component.set("v.spinnerWaiting", !spinner);
  },
  updateModelSelection: function(component, event, helper) {
    helper.updateModelSelection(component, event);
  },
  doInitPlayground: function(component, event, helper) {
    var modelsDefaultImageclassification = [
      { id: "FoodImageClassifier", label: "Pre-Build - Food Image Classifier" },
      {
        id: "GeneralImageClassifier",
        label: "Pre-Build - General Image Classifier"
      },
      { id: "SceneClassifier", label: "Pre-Build - Scene Image Classifier" },
      {
        id: "MultiLabelImageClassifier",
        label: "Pre-Build - Multi-Label Image Classifier"
      }
    ];
    component.set(
      "v.datasetModelsImageClassification",
      modelsDefaultImageclassification
    );
    var modelsDefaultSentiment = [
      { id: "CommunitySentiment", label: "Pre-Build - Community Sentiment" }
    ];
    component.set("v.datasetModelsSentiment", modelsDefaultSentiment);
    var action = component.get("c.validateEinsteinPlatformSetup");
		action.setCallback(this, function(a) {
      var result = a.getReturnValue();
      component.set("v.setupComplete", result.einsteinEmail==true && result.einsteinFile==true);
			component.set("v.einsteinEmail", result.einsteinEmail);
      component.set("v.einsteinFile", result.einsteinFile);
		});
		$A.enqueueAction(action);
  }
});
