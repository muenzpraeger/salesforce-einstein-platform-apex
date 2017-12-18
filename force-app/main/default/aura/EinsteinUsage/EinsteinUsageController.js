({
	doInit : function(component, event, helper) {
		let action = component.get("c.getUsage");
		action.setCallback(this, function(a){
			let state = a.getState();
			if (state === "SUCCESS") {
				console.log(a.getReturnValue());
				component.set("v.usage", a.getReturnValue());
			}  else if (state === "ERROR") {
				component.find("leh").passErrors(a.getError());
			}
		});
		$A.enqueueAction(action);
	}
})