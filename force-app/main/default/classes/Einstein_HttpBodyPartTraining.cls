public class Einstein_HttpBodyPartTraining extends Einstein_HttpBodyPart {
    
    private Long datasetId;
    private String name;
    private Integer epochs;
    private Decimal learningRate;
    private String trainParams;
    
    private boolean hasEpochs = true;
    
    private static Decimal DEFAULT_LEARNING_RATE = 0.0001;
    private static Decimal MIN_LEARNING_RATE = 0.0001;
    private static Decimal MAX_LEARNING_RAGE = 0.01;
    
    public Einstein_HttpBodyPartTraining(Long datasetId, String name, Integer epochs, Decimal learningRate, String trainParams) {
        if (datasetId == 0) {
            throw new Einstein_NoValuesException('datasetId');
        }
        if (name==null || name.equals('')) {
            throw new Einstein_StringIsEmptyException('name');
        }
        if (name.length()>180) {
            throw new Einstein_StringTooLongException('name', 180, name.length());
        }
        if (epochs==0) {
            hasEpochs = false;
        } else if (epochs>100) {
            throw new Einstein_NumberTooBigException('epochs', 100, epochs);
        }
        if (learningRate==0) {
            learningRate = DEFAULT_LEARNING_RATE;
        } else {
            if (learningRate < MIN_LEARNING_RATE) {
                throw new Einstein_NumberTooSmallException('learningRate', MIN_LEARNING_RATE, learningRate);
            } else if (learningRate > MAX_LEARNING_RAGE) {
                throw new Einstein_NumberTooBigException('learningRate', MAX_LEARNING_RAGE, learningRate);
            }
        }
        this.datasetId = datasetId;
        this.name = name;
        this.epochs = epochs;
        this.learningRate = learningRate;
        this.trainParams = trainParams;
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
        body += WriteBoundary();
        body += WriteBodyParameter('learningRate', String.valueOf(learningRate));
        if (trainParams!=null && !trainParams.equals('')) {
	        body += WriteBoundary();
            body += WriteBodyParameter('trainParams', trainParams);
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
        if (name==null || name.equals('')) {
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
        if (epochs==0) {
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
        if (learningRate==0) {
            learningRate = DEFAULT_LEARNING_RATE;
        } else {
            if (learningRate < MIN_LEARNING_RATE) {
                throw new Einstein_NumberTooSmallException('learningRate', MIN_LEARNING_RATE, learningRate);
            } else if (learningRate > MAX_LEARNING_RAGE) {
                throw new Einstein_NumberTooBigException('learningRate', MAX_LEARNING_RAGE, learningRate);
            }
        }
        this.learningRate = learningRate;
    }

}