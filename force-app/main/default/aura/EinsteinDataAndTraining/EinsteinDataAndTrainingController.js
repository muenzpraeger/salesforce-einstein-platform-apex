({
  onLoadDatasets: function(component, event, helper) {
    helper.onLoadDatasets(component);
  },

  messageHandler : function(component, event, helper) {
    console.log("heard new message");
    if (event.getParam("channel") === 'EinsteinDatasetCreation' && event.getParam("message")=== 'newDataset'){
      helper.onLoadDatasets(component);
    }
  },
});