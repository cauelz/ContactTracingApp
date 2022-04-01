@isTest
public with sharing class ContactTriggerHandlerTest {
    
    @TestSetup
    public static void makeData(){
        List<Account> testAccounts = new List<Account>();
        Account acc1 = new Account(Name='Test 1');
        Account acc2 = new Account(Name='Test 2');

        testAccounts.add(acc1);
        testAccounts.add(acc2);

        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(LastName='Test Contact 1', AccountId = testAccounts[0].Id, Active__c = true));
        testContacts.add(new Contact(LastName='Test Contact 2', AccountId = testAccounts[0].Id, Active__c = true));
        testContacts.add(new Contact(LastName='Test Contact 3', AccountId = testAccounts[0].Id));
        testContacts.add(new Contact(LastName='Test Contact 4', AccountId = testAccounts[0].Id));
        testContacts.add(new Contact(LastName='Test Contact 5', AccountId = testAccounts[1].Id));

        insert testContacts;
    }

    @isTest
    public static void afterInsertHandlerTest2() {

        List<Account> accs = [SELECT Id, Name, ActiveContacts__c FROM Account];
        System.assertEquals(2, accs.size());

        for (Account acc : accs) {
            if(acc.Name == 'Test 1') {
                System.assertEquals(2, acc.ActiveContacts__c);
            }
            if(acc.Name == 'Test 2') {
                System.assertEquals(0, acc.ActiveContacts__c);
            }
        }

        List<Contact> contacts = [SELECT Id FROM Contact];
        System.assertEquals(5, contacts.size());

    }

    @isTest
    public static void afterInsertHandlerTestBulk() {

        Account accTest1 = [SELECT Id, Name FROM Account WHERE Name = 'Test 1'];
        List<Contact> testContacts = new List<Contact>();

        for (Integer i = 0; i < 1000; i++) {
            testContacts.add(new Contact(LastName='Test Contact' + i, AccountId = accTest1.Id, Active__c = true));
        }

        insert testContacts;

        List<Account> accs = [SELECT Id, Name, ActiveContacts__c FROM Account];
        System.assertEquals(2, accs.size());

        for (Account acc : accs) {
            if(acc.Name == 'Test 1') {
                System.assertEquals(1002, acc.ActiveContacts__c);
            }
            if(acc.Name == 'Test 2') {
                System.assertEquals(0, acc.ActiveContacts__c);
            }
        }

        List<Contact> contacts = [SELECT Id FROM Contact];
        System.assertEquals(1005, contacts.size());

    }

    @isTest
    public static void afterUpdateHandlerTest1() {

        List<Contact> contacts = [SELECT Id, LastName FROM Contact];

        for(Contact con : contacts) {
            if(con.LastName == 'Test Contact 3' || con.LastName == 'Test Contact 4') {
                con.Active__c = true;
            }
        }

        Test.startTest();

        update contacts;

        Test.stopTest();

        List<Account> accs = [SELECT Id, Name, ActiveContacts__c FROM Account];
        System.assertEquals(2, accs.size());

        for (Account acc : accs) {
            if(acc.Name == 'Test 1') {
                System.assertEquals(4, acc.ActiveContacts__c);
            }
            if(acc.Name == 'Test 2') {
                System.assertEquals(0, acc.ActiveContacts__c);
            }
        }

        System.assertEquals(5, contacts.size());
    }

    @isTest
    public static void afterUpdateHandlerTest2() {
        Account accTest2 = [SELECT Id, Name FROM Account WHERE Name = 'Test 2'];
        List<Contact> contacts = [SELECT Id, LastName FROM Contact];

        for(Contact con : contacts) {
            if(con.LastName == 'Test Contact 3') {
                con.Active__c = true;
                con.AccountId = accTest2.Id;
            }
        }

        Test.startTest();

        update contacts;

        Test.stopTest();

        List<Account> accs = [SELECT Id, Name, ActiveContacts__c FROM Account];
        System.assertEquals(2, accs.size());

        for (Account acc : accs) {
            if(acc.Name == 'Test 1') {
                System.assertEquals(2, acc.ActiveContacts__c);
            }
            if(acc.Name == 'Test 2') {
                System.assertEquals(1, acc.ActiveContacts__c);
            }
        }

        System.assertEquals(5, contacts.size());
    }

    @isTest
    public static void afterDeleteHandlerTest() {
        List<Contact> contacts = [SELECT Id, LastName FROM Contact WHERE LastName IN ('Test Contact 1', 'Test Contact 5')];

        Test.startTest();
        delete contacts;
        Test.stopTest();

        List<Account> accs = [SELECT Id, Name, ActiveContacts__c FROM Account];
        System.assertEquals(2, accs.size());

        for (Account acc : accs) {
            if(acc.Name == 'Test 1') {
                System.assertEquals(1, acc.ActiveContacts__c);
            }
            if(acc.Name == 'Test 2') {
                System.assertEquals(0, acc.ActiveContacts__c);
            }
        }

        List<Contact> allContacts = [SELECT Id, LastName FROM Contact];

        System.assertEquals(3, allContacts.size());
    }

    @isTest
    public static void afterUndeleteHandlerTest() {
        List<Contact> contacts = [SELECT Id, LastName FROM Contact WHERE LastName IN ('Test Contact 1', 'Test Contact 5')];
        delete contacts;


        Test.startTest();
        undelete contacts;
        Test.stopTest();

        List<Account> accs = [SELECT Id, Name, ActiveContacts__c FROM Account];
        System.assertEquals(2, accs.size());

        for (Account acc : accs) {
            if(acc.Name == 'Test 1') {
                System.assertEquals(2, acc.ActiveContacts__c);
            }
            if(acc.Name == 'Test 2') {
                System.assertEquals(0, acc.ActiveContacts__c);
            }
        }

        List<Contact> allContacts = [SELECT Id, LastName FROM Contact];

        System.assertEquals(5, allContacts.size());
    }
}
