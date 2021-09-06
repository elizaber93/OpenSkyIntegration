public with sharing class OpenSkyCalloutService implements Queueable,  Database.AllowsCallouts{

    private static final String OPEN_SKY_ALL_URL = 'https://opensky-network.org/api/states/all';
    private static final String OPEN_SKY_ICAO_URL = 'https://opensky-network.org/api/states/all?icao24=';
    private Integer recordNumber = 100;
    private String url;

    public OpenSkyCalloutService() {
        this.url = OPEN_SKY_ALL_URL;
    }

    public OpenSkyCalloutService(String icao) {
        this.url = OPEN_SKY_ICAO_URL+icao;
    }


    public  HTTPResponse getData() {
        Integer retryCount = 5;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(this.url);
        request.setMethod('GET');
        request.setTimeOut(60000);
        HttpResponse response = null;
        Integer n = 0;
        while (n <= retryCount) {
            try {
                response = http.send(request);  
            } catch (System.CalloutException e) {
                System.debug('Try number = ' + n + '. ' + e.getMessage());
                //throw new CalloutException(e.getMessage(), e);
            }
            if (response != null) {
                break;
            } else {
                n++;
            }
        }
        return response;
    }

    public  Map<String, Airplane__c> getAirplanesFromJson(String jsonData) {
        Map<String, Airplane__c> icaoToAirplaneMap = new Map<String, Airplane__c>();
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(jsonData);
        Long timestamp = (Long) jsonMap.get('time');
        List<Object> statesFromJson = (List<Object>) jsonMap.get('states');
        for (Object state : statesFromJson) {
            List<Object> properties = (List<Object>)state;
            Airplane__c airplaneToAdd = new Airplane__c();
            if (properties.get(5) != null && properties.get(6) != null) {
                airplaneToAdd.Current_Location__Longitude__s = Double.valueOf(properties.get(5));
                airplaneToAdd.Current_Location__Latitude__s = Double.valueOf(properties.get(6));
            } else {
                continue;
            }
            airplaneToAdd.Timestamp__c = DateTime.newInstance(timestamp);
            airplaneToAdd.ICAO24__c = String.valueOf(properties.get(0));
            if (properties.get(1) != null) {
                airplaneToAdd.Callsign__c = String.valueOf(properties.get(1));
            }
            airplaneToAdd.Origin_Country__c = String.valueOf(properties.get(2));
            if (properties.get(3) != null) {
                airplaneToAdd.Time_Position__c = Integer.valueOf(properties.get(3));
            }
            airplaneToAdd.Last_Contact__c = Integer.valueOf(properties.get(4));
            if (properties.get(5) != null && properties.get(6) != null) {
                airplaneToAdd.Current_Location__Longitude__s = Double.valueOf(properties.get(5));
                airplaneToAdd.Current_Location__Latitude__s = Double.valueOf(properties.get(6));
            }
            airplaneToAdd.On_Ground__c = Boolean.valueOf(properties.get(8));
            if (properties.get(14) != null) {
                airplaneToAdd.Squawk__c = String.valueOf(properties.get(14));
            }
            airplaneToAdd.SPI__c = Boolean.valueOf(properties.get(15));
            icaoToAirplaneMap.put(airplaneToAdd.ICAO24__c, airplaneToAdd);

        }
        return icaoToAirplaneMap;
    }

    public void execute(QueueableContext context) {
        
        try {
            List<Airplane__c> airToInsert = getAirplaneListToInsert(getData().getBody());
            insert airToInsert;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
    }

    

    public  List<Airplane__c> getAirplaneListToInsert(String jsonBody) {
        Map<String, Airplane__c> icaoToAirplaneMap = getAirplanesFromJson(jsonBody);
        List<Airplane__c> resultList = new List<Airplane__c>();
        for (Airplane__c airplane : icaoToAirplaneMap.values()) {
            resultList.add(airplane);
            if (resultList.size() == recordNumber) {
                break;
            }
        }
        return resultList;
    }

    
}
