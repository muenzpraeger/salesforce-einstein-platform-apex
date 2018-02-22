({
  changeSpinner: function(component) {
    var spinner = component.get("v.spinnerWaiting");
    component.set("v.spinnerWaiting", !spinner);
  },

  updateModelSelection: function (component, event, helper) {
    helper.updateModelSelection(component, event);
  },

  doInitPlayground: function(component, event, helper) {
    component.set("v.modelsByType", {});
  }
});