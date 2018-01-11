public class Einstein_TrainParams {
    
    @AuraEnabled
    public Decimal trainSplitRatio {get; set;}
    @AuraEnabled
	public Boolean withFeedback {get; set;}
    @AuraEnabled
    public Long withGlobalDatasetId {get; set;}

}
