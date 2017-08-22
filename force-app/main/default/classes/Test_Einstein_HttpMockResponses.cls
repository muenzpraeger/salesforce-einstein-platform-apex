@isTest
public with sharing class Test_Einstein_HttpMockResponses implements HttpCalloutMock {
    
    public HTTPResponse respond(HTTPRequest req) {

        String apiEndpoint = 'https://api.einstein.ai/';
        
        String httpEndpoint = req.getEndpoint();
        String httpMethod = req.getMethod();

        if (httpMethod.equals('GET')) {
            if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/57/models')) {
                return mockGetModels(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/57/examples/43887')) {
                return mockGetExample(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/57/examples')) {
                return mockGetExamples(req);
            } else if(httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/57')) {
                return mockGetDataset(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets')) {
                if (httpEndpoint.endsWith('global=true')) {
                    return mockGetGlobalDatasets(req);
                } else {
                    return mockGetDatasets(req);                    
                }
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/57/labels/614')) {
                return mockGetLabel(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/train/7JXCXTRXTMNLJCEF2DR5CJ46QU')) {
                return mockGetModel(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/models/7JXCXTRXTMNLJCEF2DR5CJ46QU/lc')) {
                return mockGetModelLearningCurve(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/models/7JXCXTRXTMNLJCEF2DR5CJ46QU')) {
                return mockGetModelMetrics(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/apiusage')) {
                return mockGetApiUsage(req);
            }
        } else if (httpMethod.equals('POST')) {
            if (httpEndpoint.endsWith('retrain')) {
                return mockRetrainDataset(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/57/labels')) {
                return mockCreateLabel(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/57/examples')) {
                return mockCreateExample(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/train')) {   
                return mockTrainDataset(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/upload/sync')) {
                return mockCreateDatasetSync(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/upload')) {
                return mockCreateDatasetAsync(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/predict')) {
                return mockPredictBase64(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/language/intent')) {
                return mockPredictIntent(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/language/sentiment')) {
                return mockPredictSentiment(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/feedback')) {
                return mockPredictFeedbackImage(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/language/feedback')) {
                return mockPredictFeedbackLanguage(req);
            }
        } else if (httpMethod.equals('DELETE')) {
            if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/108')) {
                return mockDeleteDataset(req);
            } else if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/108/examples/43555')) {
                return mockDeleteExample(req);
            }
        } else if (httpMethod.equals('PUT')) {
            if (httpEndpoint.startsWith('https://api.einstein.ai/v2/vision/datasets/1000022/upload')) {
                return mockCreateExamplesFromUrl(req);
            }
        }
        
        return null;
    }

    private static HTTPResponse mockCreateDatasetSync(HTTPRequest req) {
        
        String jsonResponse = '{"id":57,"name":"Beach and Mountain","createdAt":"2016-09-15T16:51:41.000+0000","updatedAt":"2016-09-15T16:51:41.000+0000","labelSummary":{"labels":[{"id":611,"datasetId":57,"name":"beach","numExamples":0},{"id":612,"datasetId":57,"name":"mountain","numExamples":0}]},"totalExamples":0,"totalLabels":2,"available":true,"statusMsg":"SUCCEEDED","object":"dataset"}';
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }

    private static HTTPResponse mockCreateDatasetAsync(HTTPRequest req) {
        
        String jsonResponse = '{"id":57,"name":"Beach and Mountain","createdAt":"2016-09-15T16:51:41.000+0000","updatedAt":"2016-09-15T16:51:41.000+0000","labelSummary":{"labels":[{"id":611,"datasetId":57,"name":"beach","numExamples":0},{"id":612,"datasetId":57,"name":"mountain","numExamples":0}]},"totalExamples":0,"totalLabels":2,"available":true,"statusMsg":"SUCCEEDED","object":"dataset"}';
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockGetDataset(HTTPRequest req) {
        
        String jsonResponse = '{"id":57,"name":"Beach and Mountain","createdAt":"2016-09-15T16:51:41.000+0000","updatedAt":"2016-09-15T16:51:41.000+0000","labelSummary":{"labels":[{"id":612,"datasetId":57,"name":"beach","numExamples":49},{"id":611,"datasetId":57,"name":"mountain","numExamples":50}]},"totalExamples":99,"totalLabels":2,"available":true,"statusMsg":"SUCCEEDED","object":"dataset"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockGetDatasets(HTTPRequest req) {
        
        String jsonResponse = '{"object":"list","data":[{"id":57,"name":"Beach and Mountain","updatedAt":"2016-09-09T22:39:22.000+0000","createdAt":"2016-09-09T22:39:22.000+0000","labelSummary":{"labels":[{"id":36,"datasetId":57,"name":"beach","numExamples":49},{"id":37,"datasetId":57,"name":"mountain","numExamples":50}]},"totalExamples":99,"totalLabels":2,"available":true,"statusMsg":"SUCCEEDED","object":"dataset"},{"id":58,"name":"Brain Scans","updatedAt":"2016-09-24T21:35:27.000+0000","createdAt":"2016-09-24T21:35:27.000+0000","labelSummary":{"labels":[{"id":122,"datasetId":58,"name":"healthy","numExamples":5064},{"id":123,"datasetId":58,"name":"unhealthy","numExamples":5080}]},"totalExamples":10144,"totalLabels":2,"available":true,"statusMsg":"SUCCEEDED","object":"dataset"}]}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }

    private static HTTPResponse mockGetGlobalDatasets(HTTPRequest req) {
        
        String jsonResponse = '{"object":"list","data":[{"id":1005161,"name":"other","createdAt":"2017-06-27T23:21:16.000+0000","updatedAt":"2017-06-27T23:21:19.000+0000","labelSummary":{"labels":[{"id":24197,"datasetId":1005161,"name":"other","numExamples":455}]},"totalExamples":455,"totalLabels":1,"available":true,"statusMsg":"SUCCEEDED","type":"image","object":"dataset"}]}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockDeleteDataset(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(204);
        return res;
        
    }
    
    private static HTTPResponse mockCreateLabel(HTTPRequest req) {
        
        String jsonResponse = '{"id":614,"datasetId":57,"name":"beach","object":"label"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockGetLabel(HTTPRequest req) {
        
        String jsonResponse = '{"id":614,"datasetId":57,"name":"beach","object":"label"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockCreateExample(HTTPRequest req) {
        
        String jsonResponse = '{"id":43887,"name":"77880132.jpg","location":"https://jBke4mtMuOjrCK3A04Q79O5TBySI2BC3zqi7...","createdAt":"2016-09-15T23:18:13.000+0000","label":{"id":614,"datasetId":57,"name":"beach","numExamples":50},"object":"example"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockCreateExamplesFromUrl(HTTPRequest req) {
        
        String jsonResponse = '{"id":1000022,"name":"mountainvsbeach","createdAt":"2017-02-17T00:22:10.000+0000","updatedAt":"2017-02-17T00:22:12.000+0000","labelSummary":{"labels":[{"id":1819,"datasetId":1000022,"name":"Mountains","numExamples":50},{"id":1820,"datasetId":1000022,"name":"Beaches","numExamples":49}]},"totalExamples":99,"totalLabels":2,"available":false,"object":"dataset"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockGetExample(HTTPRequest req) {
        
        System.debug('in mockGetExample');
        
        String jsonResponse = '{"id":43887,"name":"77880132.jpg","location":"https://jBke4mtMuOjrCK3A04Q79O5TBySI2BC3zqi7...","createdAt":"2016-09-15T23:18:13.000+0000","label":{"id":614,"datasetId":57,"name":"beach","numExamples":50},"object":"example"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockGetExamples(HTTPRequest req) {
        
        String jsonResponse = '{"object":"list","data":[{"id":43888,"name":"659803277.jpg","location":"https://K3A04Q79O5TBySIZSeMIj%2BC3zqi7rOmeK...","createdAt":"2016-09-16T17:14:38.000+0000","label":{"id":618,"datasetId":57,"name":"beach","numExamples":50},"object":"example"},{"id":43889,"name":"661860605.jpg","location":"https://jBke4mtMuOjrCK3A04Q79O5TBySI2BC3zqi7...","createdAt":"2016-09-16T17:14:42.000+0000","label":{"id":618,"datasetId":57,"name":"beach","numExamples":50},"object":"example"},{"id":43890,"name":"660548647.jpg","location":"https://HKzY79n47nd%2F0%2FCem6PJBkUoyxMWVssCX...","createdAt":"2016-09-16T17:15:25.000+0000","label":{"id":619,"datasetId":57,"name":"mountain","numExamples":49},"object":"example"},{"id":43891,"name":"578339672.jpg","location":"https://LRlXQeRyTVDiujSzHTabcJ2FGGnuGhAvedvu0D...","createdAt":"2016-09-16T17:15:29.000+0000","label":{"id":619,"datasetId":57,"name":"mountain","numExamples":49},"object":"example"}]}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockDeleteExample(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(204);
        return res;
        
    }
    
    private static HTTPResponse mockTrainDataset(HTTPRequest req) {
        
        String jsonResponse = '{"datasetId":57,"datasetVersionId":0,"name":"Beach and Mountain Model","status":"QUEUED","progress":0,"createdAt":"2016-09-16T18:03:21.000+0000","updatedAt":"2016-09-16T18:03:21.000+0000","learningRate":0.001,"epochs":3,"queuePosition":1,"object":"training","modelId":"7JXCXTRXTMNLJCEF2DR5CJ46QU","trainParams":null,"trainStats":null,"modelType":"image"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }

    private static HTTPResponse mockRetrainDataset(HTTPRequest req) {
        
        String jsonResponse = '{"datasetId":57,"datasetVersionId":0,"name":"Beach and Mountain Model","status":"QUEUED","progress":0,"createdAt":"2016-09-16T18:03:21.000+0000","updatedAt":"2016-09-16T18:03:21.000+0000","learningRate":0.001,"epochs":3,"queuePosition":1,"object":"training","modelId":"7JXCXTRXTMNLJCEF2DR5CJ46QU","trainParams":null,"trainStats":null,"modelType":"image"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockGetModel(HTTPRequest req) {
        
        String jsonResponse = '{"datasetId":57,"datasetVersionId":0,"name":"Beach and Mountain Model","status":"SUCCEEDED","progress":1,"createdAt":"2016-09-16T18:03:21.000+0000","updatedAt":"2016-09-16T18:03:21.000+0000","learningRate":0.001,"epochs":3,"object":"training","modelId":"7JXCXTRXTMNLJCEF2DR5CJ46QU","trainParams":null,"trainStats":null,"modelType":"image"}';
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockGetModelLearningCurve(HTTPRequest req) {
        
        String jsonResponse = '{"object":"list","data":[{"epoch":1,"metricsData":{"f1":[0.75,0.8333333],"labels":["Mountains","Beaches"],"testAccuracy":0.8,"trainingLoss":0.2573,"confusionMatrix":[[3,2],[0,5]],"trainingAccuracy":0.8809},"epochResults":[{"exampleName":"601053842.jpg-Mountains","expectedLabel":"Mountains","predictedLabel":"Mountains"},{"exampleName":"578339672.jpg-Mountains","expectedLabel":"Mountains","predictedLabel":"Mountains"},{"exampleName":"549525751.jpg-Mountains","expectedLabel":"Mountains","predictedLabel":"Beaches"},{"exampleName":"521811667.jpg-Mountains","expectedLabel":"Mountains","predictedLabel":"Beaches"},{"exampleName":"479111308.jpg-Mountains","expectedLabel":"Mountains","predictedLabel":"Mountains"},{"exampleName":"155304150.jpg-Beaches","expectedLabel":"Beaches","predictedLabel":"Beaches"},{"exampleName":"566675649.jpg-Beaches","expectedLabel":"Beaches","predictedLabel":"Beaches"},{"exampleName":"175551857.jpg-Beaches","expectedLabel":"Beaches","predictedLabel":"Beaches"},{"exampleName":"459120189.jpg-Beaches","expectedLabel":"Beaches","predictedLabel":"Beaches"},{"exampleName":"109558771.jpg-Beaches","expectedLabel":"Beaches","predictedLabel":"Beaches"}],"object":"learningcurve"},{"epoch":2,"metricsData":{"f1":[0.75,0.8333333],"labels":["Mountains","Beaches"],"testAccuracy":0.8,"trainingLoss":0.0531,"confusionMatrix":[[3,2],[0,5]],"trainingAccuracy":0.9824},"epochResults":[],"object":"learningcurve"},{"epoch":3,"metricsData":{"f1":[0.8,0.8],"labels":["Mountains","Beaches"],"testAccuracy":0.8,"trainingLoss":0.0278,"confusionMatrix":[[4,1],[1,4]],"trainingAccuracy":0.9893},"epochResults":[{"exampleName":"601053842.jpg-Mountains","expectedLabel":"Mountains","predictedLabel":"Mountains"},{"exampleName":"578339672.jpg-Mountains","expectedLabel":"Mountains","predictedLabel":"Mountains"},{"exampleName":"549525751.jpg-Mountains","expectedLabel":"Mountains","predictedLabel":"Mountains"},{"exampleName":"521811667.jpg-Mountains","expectedLabel":"Mountains","predictedLabel":"Beaches"},{"exampleName":"479111308.jpg-Mountains","expectedLabel":"Mountains","predictedLabel":"Mountains"},{"exampleName":"155304150.jpg-Beaches","expectedLabel":"Beaches","predictedLabel":"Beaches"},{"exampleName":"566675649.jpg-Beaches","expectedLabel":"Beaches","predictedLabel":"Beaches"},{"exampleName":"175551857.jpg-Beaches","expectedLabel":"Beaches","predictedLabel":"Beaches"},{"exampleName":"459120189.jpg-Beaches","expectedLabel":"Beaches","predictedLabel":"Beaches"},{"exampleName":"109558771.jpg-Beaches","expectedLabel":"Beaches","predictedLabel":"Mountains"}],"object":"learningcurve"}]}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockGetModelMetrics(HTTPRequest req) {
        
        String jsonResponse = '{"metricsData":{"f1":[0.9090909090909092,0.9411764705882352],"labels":["beach","mountain"],"testAccuracy":0.9286,"trainingLoss":0.021,"confusionMatrix":[[5,0],[1,8]],"trainingAccuracy":0.9941},"createdAt":"2016-09-16T18:04:59.000+0000","id":"7JXCXTRXTMNLJCEF2DR5CJ46QU","object":"metrics"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockGetModels(HTTPRequest req) {
        
        String jsonResponse = '{"object":"list","data":[{"datasetId":57,"datasetVersionId":0,"name":"Beach Mountain Model - Test1","status":"FAILED","progress":0,"createdAt":"2016-09-15T15:31:23.000+0000","updatedAt":"2016-09-15T15:32:53.000+0000","failureMsg":"To train a dataset and create a model, the dataset must contain at least 100 examples per label for test set","object":"model","modelId":"2KXJEOM3N562JBT4P7OX7VID2Q","modelType":"image"},{"datasetId":57,"datasetVersionId":0,"name":"Beach Mountain Model - Test2","status":"SUCCEEDED","progress":1,"createdAt":"2016-09-15T16:15:46.000+0000","updatedAt":"2016-09-15T16:17:19.000+0000","object":"model","modelId":"YCQ4ZACEPJFGXZNRA6ERF3GL5E","modelType":"image"}]}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockPredictFeedbackImage(HTTPRequest req) {
        
        String jsonResponse = '{"id":618168,"name":"alps.jpg","location":"https://HnpTxmdFb6%2BY1jwAqBtjkUMUj6qKQD0CTjsJ...","createdAt":"2017-05-04T20:52:02.000+0000","label":{"id":3235,"datasetId":1000475,"name":"Mountains","numExamples":104},"object":"example"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }

    private static HTTPResponse mockPredictFeedbackLanguage(HTTPRequest req) {
        
        String jsonResponse = '{"id":1048038,"name":"text-intent","location":"is it snowing in Denver","createdAt":"2017-06-09T21:23:11.000+0000","label":{"id":16611,"datasetId":1001511,"name":"current-weather","numExamples":32},"object":"example"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }

    private static HTTPResponse mockPredictBase64(HTTPRequest req) {
        
        String jsonResponse = '{"probabilities":[{"label":"beach","probability":0.96021104},{"label":"mountain","probability":0.039788953959941864}],"object":"predictresponse"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }

    private static HTTPResponse mockPredictIntent(HTTPRequest req) {
        
        String jsonResponse = '{"probabilities":[{"label":"current-weather","probability":0.9904295},{"label":"five-day-forecast","probability":0.009345241},{"label":"hourly-forecast","probability":2.2528473E-4}]}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }

    private static HTTPResponse mockPredictSentiment(HTTPRequest req) {
        
        String jsonResponse = '{"probabilities":[{"label":"positive","probability":0.77945083},{"label":"negative","probability":0.18806243},{"label":"neutral","probability":0.032486767}]}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockPredictBlob(HTTPRequest req) {
        
        String jsonResponse = '{"probabilities":[{"label":"beach","probability":0.98093873},{"label":"mountain","probability":0.019061258}],"object":"predictresponse"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockPredictUrl(HTTPRequest req) {
        
        String jsonResponse = '{"probabilities":[{"label":"beach","probability":0.9997346},{"label":"mountain","probability":2.6542565E-4}],"object":"predictresponse"}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
    private static HTTPResponse mockGetApiUsage(HTTPRequest req) {
        
        String jsonResponse = '{"object":"list","data":[{"id":"489","organizationId":"108","startsAt":"2017-03-01T00:00:00.000Z","endsAt":"2017-04-01T00:00:00.000Z","planData":[{"plan":"FREE","amount":1,"source":"HEROKU"}],"licenseId":"kJCHtYDCSf","object":"apiusage","predictionsRemaining":997,"predictionsUsed":3,"predictionsMax":1000}]}'; 
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonResponse);
        res.setStatusCode(200);
        return res;
        
    }
    
}