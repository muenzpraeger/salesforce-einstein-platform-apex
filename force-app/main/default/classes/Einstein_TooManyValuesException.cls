public class Einstein_TooManyValuesException extends Exception {

    public Einstein_TooManyValuesException(String field, Integer maxValue, Integer currentValue) {
        setMessage('The maximum allowed number of entries for "' + field + '" is ' + maxValue + ' (current: ' + currentValue + ').');
    }

}