public class Einstein_PlaygroundController {

    public static Einstein_PredictionService service;

    private static void setType(String dataType) {
        if (service==null) {
            service = new Einstein_PredictionService(Einstein_PredictionService.Types.IMAGE);
        }
        if (dataType=='image') {
            service.setType(Einstein_PredictionService.Types.IMAGE);
        } else if (dataType=='image-detection') {
            service.setType(Einstein_PredictionService.Types.IMAGE_DETECTION);
        } else if (dataType=='text-intent') {
            service.setType(Einstein_PredictionService.Types.INTENT);
        } else if (dataType=='text-sentiment') {
            service.setType(Einstein_PredictionService.Types.SENTIMENT);
        }
    }

    @AuraEnabled
    public static void createDatasetFromUrl(String url, String dataType) {
        setType(dataType);
        service.createDatasetFromUrlAsync(url);
        if (service.httpStatusCode>200) {
            throw new AuraHandledException(service.httpErrorMessage);
        }
    }

    @AuraEnabled
    public static List<Einstein_Dataset> getDatasets(String dataType) {
        setType(dataType);
        List<Einstein_Dataset> datasets = service.getDatasets();
        List<Einstein_Dataset> datasetsReturn = new List<Einstein_Dataset>();
        for (Einstein_Dataset dataset : datasets) {
            if (dataset.type==dataType) {
                datasetsReturn.add(dataset);
            }
        }
        if (service.httpStatusCode>200) {
            throw new AuraHandledException(service.httpErrorMessage);
        }
        return datasetsReturn;
    }

    @AuraEnabled
    public static List<Einstein_Model> getModels(Long datasetId, String dataType) {
        setType(dataType);
        Einstein_Model[] models = service.getModels(datasetId);
        if (service.httpStatusCode>200) {
            throw new AuraHandledException(service.httpErrorMessage);
        }
        return models;
    }

    @AuraEnabled
    public static String trainDataset(Decimal datasetId, String modelName, String dataType) {
        setType(dataType);
        Einstein_Model model = service.trainDataset(datasetId.longValue(), modelName, 0, 0, null);
        if (service.httpStatusCode>200) {
            throw new AuraHandledException(service.httpErrorMessage);
        }
        return model.modelId;
    }

    @AuraEnabled
    public static void deleteDataset(Long datasetId, String dataType) {
        setType(dataType);
        service.deleteDataset(datasetId);
        if (service.httpStatusCode>200) {
            throw new AuraHandledException(service.httpErrorMessage);
        }
    }

    @AuraEnabled
    public static Einstein_PredictionResult predictImageClassification(String modelId, String base64) {
        setType('');
        service.setType(Einstein_PredictionService.Types.IMAGE);
        Einstein_PredictionResult result = service.predictImageBase64(modelId, base64, 0, '');
        if (service.httpStatusCode>200) {
            throw new AuraHandledException(service.httpErrorMessage);
        }
        return result;
    }

    @AuraEnabled
    public static Einstein_PredictionResult predictImageDetection(String modelId, String base64) {
        setType('');
        service.setType(Einstein_PredictionService.Types.IMAGE_DETECTION);
        Einstein_PredictionResult result = service.detectImageBase64(modelId, base64, 0, '');
        if (service.httpStatusCode>200) {
            throw new AuraHandledException(service.httpErrorMessage);
        }
        return result;
    }

    @AuraEnabled
    public static Einstein_PredictionResult predictIntent(String modelId, String phrase) {
        setType('');
        service.setType(Einstein_PredictionService.Types.INTENT);
        Einstein_PredictionResult result = service.predictIntent(modelId, phrase, 0, '');
        if (service.httpStatusCode>200) {
            throw new AuraHandledException(service.httpErrorMessage);
        }
        return result;
    }

    @AuraEnabled
    public static Einstein_PredictionResult predictSentiment(String modelId, String phrase) {
        setType('');
        service.setType(Einstein_PredictionService.Types.SENTIMENT);
        Einstein_PredictionResult result = service.predictSentiment(modelId, phrase, 0, '');
        if (service.httpStatusCode>200) {
            throw new AuraHandledException(service.httpErrorMessage);
        }
        return result;
    }

    @AuraEnabled
    public static Map<String, Boolean> validateEinsteinPlatformSetup() {
        Map<String, Boolean> mapSettings = new Map<String, Boolean>();
        Einstein_Settings__c settings = Einstein_Settings__c.getOrgDefaults();
        if (settings.Einstein_EMail__c == null) {
            mapSettings.put('einsteinEmail', false);
        } else {
            mapSettings.put('einsteinEmail', true);
        }
        ContentVersion base64Content;
        try {
            base64Content = [SELECT Title, VersionData FROM ContentVersion where Title='einstein_platform' LIMIT 1];
            mapSettings.put('einsteinFile', true);
        }
        catch (QueryException e) {
            mapSettings.put('einsteinFile', false);
        }
        return mapSettings;
    }

}