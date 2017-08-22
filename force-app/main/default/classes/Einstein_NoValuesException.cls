public class Einstein_NoValuesException extends Exception {

    public Einstein_NoValuesException(String field, String check) {        setMessage('You have not provided any values for "' + field + '".');    }
    
}