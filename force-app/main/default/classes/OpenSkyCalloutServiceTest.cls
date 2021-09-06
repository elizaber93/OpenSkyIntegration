@isTest
public with sharing class OpenSkyCalloutServiceTest {
    
    @isTest
    public static void OpenSkyCalloutTest() {
        Test.setMock(HttpCalloutMock.class, new OpenSkyCalloutServiceMock());
        Test.startTest();
        System.enqueueJob(new OpenSkyCalloutService());
        Test.stopTest();
    }
}
