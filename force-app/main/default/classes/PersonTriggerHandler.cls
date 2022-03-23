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

    public static void afterUpdate(List<Person__c> newRecords, Map<Id, Person__c> oldRecordsMap) {
        
        Set<Id> statusChange = new Set<Id>();
        Set<Id> redStatus = new Set<Id>();

        for(Person__c person : newRecords) {
            // check if the status changed in this transaction
            // also update Status_Update_Date__c
            if( person.Health_Status__c != oldRecordsMap.get(person.id).Health_Status__c) {
                statusChange.add(person.Id);
            }

            if(person.Health_Status__c == 'Red' && oldRecordsMap.get(person.Id).Health_Status__c != 'Red') {
                redStatus.add(person.Id);
            }
        }

        Set<Id> alreadyProcessed = new Set<Id>();
        alreadyProcessed.addAll(redStatus);

        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();
        
        //lets add cohabitants
        orangeStatus.addAll(CTPersonController.getCohabitants(redStatus, alreadyProcessed));

        //lets add neighbours
        yellowStatus.addAll(CTPersonController.getNeighbours(redStatus, alreadyProcessed));

        //lets add primaryContacts
        Set<Id> primaryContacts = CTPersonController.getPrimaryContacts(redStatus, alreadyProcessed);
        orangeStatus.addAll(primaryContacts);

        //lets add secondaryContacts
        yellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryContacts, alreadyProcessed));
    }
}