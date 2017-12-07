
({
	/*
	cmp : pass in the component itself
	action : an action , like an apex server-side action
	  - setParams before passing in the object
	  - add any other settings to the action (e.g., setStorable())
	*/
	executeAction: function(cmp, action) {

		return new Promise(function(resolve, reject) {
			action.setCallback(this, function(a) {
				let state = a.getState();
				if (state === "SUCCESS") {
					resolve(a.getReturnValue());
				}
				else if (state === "ERROR") {
					console.log(a.getError());
					cmp.getSuper().find('leh').passErrors(a.getError());
					reject(Error(a.getError()));
				} else if (state === "INCOMPLETE"){
					let miss = [{
						"pageErrors" : [{"message" : "No Connection Available"}]
					}];
					cmp.getSuper().find('leh').passErrors(miss);
					reject(Error(miss));
				}

			});
			$A.enqueueAction(action);
		});
	},

	/*
	same usage as above, except use when your apex class returns string from JSON.serialize instead of actual objects
	*/
	executeActionJSON: function(cmp, action) {

		return new Promise(function(resolve, reject) {
			action.setCallback(this, function(a) {
				let state = a.getState();
				if (state === "SUCCESS") {
					resolve(JSON.parse(a.getReturnValue()));
				}
				else if (state === "ERROR") {
					cmp.getSuper().find('leh').passErrors(a.getError());
					reject(Error(a.getError()));
				} else if (state === "INCOMPLETE"){
					let miss = [{
						"pageErrors" : [{"message" : "No Connection Available"}]
					}];
					cmp.getSuper().find('leh').passErrors(miss);
					reject(Error(miss));
				}
			});
			$A.enqueueAction(action);
		});
	},

})