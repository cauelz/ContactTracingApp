public class AccountTriggerHandler {

    public static void beforeInsertHandler(List<Contact> newRecords) {

    }

    public static void afterInsertHandler(List<Contact> newRecords) {

        for(Contact newAcc : newRecords) {
            
        }
    }

    public static void beforeUpdateHandler(List<Contact> newRecords) {

    }

    public static void afterUpdateHandler(List<Contact> newRecords) {
        
    }
}
