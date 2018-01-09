public class Einstein_ModelLearningCurve {
    
    @AuraEnabled
    public Integer epoch {get; set;}
    @AuraEnabled
    public Map<String, Object> epochResults {get; set;}
    @AuraEnabled
    public Einstein_ModelMetrics metricsData {get; set;}
    
}