public with sharing class OpenSkyCalloutServiceMock implements HttpCalloutMock{
    // implement http mock callout
    public HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://opensky-network.org/api/states/all', req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"time":1629116019,"states":[["a6fe0f","N55LC   ","United States",null,1629116018,null,null,null,false,246.56,245.47,0,null,null,null,false,0],["ac494e","CMD3    ","United States",1629116019,1629116019,-121.3223,38.9196,937.26,false,60.77,28.3,0,null,914.4,"4263",false,0]]}');
        res.setStatusCode(200);
        return res;
    }
}