public class Einstein_HttpBodyPartRetraining extends Einstein_HttpBodyPart {
    
    private String modelId;
    private Integer epochs;
    private Decimal learningRate;
    private Einstein_TrainParams trainParams;
    
    private boolean hasEpochs = true;
    private boolean hasLearningRate = true;
    
    private static Decimal DEFAULT_LEARNING_RATE = 0.0001;
    private static Decimal MIN_LEARNING_RATE = 0.0001;
    private static Decimal MAX_LEARNING_RAGE = 0.01;
    
    public Einstein_HttpBodyPartRetraining(String modelId, Integer epochs, Decimal learningRate, Einstein_TrainParams trainParams) {
        setModelId(modelId);
        setEpochs(epochs);
        setLearningRate(learningRate);
        setTrainParams(trainParams);
    }
    
    public Blob build() {
        String body = '';
        body += WriteBoundary();
        body += WriteBodyParameter('modelId', modelId);
        if (hasEpochs) {
            body += WriteBoundary();
            body += WriteBodyParameter('epochs', String.valueOf(epochs));
        }
        if(hasLearningRate) {
        	body += WriteBoundary();
        	body += WriteBodyParameter('learningRate', String.valueOf(learningRate));
        }
        if (trainParams!=null) {
	        body += WriteBoundary();
            body += WriteBodyParameter('trainParams', JSON.serialize(trainParams, true));
        }
        body += WriteBoundary(EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        return bodyBlob;
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

    public Integer getEpochs() {
        return epochs;
    }

    public void setEpochs(Integer epochs) {
        
        if (epochs==null || epochs==0) {
            hasEpochs = false;
        } else if (epochs>100) {
            throw new Einstein_NumberTooBigException('epochs', 100, epochs);
        }
        this.epochs = epochs;
    }

    public Decimal getLearningRate() {
        return learningRate;
    }

    public void setLearningRate(Decimal learningRate) {
        if (learningRate == null || learningRate==0) {
            hasLearningRate = false;
        } else {
            if (learningRate < MIN_LEARNING_RATE) {
                throw new Einstein_NumberTooSmallException('learningRate', MIN_LEARNING_RATE, learningRate);
            } else if (learningRate > MAX_LEARNING_RAGE) {
                throw new Einstein_NumberTooBigException('learningRate', MAX_LEARNING_RAGE, learningRate);
            }
        }
        this.learningRate = learningRate;
    }

    public Einstein_TrainParams getTrainParams() {
        return trainParams;
    }

    public void setTrainParams(Einstein_TrainParams trainParams) {
        this.trainParams = trainParams;
    }

}
