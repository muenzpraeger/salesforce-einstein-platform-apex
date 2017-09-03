public class Einstein_TrainStats {

    @AuraEnabled
	public Integer labels {get;set;}
    @AuraEnabled
    public Integer examples {get;set;}
    @AuraEnabled
    public String totalTime {get;set;}
    @AuraEnabled
    public Transforms transforms {get;set;}
    @AuraEnabled
    public String trainingTime {get;set;}
    @AuraEnabled
    public Boolean earlyStopping {get;set;}
    @AuraEnabled
    public Integer lastEpochDone {get;set;}
    @AuraEnabled
    public String modelSaveTime {get;set;}
    @AuraEnabled
    public Integer testSplitSize {get;set;}
    @AuraEnabled
    public Integer trainSplitSize {get;set;}
    @AuraEnabled
    public String datasetLoadTime {get;set;}
    @AuraEnabled
    public String preProcessStats {get;set;}
    @AuraEnabled
    public String postProcessStats {get;set;}
    

    public class Transforms {
        @AuraEnabled
	    public Boolean toFlip {get;set;}
        @AuraEnabled
	    public Boolean toRotate {get;set;}
        @AuraEnabled
	    public String cropLocation {get;set;} 
    }
}