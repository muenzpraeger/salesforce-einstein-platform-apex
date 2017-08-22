/**
* Demo class that showcases how to use the Einstein Platform Apex wrappers.
*
* For creating a valid access token please refer to the Einstein Platform documentation:
* 
* Authorization via Apex: https://metamind.readme.io/docs/apex_qs_scenario
* Authorization via Website: https://metamind.readme.io/docs/set-up-auth
*
*/
public with sharing class Einstein_UI_Demo {
    
    /**
    * This method reads all trained examples from your Einstein Platform account.
    */
    @AuraEnabled
    public static List<Einstein_Example> readDemoExamples() {
        Einstein_PredictionService service = new Einstein_PredictionService('enterYourTokenHere', Einstein_PredictionService.Types.IMAGE);
        List<Einstein_Dataset> datasets = service.getDatasets();
        List<Einstein_Example> examples = service.getExamples(datasets[0].id);
        return examples;
    }
	    
    /**
    * This method predicts a given URL based on the Einstein Vision General Image Classifier.
    *
    * https://metamind.readme.io/v1/page/general-image-model-class-list
    *
    */
    @AuraEnabled
    public static List<Einstein_Probability> predictUrl(String url) {
        Einstein_PredictionService service = new Einstein_PredictionService('enterYourTokenHere', Einstein_PredictionService.Types.IMAGE);
        Einstein_PredictionResult result = service.predictImageUrl('GeneralImageClassifier', url, 5, '');
        return result.probabilities;
    }
    
}