public with sharing class Einstein_PlanData {
    
    @AuraEnabled
    public String plan {get; set;}
    @AuraEnabled
    public String source {get; set;}
    @AuraEnabled
    public Long amount {get; set;}
    
}