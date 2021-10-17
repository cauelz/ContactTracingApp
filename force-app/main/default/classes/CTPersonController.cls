public class CTPersonController {

    public static String getToken(String mobileNumber) {

        Blob mobileBlob = Blob.valueOf(mobileNumber);
        Blob mobileHash = Crypto.generateDigest('MD5', mobileBlob);

        // get the string value of hash blob
        return EncodingUtil.base64Encode(mobileHash);
    }
}
