public class Einstein_PlaygroundController {

    public static Einstein_PredictionService service = new Einstein_PredictionService(Einstein_PredictionService.Types.IMAGE);

    public static boolean checkEinsteinSetup() {
        return false;
    }

    private static void setType(String dataType) {
        if (dataType=='image') {
            service.setType(Einstein_PredictionService.Types.IMAGE);
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
        return datasetsReturn;
    }

    @AuraEnabled
    public static List<Einstein_Model> getModels(String dataType) {
        setType(dataType);
        Einstein_Dataset[] datasets = service.getDatasets();
        Einstein_Model[] modelsAll = new Einstein_Model[]{};
        for (Einstein_Dataset dataset : datasets) {
            Einstein_Model[] models = service.getModels(dataset.id);
            modelsAll.addAll(models);
        }
        return modelsAll;
    }

    @AuraEnabled
    public static String trainDataset(Decimal datasetId, String modelName, String dataType) {
        setType(dataType);
        Einstein_Model model = service.trainDataset(datasetId.longValue(), modelName, 0, 0, null);
        return model.modelId;
    }

    @AuraEnabled
    public static void deleteDataset(Long datasetId, String dataType) {
        setType(dataType);
        service.deleteDataset(datasetId);
    }

    @AuraEnabled
    public static Einstein_PredictionResult predictImageClassification(String modelId, String base64) {
        service.setType(Einstein_PredictionService.Types.IMAGE);
        Einstein_PredictionResult result = service.predictImageBase64(modelId, base64, 0, '');
        return result;
    }

    @AuraEnabled
    public static Einstein_PredictionResult predictIntent(String modelId, String phrase) {
        service.setType(Einstein_PredictionService.Types.INTENT);
        Einstein_PredictionResult result = service.predictIntent(modelId, phrase, 0, '');
        return result;
    }

    @AuraEnabled
    public static Einstein_PredictionResult predictSentiment(String modelId, String phrase) {
        service.setType(Einstein_PredictionService.Types.SENTIMENT);
        Einstein_PredictionResult result = service.predictSentiment(modelId, phrase, 0, '');
        return result;
    }

}