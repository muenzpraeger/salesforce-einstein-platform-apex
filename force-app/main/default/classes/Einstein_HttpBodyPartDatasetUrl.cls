public with sharing class Einstein_HttpBodyPartDatasetUrl extends Einstein_HttpBodyPart {

    private String url;
    private String type;
    
    public Einstein_HttpBodyPartDatasetUrl(String url, String type)  {
        if (url==null || url.equals('')) {
            throw new Einstein_StringIsEmptyException('url');
        }
        if (type==null || type.equals('')) {
            throw new Einstein_StringIsEmptyException('type');
        }
        this.url = url;
        this.type = type;
    }
    
    public Blob build() {
        String body = '';
        body += WriteBoundary();
        body += WriteBodyParameter('path', url);
        body += WriteBoundary();
        body += WriteBodyParameter('type', type);
        body += WriteBoundary(EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        return bodyBlob;
    }
    
    public String getUrl() {
        return url;
    }

    public void setUrl(String url)  {
        if (url==null || url.equals('')) {
            throw new Einstein_StringIsEmptyException('url');
        }
        this.url = url;
    }
    
}