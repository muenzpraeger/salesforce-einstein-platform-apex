public class Einstein_HttpBodyPartPrediction extends Einstein_HttpBodyPart {
    
    public enum Types {
        BASE64,
        FILEBLOB,
        URL,
        DOCUMENT
    }
    
    private String modelId;
    private String data;
    private String sampleId;
    private Types type;
    private Integer numResults;

    public Einstein_HttpBodyPartPrediction(String modelId, String data, Integer numResults, String sampleId, Einstein_HttpBodyPartPrediction.Types type) {
        setModelId(modelId);
        setData(data);
        setNumResults(numResults);
        setSampleId(sampleId);
        setType(type);
    }
    
    public Blob build() {
        String body = '';
        body += WriteBoundary();
        body += WriteBodyParameter('modelId', modelId);
        if (String.isEmpty(sampleId)) {
            body += WriteBoundary();
            body += WriteBodyParameter('sampleId', sampleId);
        }
        body += WriteBoundary();
        if (type==Types.BASE64) {
            body += WriteBodyParameter('sampleBase64Content', data);
        } else if (type==Types.URL) {
            body += WriteBodyParameter('sampleLocation', data);
        } else if (type==Types.DOCUMENT) {
            body += WriteBodyParameter('document', data);
        }
        if (numResults>0) {
            body += WriteBoundary();
            body += WriteBodyParameter('numResults', numResults);
        }
        body += WriteBoundary(EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        return bodyBlob;
    }
    
    public String getModelId() {
        return modelId;
    }

    public void setModelId(String modelId) {
        this.modelId = modelId;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getSampleId() {
        return sampleId;
    }

    public void setSampleId(String sampleId) {
        this.sampleId = sampleId;
    }

    public Types getType() {
        return type;
    }

    public void setType(Types type) {
        this.type = type;
    }

    public Integer getNumResults() {
        return numResults;
    }

    public void setNumResults(Integer numResults) {
        this.numResults = numResults;
    }

}