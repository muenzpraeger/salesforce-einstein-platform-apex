public class Einstein_HttpBodyPartFeedbackExample extends Einstein_HttpBodyPart {

    public enum Types {
        BASE64,
        DOCUMENT
    }

    private String data;
    private String expectedLabel;
    private String modelId;
    private String name;
    private Types types;

    public Einstein_HttpBodyPartFeedbackExample(String name, String expectedLabel, String modelId, String data, Einstein_HttpBodyPartFeedbackExample.Types types) {
        setName(name);
        setExpectedLabel(expectedLabel);
        setModelId(modelId);
        setData(data);
        setType(types);
    }

    public Blob build() {
        String body = '';
        body += WriteBoundary();
        if (!String.isEmpty(name)) {
            body += WriteBodyParameter('name', name);
            body += WriteBoundary();
        }
        body += WriteBodyParameter('expectedLabel', expectedLabel);
        body += WriteBoundary();
        body += WriteBodyParameter('modelId', modelId);
        body += WriteBoundary();
        if (types==Einstein_HttpBodyPartFeedbackExample.Types.BASE64) {
            body += WriteBlobBodyParameter('data', data, name);
        } else if (types==Einstein_HttpBodyPartFeedbackExample.Types.DOCUMENT) {
            body += WriteBodyParameter('document', data);
        }
        body += WriteBoundary(EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        return bodyBlob;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        if (!String.isEmpty(name)) {
            if (name.length()>180) {
                throw new Einstein_StringTooLongException('name', 180, name.length());
            }
        }
        this.name = name;
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

    public String getModelId() {
        return modelId;
    }

    public void setModelId(String modelId) {
        if (String.isEmpty(modelId)) {
            throw new Einstein_StringIsEmptyException('modelId');
        }
        this.modelId = modelId;
    }

    public String getExpectedLabel() {
        return expectedLabel;
    }

    public void setExpectedLabel(String expectedLabel) {
        if (String.isEmpty(expectedLabel)) {
            throw new Einstein_StringIsEmptyException('expectedLabel');
        }
        this.expectedLabel = expectedLabel;
    }

    public Types getType() {
        return types;
    }

    public void setType(Einstein_HttpBodyPartFeedbackExample.Types types) {
        this.types = types;
    }

}