public class Einstein_Probability {

    @AuraEnabled
    public String label {get; set;}
    @AuraEnabled
    public Double probability {get; set;}

    @AuraEnabled
    public BoundingBox boundingBox {get; set;}

    public class BoundingBox {
        @AuraEnabled
        public Integer minX {get; set;}
        @AuraEnabled
        public Integer minY {get; set;}
        @AuraEnabled
        public Integer maxX {get; set;}
        @AuraEnabled
        public Integer maxY {get; set;}
    }

}