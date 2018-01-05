public class Einstein_ModelLearningCurve {
    
    @AuraEnabled
    public Integer epoch {get; set;}
    @AuraEnabled
    public Object epochResults {get; set;}
    @AuraEnabled
    public Einstein_ModelMetrics metricsData {get; set;}
    
}