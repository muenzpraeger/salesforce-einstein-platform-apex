public class Einstein_ModelLearningCurve {
    
    @AuraEnabled
    public Integer epoch {get; set;}
    @AuraEnabled
    public List<Einstein_EpochResult> epochResults {get; set;}
    @AuraEnabled
    public Einstein_ModelMetrics modelMetrics {get; set;}
    
}