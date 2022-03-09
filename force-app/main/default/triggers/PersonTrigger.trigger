trigger PersonTrigger on Person__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

    switch on Trigger.operationType {

        when BEFORE_INSERT {
            PersonTriggerHandler.beforeInsert(Trigger.new);
        }
        when AFTER_INSERT {

        }
        when BEFORE_UPDATE {
            PersonTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            PersonTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        when BEFORE_DELETE {

        }
        when AFTER_DELETE {

        }
        when AFTER_UNDELETE {

        }

    }
}