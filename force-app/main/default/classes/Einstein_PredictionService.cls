public class Einstein_PredictionService {

    // Base URL for the PredictionService
    private static String BASE_URL = 'https://api.einstein.ai/v2';

    private String API_USAGE = BASE_URL + '/apiusage';
    private static String OAUTH2 = BASE_URL + '/oauth2/token';

    private boolean isExecuting = false;
    private String bearerToken = '';
    public Integer httpStatusCode = 0;
    public String httpErrorMessage = '';
    private Types typeEnum;
    private String typeString;
    public String baseUrl;

    public enum Types {
        IMAGE,
        IMAGE_MULTI_LABEL,
        IMAGE_DETECTION,
        SENTIMENT,
        INTENT
    }

    /**
    * <p>Create a new object of type Einstein_PredictionService.</p>
    *
    * <p>The Einstein_PredictionService is the foundation for communicating with the Salesforce Einstein Platform API.
    *
    * @param typeEnum
    * An Enum of type Einstein_PredictionService.Types which defines the type of prediction (image, image-multi-model, sentiment or intent).
    */
    public Einstein_PredictionService(Einstein_PredictionService.Types typeEnum) {
        this.bearerToken = getAccessToken();
        this.typeEnum = typeEnum;
        this.baseUrl = resolveBaseUrl();
        this.typeString = resolveType();
    }

    /**
    * <p>Create a new object of type Einstein_PredictionService.</p>
    *
    * <p>The Einstein_PredictionService is the foundation for communicating with the Salesforce Einstein Platform API.
    *
    * @param bearerToken
    * A valid Bearer token
    * @param typeEnum
    * An Enum of type Einstein_PredictionService.Types which defines the type of prediction (image, image-multi-model, sentiment or intent).
    */
    public Einstein_PredictionService(String bearerToken, Einstein_PredictionService.Types typeEnum) {
        this.bearerToken = bearerToken;
        this.typeEnum = typeEnum;
        this.baseUrl = resolveBaseUrl();
        this.typeString = resolveType();
    }

    /**
    * Creates a new dataset with data from a remote file (async call).
    * @param url
    * The remote URL of the to be trained data.
    * @return
    * An object of type Einstein_Dataset
    */
    public Einstein_Dataset createDatasetFromUrlAsync(String url) {
        System.debug('Starting createDatasetFromUrlAsync call from URL ' + url + ' for type ' + typeString + '.');
        Einstein_HttpBodyPartDatasetUrl parts = new Einstein_HttpBodyPartDatasetUrl(url, typeString);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/upload', parts.build());
        client.isPost(true);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call createDatasetFromUrlAsync has been executed.');
        if (!client.isError()) {
            Einstein_Dataset dataset = (Einstein_Dataset)client.getParser().readValueAs(Einstein_Dataset.class);
            System.debug('New dataset with id ' + dataset.id + ' has been created.');
            return dataset;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Creates a new dataset with data from a remote file (sync call).
    * @param url
    * The remote URL of the to be trained image.
    * @return
    * An object of type Einstein_Dataset
    */
    public Einstein_Dataset createDatasetFromUrlSync(String url) {
        System.debug('Starting createDatasetFromUrlSync call from URL ' + url + ' for type ' + typeString + '.');
        Einstein_HttpBodyPartDatasetUrl parts = new Einstein_HttpBodyPartDatasetUrl(url, typeString);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/upload/sync', parts.build());
        client.isPost(true);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call createDatasetFromUrlSync has been executed.');
        if (!client.isError()) {
            Einstein_Dataset dataset = (Einstein_Dataset)client.getParser().readValueAs(Einstein_Dataset.class);
            System.debug('New dataset with id ' + dataset.id + ' has been created.');
            return dataset;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Gets an existing Einstein_Dataset.
    * @param id
    * The id of the Einstein_Dataset that needs to be fetched.
    * @return
    * An object of type Einstein_Dataset
    */
    public Einstein_Dataset getDataset(Long id) {
        if (id==0) {
            throw new Einstein_NoValuesException('datasetId');
        }
        System.debug('Starting getDataset call with parameter ' + id);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + id);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getDataset has been executed.');
        if (!client.isError()) {
            Einstein_Dataset dataset = (Einstein_Dataset)client.getParser().readValueAs(Einstein_Dataset.class);
            System.debug('Dataset has been read.');
            return dataset;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Gets the globally, by Salesforce provided, datasets.
    * @return
    * An array of type Einstein_Dataset
    */
    public Einstein_Dataset[] getGlobalDatasets() {
        return getDatasets(25, 0, Einstein_Dataset.Types.ALL, true);
    }

    /**
    * Gets all Einstein_Datasets.
    * @return
    * An array of type Einstein_Dataset
    */
    public Einstein_Dataset[] getDatasets() {
        return getDatasets(25, 0, Einstein_Dataset.Types.ALL);
    }

    /**
    * Gets datasets based on the provided parameter for pagination and type.
    * @param count
    * Defines the number of objects that should be returned for this call. Maximum is 25.
    * @param offset
    * The offset count for dataset pagination.
    * @param typeEnum
    * The type of data that should be fetched. Either all datasets, feedback or upload.π
    * @return
    * An array of type Einstein_Dataset
    */
    public Einstein_Dataset[] getDatasets(Integer count, Integer offset, Einstein_Dataset.Types typeEnum) {
        return getDatasets(count, offset, typeEnum, false);
    }

    private Einstein_Dataset[] getDatasets(Integer count, Integer offset, Einstein_Dataset.Types typeEnum, Boolean isGlobal) {
        System.debug('Starting getDatasets call');
        String queryParameter = 'offset=' + offset + '&count='+ count + resolveEinsteinDatasetType(typeEnum);
        if (isGlobal) {
            queryParameter = 'global=true';
        }
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets?' + queryParameter);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while (isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getDatasets has been executed.');
        if (!client.isError()) {
            Einstein_Dataset[] datasets = (Einstein_Dataset[])client.getParser().readValueAs(Einstein_Dataset[].class);
            System.debug('Datasets have been read.');
            return datasets;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Deletes an existing dataset.
    * @param datasetId
    * The id of the Einstein_Dataset that should be deleted.
    * @return
    * True if the deletion was successful.
    */
    public boolean deleteDataset(Long datasetId) {
        System.debug('Starting deleteDataset call');
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + datasetId);
        client.isDelete(true);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while (isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call deleteDataset has been executed.');
        if (!client.isError()) {
            System.debug('Dataset ' + datasetId + ' has been deleted.');
            return true;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return false;
    }

    /**
    * Adds new image examples for the vision training.
    * @param datasetId
    * The id of the Einstein_Dataset to which the image should be added.
    * @param name
    * The name of the example.
    * @param labelId
    * The id of the label to which the example should be added.
    * @param fileBlob
    * The blog of the to be trained image.
    * @return
    * An object of type Einstein_Example
    */
    public Einstein_Example createExample(Long datasetId, String name, Long labelId, Blob fileBlob) {
        System.debug('Starting createExample call from blob');
        Einstein_HttpBodyPartExample parts = new Einstein_HttpBodyPartExample(name, labelId, EncodingUtil.base64Encode(fileBlob));
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + datasetId + '/examples', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.isPost(true);
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call createExample from blob has been executed.');
        if (!client.isError()) {
            Einstein_Example example = (Einstein_Example)client.getParser().readValueAs(Einstein_Example.class);
            System.debug('New example with id ' + example.id + ' has been created.');
            return example;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Adds new examples for the prediction training via a remote file.
    * @param datasetId
    * The id of the Einstein_Dataset to which the data should be added.
    * @param url
    * The remote URL of the training data source.
    * @return
    * An object of type Einstein_Dataset
    */
    public Einstein_Dataset createExamplesFromUrl(Long datasetId, String url) {
        System.debug('Starting createExamplesFromUrl call from URL ' + url);
        Einstein_HttpBodyPartDatasetUrl parts = new Einstein_HttpBodyPartDatasetUrl(url, this.typeString);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + datasetId + '/upload', parts.build());
        client.isPut(true);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call createExampleFromUrl has been executed.');
        if (!client.isError()) {
            Einstein_Dataset dataset = (Einstein_Dataset)client.getParser().readValueAs(Einstein_Dataset.class);
            System.debug('New examples for dataset with id ' + dataset.id + ' have been created.');
            return dataset;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Adds new image examples for model feedback to vision training.
    * @param name
    * The name of the example.
    * @param expectedLabel
    * The label name to which the feedback image should be added.
    * @param modelId
    * The model id to which the image should be added as feedback.
    * @param fileBlob
    * The blob of the to be trained image.
    * @return
    * An object of type Einstein_Example
    */
    public Einstein_Example createFeedbackImageExample(String name, String expectedLabel, String modelId, Blob fileBlob) {
        System.debug('Starting createFeedbackImageExample call from blob');
        Einstein_HttpBodyPartFeedbackExample parts = new Einstein_HttpBodyPartFeedbackExample(name, expectedLabel, modelId, EncodingUtil.base64Encode(fileBlob), Einstein_HttpBodyPartFeedbackExample.Types.BASE64);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/feedback', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.isPost(true);
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call createFeedbackImageExample from blob has been executed.');
        if (!client.isError()) {
            Einstein_Example example = (Einstein_Example)client.getParser().readValueAs(Einstein_Example.class);
            System.debug('New example with id ' + example.id + ' has been created.');
            return example;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Adds new text for model feedback to language training.
    * @param name
    * The name of the example.
    * @param expectedLabel
    * The label name to which the feedback text should be added.
    * @param modelId
    * The model id to which the image should be added as feedback.
    * @param text
    * The text that should be added.
    * @return
    * An object of type Einstein_Example
    */
    public Einstein_Example createFeedbackLanguageExample(String expectedLabel, String modelId, String text) {
        System.debug('Starting createFeedbackLanguageExample call from text');
        Einstein_HttpBodyPartFeedbackExample parts = new Einstein_HttpBodyPartFeedbackExample('', expectedLabel, modelId, text, Einstein_HttpBodyPartFeedbackExample.Types.DOCUMENT);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/feedback', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.isPost(true);
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call createFeedbackLanguageExample from blob has been executed.');
        if (!client.isError()) {
            Einstein_Example example = (Einstein_Example)client.getParser().readValueAs(Einstein_Example.class);
            System.debug('New example with id ' + example.id + ' has been created.');
            return example;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Gets an array of all Einstein_Examples that are associated with the given dataset id.
    * @param datasetId
    * The id Einstein_Dataset to which the Einstein_Examples are associated.
    * @return
    * An object of type Einstein_Example
    */
    public Einstein_Example[] getExamples(Long datasetId) {
        return getExamples(datasetId, 25, 0, Einstein_Example.Types.ALL);
    }

    /**
    * Gets an array of all Einstein_Examples that are associated with the given dataset id.
    * @param datasetId
    * The id of the Einstein_Dataset to which the Einstein_Examples are associated.
    * @param count
    * Defines the number of objects that should be returned for this call. Maximum is 25.
    * @param offset
    * The offset count for example pagination.
    * @param typeEnum
    * The type of data that should be fetched. Either all datasets, feedback or upload.
    * @return
    * An object of type Einstein_Example
    */
    public Einstein_Example[] getExamples(Long datasetId, Integer count, Integer offset, Einstein_Example.Types typeEnum) {
        System.debug('Starting getExamples call');
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + datasetId + '/examples?offset=' + offset + '&count='+ count + resolveEinsteinExampleType(typeEnum));
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while (isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getExamples has been executed.');
        if (!client.isError()) {
            Einstein_Example[] examples = (Einstein_Example[])client.getParser().readValueAs(Einstein_Example[].class);
            System.debug('Examples have been read.');
            return examples;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Starts the training of a Einstein_Dataset.
    * @param datasetId
    * The Einstein_Dataset id that should be trained.
    * @param name
    * The name of the Einstein_Dataset.
    * @param epochs
    * Optional. The number of training iterations, valid values are between 1-100. Set to 0 if you want to use the default.
    * @param learningRate
    * Optional. The learning rate, valid values are betweed 0.0001 and 0.01. Set to 0 if you want to use the default.
    * @param trainParams
    * Custom training parameters for the training.
    * @return
    * An object of type Einstein_Model
    */
    public Einstein_Model trainDataset(Long datasetId, String name, Integer epochs, Decimal learningRate, Einstein_TrainParams trainParams) {
        System.debug('Starting trainDataset call with name ' + name);
        Einstein_HttpBodyPartTraining parts = new Einstein_HttpBodyPartTraining(datasetId, name, epochs, learningRate, trainParams);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/train', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
        System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call trainDataset has been executed.');
        if (!client.isError()) {
            Einstein_Model model = (Einstein_Model)client.getParser().readValueAs(Einstein_Model.class);
            System.debug('New Model with id ' + model.modelId + ' has been created.');
            return model;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Starts the retraining of a Einstein_Dataset.
    * @param modelId
    * The Einstein_Model id that should be retrained.
    * @param epochs
    * Optional. The number of training iterations, valid values are between 1-100. Set to 0 if you want to use the default.
    * @param learningRate
    * Optional. The learning rate, valid values are betweed 0.0001 and 0.01. Set to 0 if you want to use the default.
    * @param trainParams
    * Custom training parameters for the retraining.
    * @return
    * An object of type Einstein_Model
    */
    public Einstein_Model retrainDataset(String modelId, Integer epochs, Decimal learningRate, Einstein_TrainParams trainParams) {
        System.debug('Starting retrainDataset call with name ' + modelId);
        Einstein_HttpBodyPartRetraining parts = new Einstein_HttpBodyPartRetraining(modelId, epochs, learningRate, trainParams);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/retrain', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call retrainDataset has been executed.');
        if (!client.isError()) {
            Einstein_Model model = (Einstein_Model)client.getParser().readValueAs(Einstein_Model.class);
            System.debug('Model with id ' + model.modelId + ' has been retrained.');
            return model;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Fetches the model for the given id.
    * @param modelId
    * The id of the model that needs to be fetched.
    * @return
    * An object of type Einstein_Model
    */
    public Einstein_Model getModel(String modelId) {
        System.debug('Starting getModel call with parameter ' + modelId);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/train/' + modelId);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getModel has been executed.');
        if (!client.isError()) {
            Einstein_Model model = (Einstein_Model)client.getParser().readValueAs(Einstein_Model.class);
            System.debug('Model status has been read.');
            return model;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Gets the learning curve of a model.
    * @param modelId
    * The model id for which the learning curve should be fetched.
    * @return
    * The JSON response as raw String
    */
    public String getModelLearningCurve(String modelId) {
        System.debug('Starting getModelLearningCurve call with parameter ' + modelId);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/models/' + modelId + '/lc');
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getModelLearningCurve has been executed.');
        if (!client.isError()) {
            String modelLearningCurve = client.getResponseAsString();
            System.debug('ModelLearningCurve has been read.');
            return modelLearningCurve;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Gets the metrics of a model.
    * @param modelId
    * The model id for which the metrics should be fetched.
    * @return
    * The JSON response as raw String
    */
    public String getModelMetrics(String modelId) {
        System.debug('Starting getModelMetrics call with parameter ' + modelId);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/models/' + modelId);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getModelMetrics has been executed.');
        if (!client.isError()) {
            system.debug(client);
            String modelMetrics = client.getResponseAsString();
            System.debug('ModelMetrics have been read.');
            return modelMetrics;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Gets all trained Einstein_Models that are trained for the given Einstein_Dataset id.
    * @param datasetId
    * The Einstein_Dataset id to which the Einstein_Models are assigned.
    * @return
    * An array of type Einstein_Model
    */
    public Einstein_Model[] getModels(Long datasetId) {
        System.debug('Starting getModels call');
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + datasetId + '/models');
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while (isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getModels has been executed.');
        if (!client.isError()) {
            Einstein_Model[] models = (Einstein_Model[])client.getParser().readValueAs(Einstein_Model[].class);
            System.debug('Models have been read.');
            return models;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Predicts the intent of the given text to a trained model.
    * @param modelId
    * The id of the Einstein_Model that should be used for the prediction.
    * @param text
    * The text that should be predicted.
    * @param numResults
    * The number of results that should be max. returned.
    * @param sampleId
    * Optional, can be empty. A string that gets returned as an association with the predicted image.
    * @return
    * An object of type Einstein_PredictionResult.
    */
    public Einstein_PredictionResult predictIntent(String modelId, String text, Integer numResults, String sampleId) {
        System.debug('Starting predict intent call with model ' + modelId);
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, text, numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.DOCUMENT);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/intent', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (!client.isError()) {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been predicted.');
            return predictions;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Predicts the sentiment of the given text to a trained model.
    * @param modelId
    * The id of the Einstein_Model that should be used for the prediction.
    * @param text
    * The text that should be predicted.
    * @param numResults
    * The number of results that should be max. returned.
    * @param sampleId
    * Optional, can be empty. A string that gets returned as an association with the predicted image.
    * @return
    * An object of type Einstein_PredictionResult.
    */
    public Einstein_PredictionResult predictSentiment(String modelId, String text, Integer numResults, String sampleId) {
        System.debug('Starting predict sentiment call with model ' + modelId);
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, text, numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.DOCUMENT);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/sentiment', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (!client.isError()) {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been predicted.');
            return predictions;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Detects objects in the given image in Base64 format based a trained model.
    * @param model
    * The Einstein_Model that should be used for the prediction.
    * @param base64
    * The image that should be used for detecting objects in it.
    * @param numResults
    * The number of results that should be max. returned.
    * @param sampleId
    * Optional. A string that gets returned as an association with the image.
    * @return
    * An object of type Einstein_PredictionResult.
    */
    public Einstein_PredictionResult detectImageBase64(String modelId, String base64, Integer numResults, String sampleId) {
        System.debug('Starting detect call with model ' + modelId + ' for base64');
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, base64, numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.BASE64);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/detect', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call detect has been executed.');
        if (!client.isError()) {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been detected.');
            return predictions;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Detects objects in the given image in Base64 format based a trained model.
    * @param model
    * The Einstein_Model that should be used for the prediction.
    * @param fileBlob
    * The image that should be used for detecting objects in it.
    * @param numResults
    * The number of results that should be max. returned.
    * @param sampleId
    * Optional. A string that gets returned as an association with the image.
    * @return
    * An object of type Einstein_PredictionResult.
    */
    public Einstein_PredictionResult detectImageBlob(String modelId, Blob fileBlob, Integer numResults, String sampleId) {
        System.debug('Starting detect call with model ' + modelId + ' for blob');
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, EncodingUtil.base64Encode(fileBlob), numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.BASE64);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/detect', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (!client.isError()) {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been detected.');
            return predictions;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Detects objects in the given image in Base64 format based a trained model.
    * @param model
    * The Einstein_Model that should be used for the prediction.
    * @param url
    * The image url that should be used for detecting objects in it.
    * @param numResults
    * The number of results that should be max. returned.
    * @param sampleId
    * Optional. A string that gets returned as an association with the image.
    * @return
    * An object of type Einstein_PredictionResult.
    */
    public Einstein_PredictionResult detectImageUrl(String modelId, String url, Integer numResults, String sampleId) {
        System.debug('Starting detect call with model ' + modelId + ' for url');
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, url, numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.URL);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/detect', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (!client.isError()) {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been detected.');
            return predictions;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

   /**
    * Predicts the association of the given image in Base64 format to a trained model.
    * @param model
    * The Einstein_Model that should be used for the prediction.
    * @param base64
    * The image that should be predicted.
    * @param numResults
    * The number of results that should be max. returned.
    * @param sampleId
    * Optional. A string that gets returned as an association with the predicted image.
    * @return
    * An object of type Einstein_PredictionResult.
    */
    public Einstein_PredictionResult predictImageBase64(String modelId, String base64, Integer numResults, String sampleId) {
        System.debug('Starting predict call with model ' + modelId + ' for base64');
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, base64, numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.BASE64);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/predict', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (!client.isError()) {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been predicted.');
            return predictions;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Predicts the association of the given image as Blob to a trained model.
    * @param modelId
    * The Einstein_Model that should be used for the prediction.
    * @param fileBob
    * The image that should be predicted.
    * @param numResults
    * The number of results that should be max. returned.
    * @param sampleId
    * Optional. A string that gets returned as an association with the predicted image.
    * @return
    * An object of type Einstein_PredictionResult.
    */
    public Einstein_PredictionResult predictImageBlob(String modelId, Blob fileBlob, Integer numResults, String sampleId) {
        System.debug('Starting predict call with model ' + modelId + ' for blob');
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, EncodingUtil.base64Encode(fileBlob), numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.BASE64);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/predict', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (!client.isError()) {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been predicted.');
            return predictions;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Predicts the association of the given image on a remote url to a trained model.
    * @param modelId
    * The Einstein_Model that should be used for the prediction.
    * @param url
    * The image url that should be predicted.
    * @param numResults
    * The number of results that should be max. returned.
    * @param sampleId
    * Optional. A string that gets returned as an association with the predicted image.
    * @return
    * An object of type Einstein_PredictionResult.
    */
    public Einstein_PredictionResult predictImageUrl(String modelId, String url, Integer numResults, String sampleId) {
        System.debug('Starting predict call with model ' + modelId + ' for url');
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, url, numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.URL);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/predict', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (!client.isError()) {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been predicted.');
            return predictions;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    * Fetches data about the API usage of the authenticated PredictionService.
    * @return
    * An array of all Einstein_ApiUsage elements.
    */
    public Einstein_ApiUsage[] getApiUsage() {
        System.debug('Starting getApiUsage call');
        Einstein_HttpClient client = new Einstein_HttpClient(this, API_USAGE);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while (isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getApiUsage has been executed.');
        if (!client.isError()) {
            Einstein_ApiUsage[] apiUsage = (Einstein_ApiUsage[])client.getParser().readValueAs(Einstein_ApiUsage[].class);
            System.debug('API usage has been fetched.');
            return apiUsage;
        }
        handleError(client.getStatusCode(), client.getResponseError());
        return null;
    }

    /**
    *
    * @return
    */
    public boolean isExecuting() {
        return isExecuting;
    }

    /**
    *
    * @param isExecuting
    */
    public void isExecuting(boolean isExecuting) {
        this.isExecuting = isExecuting;
    }

    /**
    *
    * @param message
    */
    private void handleError(Integer statusCode, String message) {
        httpStatusCode = statusCode;
        httpErrorMessage = message;
        System.debug(LoggingLevel.Error, 'Response finished with Error: ' + message + ' (status code: ' + statusCode + ')');
    }

    /**
    * Sets the Type of the Einstein_PredictionService
    * @param typeEnum
    * Value of type Einstein_PredictionService.Types
    */
    public void setType(Types typeEnum) {
        this.typeEnum = typeEnum;
        this.baseUrl = resolveBaseUrl();
        this.typeString = resolveType();
    }

    private String resolveType() {
        if (this.typeEnum == Einstein_PredictionService.Types.IMAGE) {
            return 'image';
        } else if (this.typeEnum == Einstein_PredictionService.Types.IMAGE_MULTI_LABEL) {
            return 'image-multi-label';
        } else if (this.typeEnum == Einstein_PredictionService.Types.IMAGE_DETECTION) {
            return 'image-detection';
        } else if (this.typeEnum == Einstein_PredictionService.Types.SENTIMENT) {
            return 'text-sentiment';
        } else if (this.typeEnum == Einstein_PredictionService.Types.INTENT) {
            return 'text-intent';
        }
        return '';
    }

    private String resolveBaseUrl() {
        if (this.typeEnum == Einstein_PredictionService.Types.IMAGE) {
            return BASE_URL + '/vision';
        } else if (this.typeEnum == Einstein_PredictionService.Types.IMAGE_MULTI_LABEL) {
            return BASE_URL + '/vision';
        } else if (this.typeEnum == Einstein_PredictionService.Types.IMAGE_DETECTION) {
            return BASE_URL + '/vision';
        } else if (this.typeEnum == Einstein_PredictionService.Types.SENTIMENT) {
            return BASE_URL + '/language';
        } else if (this.typeEnum == Einstein_PredictionService.Types.INTENT) {
            return BASE_URL + '/language';
        }
        return '';
    }

    private String resolveEinsteinDatasetType(Einstein_Dataset.Types typeEnum) {
        if (typeEnum == Einstein_Dataset.Types.ALL) {
            return '&type=all';
        } else if (typeEnum == Einstein_Dataset.Types.FEEDBACK) {
            return '&type=feedback';
        } else if (typeEnum == Einstein_Dataset.Types.UPLOAD) {
            return '&type=upload';
        }
        return '';
    }

    private String resolveEinsteinExampleType(Einstein_Example.Types typeEnum) {
        if (typeEnum == Einstein_Example.Types.ALL) {
            return '&type=all';
        } else if (typeEnum == Einstein_Example.Types.FEEDBACK) {
            return '&type=feedback';
        } else if (typeEnum == Einstein_Example.Types.UPLOAD) {
            return '&type=upload';
        }
        return '';
    }


    /**
    *
    * @return
    */
    public String getBearerToken() {
        return bearerToken;
    }

    public static String getAccessToken() {
        // Try to retrieve email setting
        Einstein_Settings__c settings = Einstein_Settings__c.getOrgDefaults();
        Einstein_JWT jwt = new Einstein_JWT('RS256');
        String accessToken = '';

        if (!Test.isRunningTest()) {

            if (settings.Einstein_EMail__c == null) {
                throw new Einstein_ConfigurationException('Missing Einstein email setting. Check your Custom Settings.');
            }

            if (settings.CertName__c == null) {
                ContentVersion base64Content;
                // Try to retrieve certificate
                try {
                    base64Content = [SELECT Title, VersionData FROM ContentVersion where Title='einstein_platform' AND IsLatest=true LIMIT 1];
                } catch (QueryException e) {
                    throw new Einstein_ConfigurationException('Could not retrieve the Einstein Platform certificate file: einstein_platform', e);
                }

                String keyContents = base64Content.VersionData.tostring();
                keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
                keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
                keyContents = keyContents.replace('\n', '');
                jwt.pkcs8 = keyContents;
            } else {
                jwt.cert = settings.CertName__c;
            }

            // Get a new token
            jwt.iss = 'developer.force.com';
            jwt.sub = settings.Einstein_EMail__c;
            jwt.aud = OAUTH2;
            jwt.exp = '3600';      
        
            accessToken = Einstein_JWTBearerFlow.getAccessToken(OAUTH2, jwt);
        }

        return accessToken;
    }

}
