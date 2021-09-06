public with sharing class EmailService {
    public EmailService() {

    }

    public static void sendAirplaneReport(Airplane__c airplane, String email)
    {
        String subject = 'Information about Airplane '+airplane.ICAO24__c;
        String body = 'Track of Airplane ' + airplane.ICAO24__c + ' in JSON format.';
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE Name = 'OpenSky Report Template'];
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();    
        message.setTemplateId(template.Id);
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        ContentVersion contentVersion = FileService.getContentVersion(airplane);
        Blob fileBody = contentVersion.VersionData;
        attachment.setFileName(contentVersion.PathOnClient);
        attachment.setBody(fileBody); 

        message.setSubject(subject);
        message.setToAddresses(new List<String>{email});
        message.setPlainTextBody(body);
        message.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});
 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});   
    }

    public static void sendReportEmail(Contact destination, Airplane__c airplane, String templateName) {
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE Name = :templateName];    
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        ContentVersion contentVersion = FileService.getContentVersion(airplane);
        Blob fileBody = contentVersion.VersionData;
        attachment.setFileName(contentVersion.PathOnClient);
        attachment.setBody(fileBody); 
        
        message.setTemplateId(template.Id);
        message.setTargetObjectId(destination.Id);
        message.setWhatId(airplane.Id);
        message.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment});

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});   
    }

}
