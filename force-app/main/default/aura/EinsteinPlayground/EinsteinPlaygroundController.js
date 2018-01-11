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
    var action = component.get("c.validateEinsteinPlatformSetup");
		action.setCallback(this, function(a) {
      var result = a.getReturnValue();
      component.set("v.setupComplete", result.einsteinEmail==true && result.einsteinCert==true);
			component.set("v.einsteinEmail", result.einsteinEmail);
      component.set("v.einsteinCert", result.einsteinCert);
		});
		$A.enqueueAction(action);
  }
});
