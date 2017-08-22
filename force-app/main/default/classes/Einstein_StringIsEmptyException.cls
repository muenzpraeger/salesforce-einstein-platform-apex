public class Einstein_StringIsEmptyException extends Exception {
    
    public Einstein_StringIsEmptyException(String field, String check) {        setMessage('The field "' + field + '" cannot be empty.');    }

}