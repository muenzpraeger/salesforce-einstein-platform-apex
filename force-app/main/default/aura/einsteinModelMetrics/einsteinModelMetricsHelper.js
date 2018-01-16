({
    formatConfusion : function(label, confusionRaw, allLabels, results) {
        let output = [];

        confusionRaw.forEach(function (value, key){
            let outputMember = {
                key:key,
                value: value,
                isPrime: false,
                expected: label,
                predicted: allLabels[key],
                examples: []
            }

            if (outputMember.expected === outputMember.predicted){
                outputMember.isPrime = true;
                outputMember.class = 'prime';
            } else {
                if (value > 0){
                    outputMember.class = 'bad';
                } else {
                    outputMember.class = 'good';
                }
            }

            //language models don't haave a results object?
            if (results.length>0){
                results.forEach( (example) => {
                    if (example.expectedLabel === outputMember.expected && example.predictedLabel === outputMember.predicted){
                        outputMember.examples.push(example.exampleName);
                    }
                });
                outputMember.examplesString = outputMember.examples.join();
            }
            output.push(outputMember);
        });

        return output;
    },

    expandMultiImageLC: function(LCdata){
        let output = [];
        LCdata.forEach((LC)=>{
            LC.metricsData.labels.forEach((label,labelKey)=>{
                let LCnew = {
                    epoch: LC.epoch + '-' + label,
                    epochResults: LC.epochResults[label],
                    metricsData: {
                        confusionMatrix: LC.metricsData.confusionMatrices[label],
                        f1: LC.metricsData.f1[labelKey],
                        labels: [
                            label + "_positive",
                            label + "_negative"
                        ],
                        testAccuracy: LC.metricsData.testAccuracies[labelKey],
                        trainingAccuracy: LC.metricsData.trainingAccuracies[labelKey],
                        trainingLoss: null
                    }
                };
            output.push(LCnew);
            });
        });
        return output;
    },

    formatDetectionData : function(LCData) {
        let output = [];
        LCData.forEach((LC)=>{
            let LCnew = LC;
            LCnew.metricsData.f1 = [];
            LCnew.metricsData.labels = [];
            LC.metricsData.labelMetrics.forEach((lm, lmKey) => {
                LCnew.metricsData.f1.push(lm.f1);
                LCnew.metricsData.labels.push(lm.label);
                LCnew.metricsData.trainingLoss = LC.metricsData.modelMetrics.trainingLoss;
                LCnew.metricsData.testAccuracy = LC.metricsData.modelMetrics.meanAveragePrecision;
            });
            output.push(LCnew);
        });
        return output;
    },
})
