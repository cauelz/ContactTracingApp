<<<<<<< HEAD
trigger ContactTrigger on Contact (before insert, after insert, before update, after update, after delete, after undelete) {
=======
trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {
>>>>>>> 6a4484d0981f54e7422bffe116c2136553ca0468

    switch on Trigger.operationType {
        when AFTER_INSERT {
            ContactTriggerHandler.afterInsertHandler(Trigger.new);
        }
<<<<<<< HEAD
        when AFTER_UPDATE {
        }
        when AFTER_DELETE {
        }
        when AFTER_UNDELETE {
=======

        when AFTER_UPDATE {
            ContactTriggerHandler.afterUpdateHandler(Trigger.new, Trigger.oldMap);
        }

        when AFTER_DELETE {
            ContactTriggerHandler.afterDeleteHandler(Trigger.old);
        }

        when AFTER_UNDELETE {

            ContactTriggerHandler.afterDeleteHandler(Trigger.new);
>>>>>>> 6a4484d0981f54e7422bffe116c2136553ca0468
        }
    }
}