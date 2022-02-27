public with sharing class PersonTriggerHandler {

    public static void beforeInsert(List<Person__c> newRecords) {

        // todo: update health status to green
        // todo: generate unique token for the person record

        for(Person__c person : newRecords) {
            person.Health_Status__c = 'green';
            person.Token__c = CTPersonController.getToken(person.Mobile__c);
        }
    }

    public static void beforeUpdate(List<Person__c> newRecords, Map<Id, Person__c> oldRecordsMap) {
        
        for(Person__c person : newRecords) {
            // check if the status changed in this transaction
            // also update Status_Update_Date__c
            if( person.Health_Status__c != oldRecordsMap.get(person.id).Health_Status__c) {
                person.Status_Update_Date__c = Date.today();
            }
        }
    }
}
