({
	showPopover : function(component, event) {
		let item = component.get("v.matrix")[event.target.id];

		$A.createComponent(
			"c:examplesDetail",
			{"detail" : item.examples},
			function(content, status){
				if (status==="SUCCESS"){
					component.find('overlayLib').showCustomModal({
						header: 'Should be: ' + item.expected + ', Predicted: ' + item.predicted,
						// header: `Should be: ${item.expected}, Predicted: ${item.predicted}`,
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
