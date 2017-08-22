public class Einstein_NumberTooSmallException extends Exception {
    
    public Einstein_NumberTooSmallException (String field, Decimal minValue, Decimal currentValue) {
        setMessage('The minimum allowed size for "' + field + '" is ' + minValue + ' (current: ' + currentValue + ').'); 
    }

}