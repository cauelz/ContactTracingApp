trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {

    switch on Trigger.operationType {
        when AFTER_INSERT {
            Set<Id> accountIds = new Set<Id>();
            for(Contact con : Trigger.new) {
                if(String.isNotBlank(con.AccountId)) {
                    accountIds.add(con.AccountId);
                }
            }

            List<AggregateResult> results = [
                SELECT AccountId, COUNT(Id) totalContacts
                FROM Contact
                WHERE Active__c = TRUE AND AccountId IN: accountIds
                GROUP BY AccountId
            ];

            List<Account> accountsToUpdate = new List<Account>();

            for(AggregateResult result : results) {
                String accId = String.valueOf(result.get('AccountId'));
                Integer totalContacts = Integer.valueOf(result.get('totalContacs'));

                Account acc = new Account(Id = accId, ActiveContacts__c = totalContacts);

                accountsToUpdate.add(acc);
            }

            update accountsToUpdate;
        }

        when AFTER_UPDATE {
            Set<Id> accountIds = new Set<Id>();

            for(Contact con : Trigger.new) {
                
                if(String.isNotBlank(con.AccountId) && Trigger.oldMap.get(con.Id).Active__c != con.Active__c) {
                    accountIds.add(con.AccountId);
                } else if(Trigger.oldMap.get(con.Id).AccountId != con.AccountId) {
                    accountIds.add(con.AccountId);
                    accountIds.add(Trigger.oldMap.get(con.Id).AccountId);
                }
            }

            List<AggregateResult> results = [
                SELECT AccountId, COUNT(Id) totalContacts 
                FROM Contact
                WHERE Active__c = TRUE AND AccountId IN: accountIds
                GROUP BY AccountId 
            ];

            List<Account> accountsToUpdate = new List<Account>();
            for(AggregateResult result : results) {
                String accId = String.valueOf(result.get('AccountId'));
                Integer totalContacts = Integer.valueOf(result.get('totalContacts'));

                Account acc = new Account(Id = accId, ActiveContacts__c = totalContacts);

                accountsToUpdate.add(acc);
            }

            update accountsToUpdate;
        }
    }
}