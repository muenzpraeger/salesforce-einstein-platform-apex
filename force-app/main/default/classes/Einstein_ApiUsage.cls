public with sharing class Einstein_ApiUsage {
   
   @AuraEnabled 
   public String id {get; set;}
   @AuraEnabled
   public String organizationId {get; set;}
   @AuraEnabled
   public String startsAt {get; set;}
   @AuraEnabled
   public String endsAt {get; set;}
   @AuraEnabled
   public String licenseId {get; set;}
   @AuraEnabled
   public long predictionsMax {get; set;}
   @AuraEnabled
   public long predictionsRemaining {get; set;}
   @AuraEnabled
   public long predictionsUsed {get; set;}
   @AuraEnabled
   public Einstein_PlanData[] planData {get; set;}
    
}