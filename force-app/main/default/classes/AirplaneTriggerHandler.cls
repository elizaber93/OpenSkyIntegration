public with sharing class AirplaneTriggerHandler extends TriggerHandler {
    
    public override void beforeInsert() {
        for(Airplane__c airplane : (List<Airplane__c>) Trigger.new) {
          if (airplane.Timestamp__c != null) {
            Long timestamp = 1000L * (Long) airplane.Timestamp__c.getTime();
            airplane.Timestamp__c = datetime.newInstance(timestamp);
          }
          if (airplane.Last_Contact__c != null) { 
            Long lastContactTimestamp = 1000L * (Long) airplane.Last_Contact__c;
            airplane.Last_Contact__c = lastContactTimestamp;
          }
          if (airplane.Time_Position__c != null) {
            Long timePositionTimestamp = 1000L * (Long) airplane.Time_Position__c;
            airplane.Time_Position__c = timePositionTimestamp;
          }
        }
      }

      public override void beforeUpdate() {
        for(Airplane__c airplane : (List<Airplane__c>) Trigger.new) {
          if (airplane.Timestamp__c != null && String.valueOf(airplane.Timestamp__c).length() < 13) {
            Long timestamp = 1000L * (Long) airplane.Timestamp__c.getTime();
            airplane.Timestamp__c = datetime.newInstance(timestamp);
          }  
          if (airplane.Last_Contact__c != null && String.valueOf(airplane.Last_Contact__c).length() < 13) {
              Long lastContactTimestamp = 1000L * (Long) airplane.Last_Contact__c;
              airplane.Last_Contact__c = lastContactTimestamp;
            }
            if (airplane.Time_Position__c != null && String.valueOf(airplane.Time_Position__c).length() < 13) {
              Long timePositionTimestamp = 1000L * (Long) airplane.Time_Position__c;
              airplane.Time_Position__c = timePositionTimestamp;
            }
        }
      }

}
