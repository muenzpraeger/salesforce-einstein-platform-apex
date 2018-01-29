({
    doInit : function(component, event, helper) {
        // are there defaults for this datatype?

        console.log(component.get("v.allModels"));

        let dataType = component.get("v.dataType");
        let models = [];
        if (dataType === 'image'){
            models.push({ id: "GeneralImageClassifier", label: "Pre-Built - General Image Classifier" });
            models.push({ id: "FoodImageClassifier", label: "Pre-Built - Food Image Classifier" });
            models.push({ id: "SceneClassifier", label: "Pre-Built - Scene Image Classifier" });
        } else if (dataType === 'text-sentiment'){
            models.push({ id: "CommunitySentiment", label: "Pre-Built - Community Sentiment" });
        } else if (dataType === 'image-multi-label') {
            models.push({ id: "MultiLabelImageClassifier", label: "Pre-Built - Multi-Label Image Classifier" });
        }

        // add any custom models to the default if they exist
        if (component.get("v.allModels")[dataType] && component.get("v.allModels")[dataType].length>0){
            models = models.concat(component.get("v.allModels")[dataType]);
        }

        // if there are any models, make the first one selected
        if (models.length>0){
            models[0].selected = true;
            component.set("v.modelId", models[0].id);
        }
        component.set("v.selectionModels", models);

    },

    valueChanged : function(component, event, helper) {
        component.set("v.modelId", component.find("selectModel").get("v.value"));
    },

})
