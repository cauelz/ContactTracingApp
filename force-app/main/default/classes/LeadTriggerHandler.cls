public class LeadTriggerHandler {
 
    public static boolean alreadyExecuted = false;

    public static void beforeInsertHandler(List<Lead> newRecords) {
        for(Lead leadRecord : newRecords) {
            // if the leadSource is blank, then make it "other"
            if(String.isBlank(leadRecord.LeadSource)) {
                leadRecord.LeadSource = 'Other'; 
            }
            
            // validation rules on industry field
            if(String.isBlank(leadRecord.Industry)) {
                leadRecord.addError('Não esqueca de preencher o campo Industria');
            }
        }
    }

    public static void afterInsertHandler(List<Lead> newRecords) {
            // look that is bulkfied
            List<Task> taskList = new List<Task>(); 
            for(Lead leadRecord : newRecords) {
                Task leadTask = new Task(Subject='Follow up on Lead Status', WhoId = leadRecord.Id);
                taskList.add(leadTask);
            }	
            insert taskList;

            // THIS LINES BELLOWS WILL CAUSE A RECURSIVE PROBLEM
            if(LeadTriggerHandler.alreadyExecuted == false) {

                LeadTriggerHandler.alreadyExecuted = true;
                
                Lead anotherLead = new Lead(LastName = 'Test Lead Single', Status = 'Open - Not Contacted', Company = 'FDCFacts', Industry = 'Finance');
                insert anotherLead;
            }
    }

    public static void beforeUpdatetHandler(List<Lead> newRecords, Map<Id, Lead> oldRecordsMap) {
        for(Lead leadRecord : newRecords) {
            // if the leadSource is blank, then make it "other"
            if(String.isBlank(leadRecord.LeadSource)) {
                leadRecord.LeadSource = 'Other'; 
            }
            
            if(
                (leadRecord.Status == 'Closed - Converted' || leadRecord.Status == 'Closed - Not Converted')
                && oldRecordsMap.get(leadRecord.Id).Status == 'Open - Not Contacted'
            ) {
                leadRecord.addError('You cannot directly close an open lead record');
            }
        }
    }

    public static void afterUpdatetHandler(List<Lead> newRecords) {

    }
}