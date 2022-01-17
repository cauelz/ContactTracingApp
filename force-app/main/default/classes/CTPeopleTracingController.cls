public with sharing class CTPeopleTracingController {


    public static List<People_Tracing__c> getTraces(String personId) {
        return [SELECT Id, Contact_Date__c, Person_1__c, Person_1__r.Health_Status__c, Person_1__r.Token__c, Person_2__c, Person_2__r.Health_Status__c, Person_2__r.Token__c
        FROM People_Tracing__c 
        WHERE Person_1__c =: personId OR Person_2__c =: personId
        ORDER BY Contact_Date__c DESC];
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces) {
        // Unique person id Set
        Set<Id> personIds = new Set<Id>();

        for(People_Tracing__c traces : newPeopleTraces) {
            personIds.add(traces.Person_1__c);
            personIds.add(traces.Person_2__c);
        }
        // list duplicate records
        List<People_Tracing__c> duplicates = new List<People_Tracing__c>();
        // map id and set<id>
        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();

        List<People_Tracing__c> existingRecords = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c 
                                                    WHERE Person_1__c IN : personIds
                                                    OR Person_2__c IN: personIds];
        if(!existingRecords.isEmpty()) {
            for(People_Tracing__c trace : existingRecords) {

                // build map for person 1
                if(!mapOfExistingRecords.containsKey(trace.Person_1__c)) {
                    mapOfExistingRecords.put(trace.Person_1__c, new Set<Id>());
                }
                mapOfExistingRecords.get(trace.Person_1__c).add(trace.Person_2__c);

                // build map for person 2
                if(!mapOfExistingRecords.containsKey(trace.Person_2__c)) {
                    mapOfExistingRecords.put(trace.Person_2__c, new Set<Id>()); 
                }
                mapOfExistingRecords.get(trace.Person_2__c).add(trace.Person_1__c);

                // looping over new records to check if there are duplicates
                for(People_Tracing__c newTrace : newPeopleTraces) {
                    // checking if there are duplicates in the person 1 and person 2
                    if(
                        mapOfExistingRecords.containsKey(newTrace.Person_1__c) && mapOfExistingRecords.get(newTrace.Person_1__c).contains(newTrace.Person_2__c)
                        ||
                        mapOfExistingRecords.containsKey(newTrace.Person_2__c) && mapOfExistingRecords.get(newTrace.Person_2__c).contains(newTrace.Person_1__c)
                    ) {
                        duplicates.add(newTrace);
                    }
                }
                
            }                                            
        }

        return duplicates;
    }
}