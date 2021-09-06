public with sharing class FileService {
    public FileService() {

    }

    public static void saveAsJson(Airplane__c airplane) {
        saveAsJson(new List<Airplane__c>{airplane});
    }
    public static void saveAsJson(List<Airplane__c> airplanesTosave) {
        List<ContentVersion> contentVersionToAdd = new List<ContentVersion>();
        List<ContentDocumentLink> contentDocumentLinkToAdd = new List<ContentDocumentLink>();
        Map<Id,Id> airIdToContentId = new Map<Id,Id>();
        
        
        for (Airplane__c airplane : airplanesToSave) {  
            if (airplane.Current_Location__Latitude__s == null || airplane.Current_Location__Longitude__s == null) {
                continue;
            }

            String fileContent = '[' + getJsonLocationContent(airplane) + ']';
            String fileName = airplane.ICAO24__c;
            
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.isMajorVersion = false;
            contentVersion.ContentLocation = 'S'; 
            contentVersion.PathOnClient = fileName + '.json';
            contentVersion.Title = fileName; 
            contentVersion.VersionData = Blob.valueOf(fileContent);
            insert contentVersion;
            
            Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.Id].ContentDocumentId;
        
            ContentDocumentLink documentLink = New ContentDocumentLink();
        
            documentLink.LinkedEntityId = airplane.Id; 
            documentLink.ContentDocumentId = contentDocumentId;  
            documentLink.shareType = 'V';
            insert DocumentLink;
        }
        
    }

    private static String getJsonLocationContent(Airplane__c airplane) {
        
            Map<String, Double> currentLocation = new Map<String, Double>();
            currentLocation.put('Longitude', airplane.Current_Location__Longitude__s);
            currentLocation.put('Latitude', airplane.Current_Location__Latitude__s);
            return JSON.serialize(currentLocation, true);

    }

    
    public static void updateLocations(Airplane__c airplane) {
        
        ContentVersion contentVersion = getContentVersion(airplane);
        String newContentData = contentVersion.VersionData.toString().substringBeforeLast(']') + ',' + getJsonLocationContent(airplane) + ']';
        contentVersion.VersionData = Blob.valueOf(newContentData);
        update contentVersion;
    }

    public static ContentVersion getContentVersion(Airplane__c airplane) {

        ContentDocumentLink conDocLink = [SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :airplane.Id];
        ContentVersion contentVersion = [   
                                            SELECT  Id, 
                                                    Title, 
                                                    VersionData, 
                                                    PathOnClient,
                                                    isMajorVersion 
                                            FROM ContentVersion 
                                            WHERE ContentDocumentId = :conDocLink.ContentdocumentId
                                        ];
        return contentVersion;
    }

    public static ContentVersion getContentVersionByTitle(String title) {
        ContentVersion contentVersion = [   
                                            SELECT  Id, 
                                                    Title, 
                                                    VersionData, 
                                                    PathOnClient,
                                                    isMajorVersion 
                                            FROM ContentVersion 
                                            WHERE Title = :title
                                        ];
        return contentVersion;
    }
}
