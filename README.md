# salesforce-einstein-platform-apex

[![Deploy](https://deploy-to-sfdx.com/dist/assets/images/DeployToSFDX.svg)](https://deploy-to-sfdx.com/deploy?template=https://github.com/muenzpraeger/salesforce-einstein-platform-apex)

This repository showcases how to use the [Salesforce Einstein Platform API](https://metamind.readme.io/) using an Apex based wrapper.

Please check the [product documentation](https://metamind.readme.io/) for general information about what the Salesforce Einstein Platform API is, how to use it and when it'll be available for you.

The wrapper supersedes the old wrapper for the [Salesforce Einstein Vision API](https://github.com/muenzpraeger/salesforce-einstein-vision-apex). Besided breaking changes compared to the old wrapper this repo contains the v2 of the API (including image-multi-label, language intent and language sentiment).


## Prerequisites

For using the wrapper you'll need to fulfill the following requirements:
* Access to a Salesforce org, i. e. a Developer Edition or a scratch org (you can [signup here for free](https://developer.salesforce.com/signup) if you don't have one).
* An API account for Salesforce Einstein Platform.

Please find the detailed instructions for how to setup access to the [Einstein Platform API here](https://metamind.readme.io/docs/what-you-need-to-call-api).

## Installation

### Salesforce DX - new scratch org

Clone the repo to your local file system.

```
git clone https://github.com/muenzpraeger/salesforce-einstein-platform-apex
```

Change into the git repo directory and create a new scratch org

```
sfdx force:org:create -s -f config/project-scratch-def.json
```

Push the source to the newly created org.
```
sfdx force:source:push
```

### Salesforce DX - existing scratch org

If you want to add the wrapper to an existing org you can either copy the contents manually from this repo.

Alternatively you can use [Wade's OSS plugin for Salesforce DX](https://github.com/wadewegner/sfdx-oss-plugin).


## Configuration

After you've added the wrapper files two steps are required:

* Set the value for _Einstein EMail_ in Custom Settings => Einstein Settings for that org to the email address that you've used to sign up for Einstein Platform.
* Store the Einstein Platform file as file in the org. The name must be _einstein_platform.pem_.

If you went through [my Trailhead project](https://trailhead.salesforce.com/projects/build-a-cat-rescue-app-that-recognizes-cat-breeds) you likely went through that excercise already.

## Usage examples
### Creating a PredictionService

The foundation for everything is the `PredictionService`. As the communication with the API is based on a valid OAuth2 token (see MetaMind documentation) you can initiate a new PredictionService in the following way.

```
Einstein_PredictionService predictionService = new Einstein_PredictionService(Einstein_PredictionService.Types.IMAGE);
```

This creates a new prediction service for working with images. You can switch the type so that you can reuse it for other predictions.

```
service.setType(Einstein_PredictionService.Types.SENTIMENT);
```

### Fetch all trained image datasets

```
Einstein_PredictionService service = new Einstein_PredictionService(Einstein_PredictionService.Types.IMAGE);
List<Einstein_Dataset> datasets = service.getDatasets();
```

### Train an intent dataset

```
Einstein_PredictionService service = new Einstein_PredictionService(Einstein_PredictionService.Types.INTENT);
Einstein_Model model = service.trainDataset(datasetId, 'the dataset name', 0, 0, '';
```

### Prediction

You can predict images either by sending Base64, uploading a Blob or a remote (publicly available!) URL. See this example how to validate a remote URL.

```
Einstein_PredictionResult result = service.predictImageUrl('GeneralImageClassifier', 'yourUrl', 5, '');
```

The prediction for intent or sentiment is similar. Like this example for intent.

```
Einstein_PredictionResult result = service.predictIntent('yourModelId', 'theText', 0, '');
```


## Contribution

Feel free to contribute to this project via pull requests.

## License

For licensing see the included [license file](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/blob/master/LICENSE.md).
