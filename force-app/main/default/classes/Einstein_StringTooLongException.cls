public class Einstein_StringTooLongException extends Exception {

    public Einstein_StringTooLongException(String field, Integer maxValue, Integer currentValue) {
        setMessage('The maximum allowed length for "' + field + '" is ' + maxValue + ' (current: ' + currentValue + ').');
    }

}