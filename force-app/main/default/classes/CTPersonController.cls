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
                                        DESC NULLS LAST LIMIT 100];

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

    public static Map<String, Integer> getHealthStatusCount() {

        Map<String, Integer> healthCountMap = new Map<String, Integer>();
        for(AggregateResult ar : [SELECT Health_Status__c, COUNT(Id) total FROM Person__c GROUP BY Health_Status__c]) {
            healthCountMap.put((String) ar.get('Health_Status__c'), (Integer) ar.get('total'));
        }

        return healthCountMap;
    }

    public static Set<Id> getCohabitants(Set<Id> personIds) {
        List<String> healthStatus = new List<String>{'Green', 'Yellow'};

        List<People_Tracing__c> peopleTraces = [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE (Person_1__c IN: personIds OR Person_2__c IN: personIds)
            AND Contact_Type__c = 'Cohabitant'
            AND (Person_1__r.Health_Status__c IN: healthStatus OR Person_2__r.Health_Status__c IN: healthStatus)
        ];

        Set<Id> cohabitants = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces) {
            if(!personIds.contains(pt.Person_1__c)) {
                cohabitants.add(pt.Person_1__c);
            }

            if(!personIds.contains(pt.Person_2__c)) {
                cohabitants.add(pt.Person_2__c);
            }
        }

        return cohabitants;
    }

    public static Set<Id> getNeighbours(Set<Id> personIds) {

        List<People_Tracing__c> peopleTraces = [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE (Person_1__c IN: personIds OR Person_2__c IN: personIds)
            AND Contact_Type__c = 'Neighbour'
            AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
        ];

        Set<Id> neighbours = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces) {
            if(!personIds.contains(pt.Person_1__c)) {
                neighbours.add(pt.Person_1__c);
            }

            if(!personIds.contains(pt.Person_2__c)) {
                neighbours.add(pt.Person_2__c);
            }
        }

        return neighbours;
    }

    public static Set<Id> getPrimaryContacts(Set<Id> personIds) {

        List<String> healthStatus = new List<String>{'Green', 'Yellow'};

        List<People_Tracing__c> peopleTraces = [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE (Person_1__c IN: personIds OR Person_2__c IN: personIds)
            AND Contact_Type__c = 'Other'
            AND Contact_Date__c = LAST_N_DAYS:10 
            AND (Person_1__r.Health_Status__c IN:healthStatus OR Person_2__r.Health_Status__c IN:healthStatus)
        ];

        Set<Id> primaryContacts = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces) {
            if(!personIds.contains(pt.Person_1__c)) {
                primaryContacts.add(pt.Person_1__c);
            }

            if(!personIds.contains(pt.Person_2__c)) {
                primaryContacts.add(pt.Person_2__c);
            }
        }

        return primaryContacts;
    }

    public static Set<Id> getSecondaryContacts(Set<Id> primaryIds) {

        List<People_Tracing__c> peopleTraces = [
            SELECT Id, Person_1__c, Person_2__c
            FROM People_Tracing__c
            WHERE (Person_1__c IN: primaryIds OR Person_2__c IN: primaryIds)
            AND Contact_Type__c = 'Other'
            AND Contact_Date__c = LAST_N_DAYS:10
            AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')
        ];

        Set<Id> secondaryContacts = new Set<Id>();
        for(People_Tracing__c pt : peopleTraces) {
            if(!primaryIds.contains(pt.Person_1__c)) {
                secondaryContacts.add(pt.Person_1__c);
            }

            if(!primaryIds.contains(pt.Person_2__c)) {
                secondaryContacts.add(pt.Person_2__c);
            }
        }

        return secondaryContacts;
    }
}