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

            results.forEach( (example) => {
                if (example.expectedLabel === outputMember.expected && example.predictedLabel === outputMember.predicted){
                    outputMember.examples.push(example.exampleName);
                }
            });
            outputMember.examplesString = outputMember.examples.join();
            output.push(outputMember);
        });

        return output;
    }
})
