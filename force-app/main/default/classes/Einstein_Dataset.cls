public class Einstein_Dataset {
    
    @AuraEnabled
    public Long id {get; set;}
    @AuraEnabled
    public String name {get; set;}
    @AuraEnabled
    public DateTime createdAt {get; set;}
    @AuraEnabled
    public DateTime updatedAt {get; set;}
    @AuraEnabled
    public Einstein_LabelSummary labelSummary {get; set;}
    @AuraEnabled
    public Long totalExamples {get; set;}
    @AuraEnabled
    public Long totalLabels {get; set;}
    @AuraEnabled
    public Boolean available {get; set;}
    @AuraEnabled
    public String statusMsg {get; set;}
    @AuraEnabled
    public String type {get; set;}

    public enum Types {
        ALL,
        FEEDBACK,
        UPLOAD
    }

}