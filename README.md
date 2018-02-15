[![Build Status](https://travis-ci.org/muenzpraeger/salesforce-einstein-platform-apex.svg?branch=master)](https://travis-ci.org/muenzpraeger/salesforce-einstein-platform-apex)

# salesforce-einstein-platform-apex

This repository showcases how to use the [Salesforce Einstein Platform API](https://metamind.readme.io/) using an Apex based wrapper.

Please check the [product documentation](https://metamind.readme.io/) for general information about what the Salesforce Einstein Platform API is, how to use it and when it'll be available for you.

The wrapper supersedes the old wrapper for the [Salesforce Einstein Vision API](https://github.com/muenzpraeger/salesforce-einstein-vision-apex). Besided breaking changes compared to the old wrapper this repo contains the v2 of the API (including image-multi-label, language intent and language sentiment).

See the included Playground in action.

[![Playground](https://img.youtube.com/vi/poY8wR0pVks/0.jpg)](https://www.youtube.com/watch?v=poY8wR0pVks)

## Version history

Check out the full [changelog](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/blob/master/CHANGELOG.md).

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

run the orgInit.sh script
```
./orgInit
```

### Salesforce DX - deploy to an org from your hub

Again thanks to Wade for creating this neat feature.

[![Deploy](https://deploy-to-sfdx.com/dist/assets/images/DeployToSFDX.svg)](https://deploy-to-sfdx.com/)


### Salesforce DX - deploy into developer edition or production org

You can use the Salesforce CLI to deploy the source into a regular Salesforce org using the Metatdata API.

Authenticate against the deployment org
```
sfdx force:auth:web:login -a yourOrgAlias
```

Create an output directory for the to be converted source
```
mkdir mdapi
```

Convert the source from Salesforce DX format to Metatdata API format
```
sfdx force:source:convert -r force-app -d mdapi
```

Deploy the source
```
sfdx force:mdapi:deploy -d mdapi -u yourOrgAlias
```


## Configuration

After you've added the wrapper files two steps are required:

* Set the value for _Einstein EMail_ in Custom Settings => Einstein Settings (via the _Manage_ button) for that org to the email address that you've used to sign up for Einstein Platform.
* Store the Einstein Platform file as File in the org. The name must be _einstein_platform_.

If you went through [my Trailhead project](https://trailhead.salesforce.com/projects/build-a-cat-rescue-app-that-recognizes-cat-breeds) you likely went through that excercise already.

The installation adds a new Lightning App to your Salesforce org for the included Playground.
![playground](resources/einstein_platform.png)

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

Feel free to contribute to this project via pull requests. Please read the [contribution](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/blob/master/CONTRIBUTION.md) before you start working on something.

## License

For licensing see the included [license file](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/blob/master/LICENSE.md).
