public with sharing class UpsertAirplanesBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    private List<Airplane__c> airplanes = new List<Airplane__c>();

    public UpsertAirplanesBatch() {

    }

    public UpsertAirplanesBatch(List<Airplane__c> airplanes) {

    }

    public List<Airplane__c> getAirplanes() {
        return this.airplanes;
    }

    public void setAirplanes(List<Airplane__c> airplanes) {
        this.airplanes = airplanes;
    }

    public Iterable<sObject> start(Database.BatchableContext bc) {
        return this.airplanes;
    }

    public void execute(Database.BatchableContext bc, List<Airplane__c> airplanes) {
        upsert airplanes;
    }

    public void finish(Database.BatchableContext bc) {
    }

}
