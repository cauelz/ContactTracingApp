public class CTLocationController {

    public static List<Location__c> getRecentStatusChanges() {
        List<Location__c> locationList = [SELECT Address__c, CreatedById, 
                                            CreatedDate, Id, IsDeleted, 
                                            LastModifiedById, LastModifiedDate, 
                                            LastReferencedDate, LastViewedDate, 
                                            Name, OwnerId, Pincode__c, 
                                            Red_Score__c, Status_Update_Date__c, 
                                            Status__c, SystemModstamp
                                            FROM Location__c
                                            ORDER BY Status_Update_Date__c DESC
                                            NULLS LAST LIMIT 100];
        if(!locationList.isEmpty()) {
            return locationList;
        }
        return null;
        
    }

    public static List<Location__c> searchLocations (String searchTerm) {
        searchTerm = searchTerm + '%';

        List<Location__c> locationList = [SELECT Address__c, CreatedById, 
                                            CreatedDate, Id, IsDeleted, 
                                            LastModifiedById, LastModifiedDate, 
                                            LastReferencedDate, LastViewedDate, 
                                            Name, OwnerId, Pincode__c, 
                                            Red_Score__c, Status_Update_Date__c, 
                                            Status__c, SystemModstamp
                                            FROM Location__c
                                            WHERE Name LIKE: searchTerm OR
                                            Pincode__c LIKE: searchTerm OR
                                            Address__c LIKE: searchTerm
                                            ORDER BY Status_Update_Date__c NULLS LAST];

        if(!locationList.isEmpty()) {
            return locationList;
        }

        return null;
        
    }

    public static Location__c getLocationById (String locationId) {
        List<Location__c> location = [SELECT Address__c, CreatedById, 
                                        CreatedDate, Id, IsDeleted, 
                                        LastModifiedById, LastModifiedDate, 
                                        LastReferencedDate, LastViewedDate, 
                                        Name, OwnerId, Pincode__c, 
                                        Red_Score__c, Status_Update_Date__c, 
                                        Status__c, SystemModstamp
                                        FROM Location__c
                                        WHERE Id =: locationId];
        if(!location.isEmpty()) {
            return location.get(0);
        }

        return null;
    }

    public static Map<String, Integer> getStatusCount() {
        Map<String, Integer> mapOfLocations = new Map<String, Integer>();
        for(AggregateResult ar : [SELECT Status__c, COUNT(Id) total FROM Location__c GROUP BY Status__c]) {
            mapOfLocations.put( (String) ar.get('Status__c'), (Integer) ar.get('total'));
        }
        return mapOfLocations;
    }
}