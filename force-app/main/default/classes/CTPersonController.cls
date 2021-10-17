public class CTPersonController {

    /**
     * Return a list of people
     */

    public static List<Person__c> getRecentHealthChanges() {

        List<Person__c> personList = [SELECT CreatedById, CreatedDate, Health_Status__c, Id, IsDeleted, 
                                        LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Mobile__c, Name, 
                                        OwnerId, Status_Update_Date__c, SystemModstamp, Token__c
                                        FROM Person__c
                                        ORDER BY Status_Update_Date__c 
                                        DESC LIMIT 100];

        return personList;
    }

    /**
     * Search for a person by Name, Mobile or Token
     */
    public static List<Person__c> searchPeople(String searchTerm) {
        searchTerm = searchTerm + '%';

        List<Person__c> personList = [SELECT CreatedById, CreatedDate, Health_Status__c, Id, IsDeleted, 
                                        LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Mobile__c, Name, 
                                        OwnerId, Status_Update_Date__c, SystemModstamp, Token__c
                                        FROM Person__c
                                        WHERE Name LIKE: searchTerm 
                                            OR Mobile__c LIKE: searchTerm 
                                            OR Token__c LIKE: searchTerm
                                        ORDER BY Status_Update_Date__c DESC NULLS LAST];
        System.debug('Search Result' + personList);
        return personList;
    }

    /**
     * return a person by its Id;
     */
    public static Person__c getPersonById(String personId) {
        List<Person__c> person = [SELECT CreatedById, CreatedDate, Health_Status__c, Id, IsDeleted, 
                            LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Mobile__c, Name, 
                            OwnerId, Status_Update_Date__c, SystemModstamp, Token__c
                            FROM Person__c 
                            WHERE Id =: personId];
        if(!person.isEmpty()) {
            return person[0];
        }
        return null;
    }

    public static String getToken(String mobileNumber) {

        Blob mobileBlob = Blob.valueOf(mobileNumber);
        Blob mobileHash = Crypto.generateDigest('MD5', mobileBlob);

        // get the string value of hash blob
        return EncodingUtil.base64Encode(mobileHash);
    }
}
