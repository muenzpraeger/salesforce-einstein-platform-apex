({
  changeSpinner: function(component) {
    var spinner = component.get("v.spinnerWaiting");
    component.set("v.spinnerWaiting", !spinner);
  },
  updateModelSelection: function(component, event, helper) {
    helper.updateModelSelection(component, event);
  },
  doInitModels: function(component, event, helper) {
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
  }
});
