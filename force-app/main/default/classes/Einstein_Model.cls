public class Einstein_Model {

    @AuraEnabled
    public Long datasetId {get; set;}
    @AuraEnabled
    public String name {get; set;}
    @AuraEnabled
    public String status {get; set;}
    @AuraEnabled
    public Decimal progress {get; set;}
    @AuraEnabled
    public DateTime createdAt {get; set;}
    @AuraEnabled
    public DateTime updatedAt {get; set;}
    @AuraEnabled
    public Double learningRate {get; set;}
    @AuraEnabled
    public Integer epochs {get; set;}
    @AuraEnabled
    public Integer queuePosition {get; set;}
    @AuraEnabled
    public String modelId {get; set;}
    @AuraEnabled
    public String failureMsg {get; set;}
    @AuraEnabled
    public Integer datasetVersionId {get; set;}
    @AuraEnabled
    public String modelType {get; set;}
    @AuraEnabled
    public Einstein_TrainParams trainParams {get; set;}
    @AuraEnabled
    public Einstein_TrainStats trainStats {get; set;}
    @AuraEnabled
    public String type {get; set;}
}