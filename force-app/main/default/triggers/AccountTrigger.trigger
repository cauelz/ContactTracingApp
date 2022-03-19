trigger AccountTrigger on Account (before insert, after insert, before update, after update) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
        }
        when AFTER_INSERT {
        }
        when BEFORE_UPDATE {
        }
    }
}