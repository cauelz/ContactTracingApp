trigger ContactTrigger on Contact (before insert, after insert, before update, after update, after delete, after undelete) {

    switch on Trigger.operationType {
        when AFTER_INSERT {
            ContactTriggerHandler.afterInsertHandler(Trigger.new);
        }
        when AFTER_UPDATE {
        }
        when AFTER_DELETE {
        }
        when AFTER_UNDELETE {
        }
    }
}