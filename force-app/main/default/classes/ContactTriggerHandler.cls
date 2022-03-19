<<<<<<< HEAD
public class ContactTriggerHandler {

    public static void afterInsertHandler(List<Contact> newRecords) {

        List<Contact> contactWithAcc = new List<Contact>();
        for(Contact contact : newRecords) {
            if(String.isNotBlank(contact.AccountId)) {
                contactWithAcc.add(contact);
            }
        }

        Map<Id, List<Contact>> accIdActiveContactsMap = new Map<Id, List<Contact>>();
        
        for(Contact newContact : contactWithAcc) {
            
            if(!accIdActiveContactsMap.containsKey(newContact.AccountId)) {
                List<Contact> contactList = new List<Contact>();
                contactList.add(newContact);
                accIdActiveContactsMap.put(newContact.AccountId, contactList);
            }

            if(!accIdActiveContactsMap.get(newContact.AccountId).contains(newContact) && newContact.Active__c == true) {
                accIdActiveContactsMap.get(newContact.AccountId).add(newContact);
            }
        }

        List<Account> accToBeUpdated = new List<Account>();
        for(Account acc : [SELECT Id, ActiveContacts__c FROM Account WHERE Id IN: accIdActiveContactsMap.keySet()]) {
            System.debug(acc.ActiveContacts__c);
            System.debug(accIdActiveContactsMap.get(acc.Id).size());
            if(acc.ActiveContacts__c == null) {
                acc.ActiveContacts__c = 0;
            }
            acc.ActiveContacts__c = acc.ActiveContacts__c + accIdActiveContactsMap.get(acc.Id).size();
            accToBeUpdated.add(acc);
        }

        upsert accToBeUpdated;
    }

    public static void afterUpdateHandler(List<Contact> newRecords) {

        Map<Id, List<Contact>> accIdActiveContactsMap = new Map<Id, List<Contact>>();


        
        
    }

    public static void afterDeleteHandler(List<Contact> newRecords) {

    }

    public static void afterUndeleteHandler(List<Contact> newRecords) {

    }

=======
public with sharing class ContactTriggerHandler {
    
    public static void afterInsertHandler(List<Contact> newConctacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : newConctacts) {
            if(String.isNotBlank(con.AccountId)) {
                accountIds.add(con.AccountId);
            }
        }

        AccountContactService.updateActiveContacts(accountIds);
    }

    public static void afterUpdateHandler(List<Contact> newContacts, Map<Id, Contact> oldContactMap) {
        Set<Id> accountIds = new Set<Id>();

        for(Contact con : newContacts) {
            
            if(String.isNotBlank(con.AccountId) && oldContactMap.get(con.Id).Active__c != con.Active__c) {
                accountIds.add(con.AccountId);
            } else if(oldContactMap.get(con.Id).AccountId != con.AccountId) {
                accountIds.add(con.AccountId);
                accountIds.add(oldContactMap.get(con.Id).AccountId);
            }
        }

        AccountContactService.updateActiveContacts(accountIds);
    }

    public static void afterDeleteHandler(List<Contact> oldContacts) {

        Set<Id> accountIds = new Set<Id>();

        for(Contact con : oldContacts) {
            if(String.isNotBlank(con.AccountId)) {
                accountIds.add(con.AccountId);
            }
        }
        AccountContactService.updateActiveContacts(accountIds);
    }

    public static void afterUndeleteHandler(List<Contact> newContacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : newContacts) {
            if(String.isNotBlank(con.AccountId)) {
                accountIds.add(con.AccountId);
            }
        }

        AccountContactService.updateActiveContacts(accountIds);
    }
>>>>>>> 6a4484d0981f54e7422bffe116c2136553ca0468
}
