public class Einstein_HttpBodyPartExample extends Einstein_HttpBodyPart {

    private long labelId;
    private String data;
    private String name;
    
    public Einstein_HttpBodyPartExample(String name, long labelId, String data) {
        setName(name);
        setLabelId(labelId);
        setData(data);
    }
    
    public Blob build() {
        String body = '';
        body += WriteBoundary();
        body += WriteBodyParameter('name', name);
        body += WriteBoundary();
        body += WriteBodyParameter('labelId', String.valueOf(labelId));
        body += WriteBoundary();
        body += WriteBlobBodyParameter('data', data, name);
        body += WriteBoundary(EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        return bodyBlob;
    }
    
    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (String.isEmpty(name)) {
            throw new Einstein_StringIsEmptyException('name');
        }
        if (name.length()>180) {
            throw new Einstein_StringTooLongException('name', 180, name.length());
        }
        this.name = name;
    }

    public long getLabelId() {
        return labelId;
    }

    public void setLabelId(long labelId) {
        if (labelId<1) {
            throw new Einstein_NullPointerException('Labels cannot be null');
        }
        this.labelId = labelId;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        if (String.isEmpty(data)) {
            throw new Einstein_StringIsEmptyException('data');
        }
        this.data = data;
    }
    
}