({
  updateModelSelection: function(component, event) {
    var type = event.getParam("type");
    if (type == "image" || type == "image-multi-label") {
      this.validateModelContent(
        component,
        "v.datasetModelsImageClassification",
        event
      );
    } else if (type == "image-detection") {
      this.validateModelContent(component, "v.datasetModelsObjectDetection", event);
    } else if (type == "text-intent") {
      this.validateModelContent(component, "v.datasetModelsIntent", event);
    } else if (type == "text-sentiment") {
      this.validateModelContent(component, "v.datasetModelsSentiment", event);
    }
  },
  validateModelContent: function(component, componentName, event) {
    var modelComponent = component.get(componentName);
    var models = event.getParam("models");
    for (var i = 0; i < models.length; i++) {
      if (models[i].progress == 1) {
        var data = modelComponent.filter(function(model) {
          return model.id === models[i].modelId;
        });
        if (data.length == 0) {
          var model = {};
          model.id = models[i].modelId;
          model.label = models[i].datasetId + " - " + models[i].modelId;
          modelComponent.push(model);
        }
      }
    }
    component.set(componentName, modelComponent);
  }
});
