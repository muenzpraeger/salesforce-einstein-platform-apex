## Changelog

* Better support for displaying bounding boxes in object detection

* René updates
    - final UI fixes

* Shane updates
    - model metrics available as a separate component, nav'd to by clicking the metrics link
    - browser back button takes you back to playground
    - nested table for epoch label information, where available
    - color-coded confusion matrix cells
    - for image/multi-image clicking on a non-zero confusion matrix cell opens the list of examples for that cell
    - epochs display for multi-image are split across labels, with child rows for positive/negative for each label
    - additional info for object detection (precision, recall) logged to browser console where displaying on screen won't make sense.

* René updates
    - Got rid of modelmetrics and learning curve classes, replaced with String
    - Added alternative support for einstein cert as File to make transition easier

* Shane updates
    - move to certificate based authentication
    - label/model count in badges on playground
    - model stats (confusion, f1, etc)
    - usage/limits component/tab
    - dataset cards can grow vertically with label count
    - separate playground for multi-image detection
    - refactoring/consolidation of components
    - build language models from Salesforce data
    - example processBuilder implementation of language predictions + feedback (inactive, don't worry!)
    - predictions from image urls
    - intelligent, high-contrast color coding for object detection
    - scalable (responsive) object detection image display
    - metrics on models in a modal
    - failure messages for model training
    - model retrain of most recent model (keep same modelId)
    - friendly names (model names) for model selection dropdown

* 2.5.0
    - Bubbling up errors to Lighting components in the Playground Apex controller
    - Adjusting bounding box display for object detection
    - Fixed Null Pointer Exception when user opens tab without data
    - Addes .yaml configuration for deploy-to-sfdx button

* 2.4.5 - 11/25/17
    - Cleaned up permissions in Admin profile
    - Fixed display of setup page

* 2.4.0 - 11/16/17
    - Added example [Process Builder](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/blob/master/force-app/main/default/classes/PB_Einstein_Image_Classification.cls) implementation for image classification
    - Increased HTTP timeout to 30 seconds
    - Raised image upload limit to 5MB

* 2.3.0 - 10/16/17
    - Adding Einstein Image Detection (beta)
    - Minor UI changes

* 2.2.0 - 09/13/17
    - Added setup UI/information to playground - [Link](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/issues/14)
    - Restrict file size upload for image classification - [Link](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/issues/17)
    - Run image prediction after image has been selected - [Link](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/issues/13)
    - UI refinements - [Link](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/issues/15) [Link](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/issues/18)

* 2.1.0 - 09/08/17
    - Added support for Salesforce orgs with namespace - [Link](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/issues/6)
    - Updated UI example with NEW PLAYGROUND - [Link](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/issues/9)
    - Moved training parameters from String to Apex Object - [Link](https://github.com/muenzpraeger/salesforce-einstein-platform-apex/issues/5)

* 2.0.0 - 08/22/17
    - Initial version