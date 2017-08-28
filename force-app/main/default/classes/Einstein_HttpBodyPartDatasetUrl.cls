public with sharing class Einstein_HttpBodyPartDatasetUrl extends Einstein_HttpBodyPart {

    private String url;
    private String type;
    
    public Einstein_HttpBodyPartDatasetUrl(String url, String type)  {
        setUrl(url);
        setType(type);
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
        if (String.isEmpty(url)) {
            throw new Einstein_StringIsEmptyException('url');
        }
        this.url = url;
    }

    public String getType() {
        return url;
    }

    public void setType(String type)  {
        if (String.isEmpty(type)) {
            throw new Einstein_StringIsEmptyException('type');
        }
        this.type = type;
    }
    
}