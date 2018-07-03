public virtual class Einstein_HttpBodyPart {

    public Einstein_HttpBodyPart() {
    }

    //  The boundary is alligned so it doesn't produce padding characters when base64 encoded.
    private final static string Boundary = '1ff13444ed8140c7a32fc4e6451aa76d';


    public static String getBoundary() {
        return Boundary;
    }


    /**
     *  Returns the request's content type for multipart/form-data requests.
     */
    public static string GetContentType() {
        return 'multipart/form-data; charset="UTF-8"; boundary="' + Boundary + '"';
    }

    /**
     *  Pad the value with spaces until the base64 encoding is no longer padded.
     */
    public static string SafelyPad(
        string value,
        string valueCrLf64,
        string lineBreaks) {
        string valueCrLf = '';
        blob valueCrLfBlob = null;

        while (valueCrLf64.endsWith('=')) {
            value += ' ';
            valueCrLf = value + lineBreaks;
            valueCrLfBlob = blob.valueOf(valueCrLf);
            valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);
        }

        return valueCrLf64;
    }

    /**
     *  Write a boundary between parameters to the form's body.
     */
    public static string WriteBoundary() {
        string value = '--' + Boundary + '\r\n';
        blob valueBlob = blob.valueOf(value);

        return EncodingUtil.base64Encode(valueBlob);
    }

    /**
     *  Write a boundary at the end of the form's body.
     */
    public static string WriteBoundary(
        EndingType ending) {
        string value = '';

        if (ending == EndingType.Cr) {
            //  The file's base64 was padded with a single '=',
            //  so it was replaced with '\r'. Now we have to
            //  prepend the boundary with '\n' to complete
            //  the line break.
            value += '\n';
        } else if (ending == EndingType.None) {
            //  The file's base64 was not padded at all,
            //  so we have to prepend the boundary with
            //  '\r\n' to create the line break.
            value += '\r\n';
        }
        //  Else:
        //  The file's base64 was padded with a double '=',
        //  so they were replaced with '\r\n'. We don't have to
        //  do anything to the boundary because there's a complete
        //  line break before it.

        value += '--' + Boundary + '--';

        blob valueBlob = blob.valueOf(value);

        return EncodingUtil.base64Encode(valueBlob);
    }

    public static String WriteBodyParameter(String key, Integer value) {
        return WriteBodyParameter(key, String.valueOf(value));
    }

    /**
     *  Write a key-value pair to the form's body.
     */
    public static string WriteBodyParameter(
        string key,
        string value) {
        string contentDisposition = 'Content-Disposition: form-data; name="' + key + '"';
        string contentDispositionCrLf = contentDisposition + '\r\n\r\n';
        blob contentDispositionCrLfBlob = blob.valueOf(contentDispositionCrLf);
        string contentDispositionCrLf64 = EncodingUtil.base64Encode(contentDispositionCrLfBlob);
        string content = SafelyPad(contentDisposition, contentDispositionCrLf64, '\r\n\r\n');
        string valueCrLf = value + '\r\n';
        blob valueCrLfBlob = blob.valueOf(valueCrLf);
        string valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);

        content += SafelyPad(value, valueCrLf64, '\r\n');

        return content;
    }

  /**
     *  Write a key-value pair to the form's body for a blob.
     */
    public static string WriteBlobBodyParameter(string key, string file64, string fileName) {

        String mimeType = resolveMimeType(fileName);

        string contentDisposition = 'Content-Disposition: form-data; name="' + key + '"; filename="'+fileName+'"';
        string contentDispositionCrLf = contentDisposition + '\r\n';
        blob contentDispositionCrLfBlob = blob.valueOf(contentDispositionCrLf);
        string contentDispositionCrLf64 = EncodingUtil.base64Encode(contentDispositionCrLfBlob);
        string content = SafelyPad(contentDisposition, contentDispositionCrLf64, '\r\n');

        string contentTypeHeader = 'Content-Type: ' + mimeType;
        string contentTypeCrLf = contentTypeHeader + '\r\n\r\n';
        blob contentTypeCrLfBlob = blob.valueOf(contentTypeCrLf);
        string contentTypeCrLf64 = EncodingUtil.base64Encode(contentTypeCrLfBlob);
        content += SafelyPad(contentTypeHeader, contentTypeCrLf64, '\r\n\r\n');

        integer file64Length = file64.length();
        String last4Bytes = file64.substring(file64.length()-4,file64.length());

        // Avoid padding the file data with spaces, which SafelyPad does
        // http://salesforce.stackexchange.com/a/33326/102
        EndingType ending = EndingType.None;
        if (last4Bytes.endsWith('==')) {
            // The '==' sequence indicates that the last group contained only one 8 bit byte
            // 8 digit binary representation of CR is 00001101
            // 8 digit binary representation of LF is 00001010
            // Stitch them together and then from the right split them into 6 bit chunks
            // 0000110100001010 becomes 0000 110100 001010
            // Note the first 4 bits 0000 are identical to the padding used to encode the
            // second original 6 bit chunk, this is handy it means we can hard code the response in
            // The decimal values of 110100 001010 are 52 10
            // The base64 mapping values of 52 10 are 0 K
            // See http://en.wikipedia.org/wiki/Base64 for base64 mapping table
            // Therefore, we replace == with 0K
            // Note: if using \n\n instead of \r\n replace == with 'oK'
            last4Bytes = last4Bytes.substring(0,2) + '0K';
            file64 = file64.substring(0,file64.length()-4) + last4Bytes;
            // We have appended the \r\n to the Blob, so leave footer as it is.
            ending = EndingType.CrLf;
        } else if (last4Bytes.endsWith('=')) {
            // '=' indicates that encoded data already contained two out of 3x 8 bit bytes
            // We replace final 8 bit byte with a CR e.g. \r
            // 8 digit binary representation of CR is 00001101
            // Ignore the first 2 bits of 00 001101 they have already been used up as padding
            // for the existing data.
            // The Decimal value of 001101 is 13
            // The base64 value of 13 is N
            // Therefore, we replace = with N
            last4Bytes = last4Bytes.substring(0,3) + 'N';
        	file64 = file64.substring(0,file64.length()-4) + last4Bytes;
            // We have appended the CR e.g. \r, still need to prepend the line feed to the footer
            ending = EndingType.Cr;
        }

        content += file64;

        content += WriteBoundary(ending);
        return content;
    }

    private static String resolveMimeType(String fileName) {
        String fileType = fileName.substringAfterLast('.');
        String mimeType = 'image/png'; // fallback value
        if (fileType.equalsIgnoreCase('png')) {
            mimeType = 'image/png';
        } else if (fileType.equalsIgnoreCase('jpeg') || fileType.equalsIgnoreCase('jpg')) {
            mimeType = 'image/jpeg';
        } else if (fileType.equalsIgnoreCase('pgm')) {
            mimeType = 'image/x-portable-graymap';
        } else if (fileType.equalsIgnoreCase('ppm')) {
            mimeType = 'image/x-portable-pixmap';
        }
        return mimeType;
    }

    /**
     *  Helper enum indicating how a file's base64 padding was replaced.
     */
    public enum EndingType {
        Cr,
        CrLf,
        None
    }
}