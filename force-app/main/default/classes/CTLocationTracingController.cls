public class CTLocationTracingController {

    public static List<Location_Tracing__c> getVisitors(String locationId) {
        List<Location_Tracing__c> locationTracingList = [SELECT CreatedById, CreatedDate, 
                                                            Id, IsDeleted, LastModifiedById, LastModifiedDate, 
                                                            LastReferencedDate, LastViewedDate, Location__c, 
                                                            Name, Person__c, Person__r.Name, Person__r.Token__c, Person__r.Health_Status__c, 
                                                            SystemModstamp, Visit_Date__c
                                                            FROM Location_Tracing__c 
                                                            WHERE Id =: locationId
                                                            ORDER BY Visit_Date__c DESC
                                                            NULLS LAST];
        if(!locationTracingList.isEmpty()) {
            return locationTracingList;
        }

        return null;
    }


    public static List<Location_Tracing__c> getLocationByPersonIds(Set<Id> personIds) {
        List<Location_Tracing__c> locationTracingList = [SELECT Id,LastViewedDate, Location__c, 
                                                            Person__c, Person__r.Name, Person__r.Token__c, Person__r.Health_Status__c, 
                                                            Visit_Date__c
                                                            FROM Location_Tracing__c
                                                            WHERE Person__c IN: personIds
                                                            AND Visit_Date__c = LAST_N_DAYS:10];
        if(!locationTracingList.isEmpty()) {
            return locationTracingList;
        }

        return null;
    }

    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds) {
        List<Location_Tracing__c> locationTracingList = [SELECT Id, Location__c, 
                                                            Person__c, Visit_Date__c
                                                            FROM Location_Tracing__c
                                                            WHERE Location__r.Id IN: locationIds
                                                            AND Person__r.Health_Status__c = 'Green'
                                                            AND Visit_Date__c = LAST_N_DAYS:10];
        if(!locationTracingList.isEmpty()) {
            return locationTracingList;
        }

        return null;
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces) {
        // store unique location ids
        Set<Id> locationIds = new Set<Id>();
        // store unique person ids
        Set<Id> personIds = new Set<Id>();

        // map of location id, set of person ids
        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();

        // list of duplicate records
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();

        // query existing location tracing records
        for(Location_Tracing__c trace : newLocationTraces) {
            locationIds.add(trace.Location__c);
            personIds.add(trace.Person__c);
        }

        List<Location_Tracing__c> existingRecords = [SELECT Id, Person__c, Location__c FROM Location_Tracing__c 
                                                        WHERE Location__c IN: locationIds
                                                        AND Person__c IN: personIds];

        // If existingRecords is not empty, then we can iterate over de list
        if(!existingRecords.isEmpty()) {
            for(Location_Tracing__c trace : existingRecords) {

                // If mapOfExistingRecords doesn't have the key Location__c, create a new pair of key-value.
                if(! mapOfExistingRecords.containsKey(trace.Location__c)) {
                    mapOfExistingRecords.put(trace.Location__c, new Set<Id>());
                }

                // add person ids to map set
                mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);

                // loop over new location tracing records
                for (Location_Tracing__c newTrace : newLocationTraces) {
                    // first check for location id
                    // if item found in map, then check for person in set

                    if(mapOfExistingRecords.containsKey(newTrace.Location__c) 
                        && mapOfExistingRecords.get(newTrace.Location__c).contains(newTrace.Person__c)) {
                            duplicates.add(newTrace);
                    }
                }
            }
        }
        return duplicates;
    }

}
