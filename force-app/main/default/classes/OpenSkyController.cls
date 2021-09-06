public with sharing class OpenSkyController {
    public OpenSkyController() {

    }
    @AuraEnabled(Cacheable = true)
    public static List<Airplane__c> getAllStates(){
        
        List<Airplane__c> airplaneList = [SELECT  Id, 
                                            Callsign__c, 
                                            Current_Location__Longitude__s,
                                            Current_Location__Latitude__s
                                    FROM Airplane__c];
        
        
        return airplaneList;
        
    }

    @AuraEnabled(Cacheable = true)
    public static String getTimestamp(){
        Airplane__c airplane;
        DateTime result;
        try {
            airplane = [select Id, Timestamp__c FROM Airplane__c LIMIT 1];
            result = airplane.Timestamp__c;
        } catch (Exception e) {
            result = DateTime.now();
        }
        return result.format('yyyy-MM-dd hh:mm:ss');
    }

    public static void refresh() {

    }

    @AuraEnabled(Cacheable = true)
    public static List<String> getCountries() {
        Set<String> countries = new Set<String>();
        for (Airplane__c airplane : [SELECT Origin_Country__c FROM Airplane__c]) {
            countries.add(airplane.Origin_Country__c);
        }
        return new List<String>(countries);

    }

    @AuraEnabled(Cacheable = true)
    public static List<Airplane__c> getStatesByCountry(String country){
        if (country.equals('')) {
            return getAllStates();
        }
        List<Airplane__c> result = new List<Airplane__c>();
        try {
            result =  [ SELECT  Id, 
                                Callsign__c, 
                                Current_Location__Longitude__s,
                                Current_Location__Latitude__s
                        FROM Airplane__c
                        WHERE Origin_Country__c = :country];
        } catch (Exception e) {
            System.debug(e);
        }
        System.debug(result);
        return result;
    }

    @AuraEnabled
    public static void updateData() {
        List<Airplane__c> airToDelete = [SELECT Id FROM Airplane__c];
        delete airToDelete;
        Id jobId = System.enqueueJob(new OpenSkyCalloutService());
        
        
    }

    @AuraEnabled
    public static String followTheAirplane(Id recordId){
        Airplane__c airplane = [SELECT Id, ICAO24__c, Current_Location__Longitude__s, Current_Location__Latitude__s FROM Airplane__c WHERE Id = :recordId];
        String jobID;
        try {
            DateTime nowDateTime = DateTime.now();
            System.debug(nowDateTime.format('yyyy-MM-dd hh:mm:ss'));
            String cronExp1 = '0 ' + nowdateTime.minute() + ' * * * ?'; //each hour
            String cronExp2 = '0 ' + (nowdateTime.minute() + 15) + ' * * * ?';
            String cronExp3 = '0 ' + (nowdateTime.minute() + 30) + ' * * * ?';
            String cronExp4 = '0 ' + (nowdateTime.minute() + 45) + ' * * * ?';
            //String CRON_EXPRESSION = '0 ' + nowdateTime.minute() + '/5 ' + nowDateTime.hour() + ' ' + nowDateTime.day() + ' ' + nowDateTime.month() + ' ? ' + nowdateTime.year();
            //system.debug(CRON_EXPRESSION);
            jobID = System.schedule('Airplane Reporting1', cronExp1, new SheduledOpenSkyCalloutService(airplane.ICAO24__c));
            jobID = System.schedule('Airplane Reporting2', cronExp2, new SheduledOpenSkyCalloutService(airplane.ICAO24__c));
            jobID = System.schedule('Airplane Reporting3', cronExp3, new SheduledOpenSkyCalloutService(airplane.ICAO24__c));
            jobID = System.schedule('Airplane Reporting4', cronExp4, new SheduledOpenSkyCalloutService(airplane.ICAO24__c));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return jobId;
    }

    private List<Integer> getMinutes(Integer minute) {
        if (minute)
    }

}
