public class CTLocationTracingController {

    public static String getToken(String mobileNumber) {

        Blob mobileBlob = Blob.valueOf(mobileNumber);
        Blob mobileHash = Crypto.generateDigest('MD5', mobileBlob);
        String mobileStringHash = String.valueOf(mobileHash);

        return mobileStringHash;
    }

}
