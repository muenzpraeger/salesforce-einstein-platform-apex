public class Einstein_ModelMetrics {

    @AuraEnabled
    public List<Double> f1 {get; set;}
    @AuraEnabled
    public Double testAccuracy {get; set;}
    @AuraEnabled
    public Double trainingLoss {get; set;}
    @AuraEnabled
    public List<List<Integer>> confusionMatrix {get; set;}
    @AuraEnabled
    public Double trainingAccuracy {get; set;}
    @AuraEnabled
    public List<String> labels {get; set;}

}