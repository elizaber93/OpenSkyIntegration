public with sharing class SheduledOpenSkyCalloutService implements Schedulable{
    
    private String icao;

    public SheduledOpenSkyCalloutService() {
    }

    public SheduledOpenSkyCalloutService(String icao) {
        this.icao = icao;
    }

    public void execute(SchedulableContext context) {
        if (icao != null) {
            System.enqueueJob(new OpenSkyCalloutService(this.icao));
        } else {
            System.enqueueJob(new OpenSkyCalloutService());
        }
        
    }

}
