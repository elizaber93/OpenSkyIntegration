trigger AirplaneTrigger on Airplane__c (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
        new AirplaneTriggerHandler().run();
}