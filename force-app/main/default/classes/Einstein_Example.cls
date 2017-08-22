public class Einstein_Example {

    @AuraEnabled
    public Integer id {get; set;}
    @AuraEnabled
    public String name {get; set;}
    @AuraEnabled
    public DateTime createdAt {get; set;}
    @AuraEnabled
    public Einstein_Label label {get; set;}
    @AuraEnabled
    public String location {get; set;}

    public enum Types {
        ALL,
        FEEDBACK,
        UPLOAD
    }

}