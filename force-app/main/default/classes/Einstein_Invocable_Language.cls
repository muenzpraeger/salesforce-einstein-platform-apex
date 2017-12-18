public with sharing class Einstein_Invocable_Language {

	@InvocableMethod(label='Have Einstein analyze text')
	public static void AnalyzeLanguage(list<LanguageRequest> LRs) {

		//don't allow this run in future, batch, or queueable
		if (system.isFuture() || system.isBatch() || system.isQueueable()){
			return;
		}

		list<string> singleBatch = new list<string>();
		list<list<string>> Batches = new list<list<string>>();

		Integer Batchsize = Limits.GetLimitCallouts()-1; //because we'll use a call to get a token for each batch

		//get the actual text
		list<LanguageRequest> deduped = dedupeLRs(LRs);
		list<ID> lrIDs = new list<ID>();
		list<string> fields = new list<string>();

		for (LanguageRequest LR:deduped){
			lrIDs.add(LR.recordId);
			fields.add(LR.FieldToAnalyze);
		}

		string objType = id.valueOf(deduped[0].recordId).getSObjectType().getDescribe().getName();
		string soql = 'select id, ' + string.join(fields, ', ') + ' from ' + objType +' where id in: lrIDs';
		system.debug(soql);

		list<sobject> records = database.query(soql);
		system.debug(records);

		map<id, sobject> recordMap = new map<id, sobject>();
		for (sobject so:records){
			recordMap.put((id)so.get('Id'), so);
		}

		system.debug(recordMap);

		for (LanguageRequest LR:deduped){
			LR.objectType = objType;
			LR.actualText = string.valueOf(recordMap.get(LR.recordId).get(LR.FieldToAnalyze));
			//batch is full, put it in the batch list, blank it for new adds
			if (singleBatch.size()==Batchsize){
				Batches.add(singleBatch);
				singleBatch = new list<string>();
			}
			singleBatch.add(JSON.serialize(LR));
		}

		Batches.add(singleBatch);
		for (list<string> batch:batches){
			getAnalysis(batch);
		}
	}

	@future(callout=true)
	public static void getAnalysis(list<string> input){

		list<ID> lrIDs = new list<ID>();
		set<string> fields = new set<string>();

		list<LanguageRequest> LRs = new list<LanguageRequest>();

		for (string s:input){
			LRs.add((LanguageRequest)JSON.deserialize(s, LanguageRequest.class));
		}

		for (LanguageRequest LR:LRs){
			lrIDs.add(LR.recordId);

			fields.add(LR.LabelStoreField);
			if (LR.ProbabilityStoreField != null){
				fields.add(LR.ProbabilityStoreField);
			}
			if (LR.RawStoreField != null){
				fields.add(LR.RawStoreField);
			}
            if (LR.ModelType=='Sentiment'){
                Einstein_PredictionService service = new Einstein_PredictionService(Einstein_PredictionService.Types.SENTIMENT);
                LR.prediction = service.predictSentiment(LR.ModelId, LR.actualText, 0, '');
            } else if (LR.ModelType=='Intent'){
                Einstein_PredictionService service = new Einstein_PredictionService(Einstein_PredictionService.Types.INTENT);
                LR.prediction = service.predictIntent(LR.ModelId, LR.actualText, 0, '');
            } else if (LR.ModelId == null && (LR.ModelType=='Sentiment' || LR.ModelType==null)){
                //default this
                Einstein_PredictionService service = new Einstein_PredictionService(Einstein_PredictionService.Types.SENTIMENT);
                LR.prediction = service.predictSentiment('CommunitySentiment', LR.actualText, 0, '');
            }
			//LR.predictions = EinsteinLanguage.Predict(LR.actualText, LR.modelType, LR.modelId, token);
			system.debug(LR);
		}

		list<string> fieldNames = new list<string>(fields);

		string soql = 'select id, ' + string.join(fieldNames, ', ') + ' from ' + LRs[0].objectType +' where id in: lrIDs';
		system.debug(soql);

		list<sobject> records = database.query(soql);
		system.debug(records);

		map<id, sobject> recordMap = new map<id, sobject>();
		for (sobject so:records){
			recordMap.put((id)so.get('Id'), so);
		}

		system.debug(recordMap);
		//handle the predictions and update that record
		for (LanguageRequest LR:LRs){
			recordMap.get((id)LR.recordId).put(LR.LabelStoreField, LR.prediction.probabilities[0].label);
			//TODO: probability, raw, chatter
			if (LR.ProbabilityStoreField != null){
				try{
					recordMap.get((id)LR.recordId).put(LR.ProbabilityStoreField, LR.prediction.probabilities[0].probability);
				} catch (SObjectException e){
					//might be a text field instead of decimal?
						recordMap.get((id)LR.recordId).put(LR.ProbabilityStoreField, string.valueOf(LR.prediction.probabilities[0].probability));
				}
			}
			if (LR.RawStoreField != null){
                // we don't need the coordinates property for anything besides object detection!
				recordMap.get((id)LR.recordId).put(LR.RawStoreField, JSON.serialize(LR.prediction).remove(',"boundingBox":null'));
			}
		}

		list<sobject> output = recordMap.values();
		update output;

	}

	public class LanguageRequest {
		@InvocableVariable (required=true label='RecordId of record to Analyze')
		public string RecordId;

		@InvocableVariable (required=true label='Field to Analyze')
		public string FieldToAnalyze;

		@InvocableVariable (required=true label='Field to Store Answer' description='The top label will be stored in this text field')
		public string LabelStoreField;

		@InvocableVariable (label='Field to Store Probability' description='The probability on the top label will be stored in this number/percentage field')
		public string ProbabilityStoreField;

		@InvocableVariable (label='Field to Store Raw Results' description='This text field will get all predictions (label/probability pairs) stored as JSON')
		public string RawStoreField;

		//@InvocableVariable (label='Reply in Chatter')
		//public boolean replyInChatter;

		@InvocableVariable (label='Model Id' description='Model Id from Einstein (not the Salesforce ID)')
		public string ModelId;

		@InvocableVariable (label='Model Type' description='Allowed values are Sentiment and Intent')
		public string ModelType;

		public string actualText;
		public string objectType;

		public Einstein_PredictionResult prediction;
	}

	public static list<LanguageRequest> dedupeLRs(list<LanguageRequest> input){
		set<LanguageRequest> temp = new set<LanguageRequest>(input);
		return new list<LanguageRequest>(temp);
	}

}