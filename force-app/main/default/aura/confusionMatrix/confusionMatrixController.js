({

	doInit: function (component) {
		let matrix = component.get("v.matrix");
		matrix.forEach((value)=>{
			if ($A.util.isArray(value)){
				component.set("v.matrixType", "array")
			} else {
				component.set("v.matrixType", "number")
			}
		});
	},

	showPopover : function(component, event) {
		let item = component.get("v.matrix")[event.target.id];

		$A.createComponent(
			"c:examplesDetail",
			{"detail" : item.examples},
			function(content, status){
				if (status==="SUCCESS"){
					//calculate the header
					let header;
					if (item.expected === item.predicted){
						header = 'Correctly Predicted as ' + item.expected;
					} else {
						header = 'Prediction is ' + item.predicted + ' but should have been ' + item.expected;
					}
					component.find('overlayLib').showCustomModal({
						header: header,
						body: content,
						showCloseButton: true
					});
				} else {
					console.log(status);
				}
			}
		);
	},
})
