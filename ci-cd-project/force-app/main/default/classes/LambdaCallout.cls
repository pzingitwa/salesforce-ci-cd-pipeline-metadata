public with sharing class LambdaCallout {
    @AuraEnabled
    public static String sendToLambdaAction(Id recordId) {
        try {
            sendToLambda(recordId);
            return 'Callout sent to Lambda!';
        } catch(Exception e) {
            createErrorComment(recordId, 'Initial error: ' + e.getMessage());
            throw new AuraHandledException('Failed to send to Lambda: ' + e.getMessage());
        }
    }
    
    @future(callout=true)
    public static void sendToLambda(Id caseId) {
        try {
            Case c = [SELECT Id, Subject FROM Case WHERE Id = :caseId LIMIT 1];
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:LambdaAPI/salesforce');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('x-api-key', '{!$Credential.Password}'); // Best practice for named credentials
            
            Map<String, Object> payload = new Map<String, Object>{
                'recordId' => c.Id,
                'subject' => c.Subject
            };
            req.setBody(JSON.serialize(payload));
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            if (res.getStatusCode() != 200) {
                createErrorComment(caseId, 
                    'Lambda returned status: ' + res.getStatusCode() + 
                    '\nResponse: ' + res.getBody());
            }
        } catch(Exception e) {
            createErrorComment(caseId, 
                'Lambda callout failed: ' + e.getMessage() + 
                '\nStack Trace: ' + e.getStackTraceString());
            // Future methods can't throw exceptions, so we log them
        }
    }
    
    private static void createErrorComment(Id caseId, String message) {
        try {
            insert new CaseComment(
                ParentId = caseId,
                CommentBody = 'Lambda Error: ' + message.left(32000) // Field length limit
            );
        } catch(Exception e) {
            System.debug('Failed to create error comment: ' + e.getMessage());
        }
    }
}