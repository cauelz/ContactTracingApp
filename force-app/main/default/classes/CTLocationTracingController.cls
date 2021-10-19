public class CTLocationTracingController {

    public static List<Location_Tracing__c> getVisitors(String locationId) {
        List<Location_Tracing__c> locationTracingList = [SELECT CreatedById, CreatedDate, 
                                                            Id, IsDeleted, LastModifiedById, LastModifiedDate, 
                                                            LastReferencedDate, LastViewedDate, Location__c, 
                                                            Name, Person__c, SystemModstamp, Visit_Date__c
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
        List<Location_Tracing__c> locationTracingList = [SELECT CreatedById, CreatedDate, 
        Id, IsDeleted, LastModifiedById, LastModifiedDate, 
        LastReferencedDate, LastViewedDate, Location__c, 
        Name, Person__c, SystemModstamp, Visit_Date__c
        FROM Location_Tracing__c 
        WHERE Id =: locationId
        ORDER BY Visit_Date__c DESC];
    }

}
