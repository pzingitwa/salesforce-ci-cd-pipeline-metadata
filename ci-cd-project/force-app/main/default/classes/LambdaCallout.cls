public with sharing class LambdaCallout {
     @AuraEnabled
    public static String sendToLambdaAction(Id recordId) {
        sendToLambda(recordId); // calls the future method
        return 'Callout sent to Lambda!';
    }
    
    @future(callout=true)
    public static void sendToLambda(Id caseId) {
        Case c = [SELECT Id, Subject FROM Case WHERE Id = :caseId LIMIT 1];

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:LambdaAPI/salesforce'); // LambdaAPI is Named Credential
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('x-api-key', 'YOUR_API_KEY'); // replace with real key

        Map<String, Object> payload = new Map<String, Object>{
            'recordId' => c.Id,
            'subject' => c.Subject
        };

        req.setBody(JSON.serialize(payload));

        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('Lambda response: ' + res.getBody());
    }

   
}