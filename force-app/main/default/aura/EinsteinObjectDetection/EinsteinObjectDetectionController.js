({
  readFile: function(component, event, helper) {
    var files = component.get("v.files");
    if (files && files.length > 0) {
      var file = files[0][0];
      if (file.size>5000000) {
        return alert("The file exceeds the limit of 5MB.");
      }
      var reader = new FileReader();
      reader.onloadend = function() {
        var dataURL = reader.result;
        component.set("v.pictureSrc", dataURL);
        component.set("v.fileName", file.name);
        helper.upload(component, file.name, dataURL.match(/,(.*)$/)[1]);
      };
      reader.readAsDataURL(file);
    }
  },
  modelChange: function(component) {
    var models = component.get("v.selectionModels");
    if (models.length===1) {
      component.set("v.modelId", models[0].id);
    }
  }
});