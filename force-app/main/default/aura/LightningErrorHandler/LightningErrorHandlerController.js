({

	handleEvent : function(component, event, helper) {
		if (event.getParam("errorComponentName") && (component.get("v.errorHandlerName") !== event.getParam("errorComponentName"))){
			return;
		}
		if (component.get("v.logErrors")) {console.log(event.getParam("errors"));}
		helper.processErrors(event.getParam("errors"));

	},

	handleMethod : function(component, event, helper) {
		helper.processErrors(event.getParam("arguments").errorObject);
		if (component.get("v.logErrors")) {console.log(event.getParam("errors"));}
	},

	simple : function(component, event, helper) {
		//	toastThis : function(message, title) {
		helper.toastThis(event.getParam("text", "Error"));
	},


})