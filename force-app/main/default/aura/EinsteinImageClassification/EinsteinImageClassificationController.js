({
  readFile: function(component, event, helper) {
    var files = component.get("v.files");
    if (files && files.length > 0) {
      var file = files[0][0];
      if (!file.type.match(/(image.*)/)) {
        return alert("Image file not supported");
      }
      var reader = new FileReader();
      reader.onloadend = function() {
        var dataURL = reader.result;
        component.set("v.pictureSrc", dataURL);
        component.set("v.fileName", file.name);
      };
      reader.readAsDataURL(file);
    }
  },
  predict: function(component, event, helper) {
    var dataURL = component.get("v.pictureSrc");
    var fileName = component.get("v.fileName");
    helper.upload(component, fileName, dataURL.match(/,(.*)$/)[1]);
  },
  switchDefaultUrl: function(component) {
    component.set(
      "v.defaultUrl",
      component.get("v.imageType") === "image"
        ? "http://einstein.ai/images/mountainvsbeach.zip"
        : "http://einstein.ai/images/mountainvsbeach.zip"
    );
  }
});
