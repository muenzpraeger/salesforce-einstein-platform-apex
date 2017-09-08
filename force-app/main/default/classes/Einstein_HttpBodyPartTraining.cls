public class Einstein_HttpBodyPartTraining extends Einstein_HttpBodyPart {
    
    private Long datasetId;
    private String name;
    private Integer epochs;
    private Decimal learningRate;
    private Einstein_TrainParams trainParams;
    
    private boolean hasEpochs = true;
    private boolean hasLearningRate = true;
    
    private static Decimal DEFAULT_LEARNING_RATE = 0.0001;
    private static Decimal MIN_LEARNING_RATE = 0.0001;
    private static Decimal MAX_LEARNING_RAGE = 0.01;
    
    public Einstein_HttpBodyPartTraining(Long datasetId, String name, Integer epochs, Decimal learningRate, Einstein_TrainParams trainParams) {
        setDatasetId(datasetId);
        setName(name);
        setEpochs(epochs);
        setLearningRate(learningRate);
        setTrainParams(trainParams);
    }

    public Blob build() {
        String body = '';
        body += WriteBoundary();
        body += WriteBodyParameter('name', name);
        body += WriteBoundary();
        body += WriteBodyParameter('datasetId', String.valueOf(datasetId));
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

    public Long getDatasetId() {
        return datasetId;
    }

    public void setDatasetId(Long datasetId) {
        if (datasetId == 0) {
            throw new Einstein_NoValuesException('datasetId');
        }
        this.datasetId = datasetId;
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