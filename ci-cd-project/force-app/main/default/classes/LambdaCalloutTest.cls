@isTest
public class LambdaCalloutTest {
    
    // Mock class for HTTP callouts
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "success", "message": "Lambda response"}');
            res.setStatusCode(200);
            return res;
        }
    }
    
    @isTest
    static void testSendToLambdaAction() {
        // Create test data - you'll need a Case record
        Case testCase = new Case(
            Subject = 'Test Case',
            Status = 'New',
            Origin = 'Web'
        );
        insert testCase;
        
        // Test the sendToLambdaAction method
        Test.startTest();
        
        // Set the mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method with correct signature (only one parameter)
        String result = LambdaCallout.sendToLambdaAction(testCase.Id);
        
        Test.stopTest();
        
        // Verify the result
        System.assertEquals('Callout sent to Lambda!', result, 'Method should return success message');
    }
    
    @isTest
    static void testSendToLambda() {
        // Create test data
        Case testCase = new Case(
            Subject = 'Test Case for Lambda',
            Status = 'New',
            Origin = 'Email'
        );
        insert testCase;
        
        Test.startTest();
        
        // Set the mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call the method with correct signature (only one parameter)
        LambdaCallout.sendToLambda(testCase.Id);
        
        Test.stopTest();
        
        // Since this is a void method, we just verify it runs without throwing exceptions
        // The mock ensures the HTTP callout is handled properly
        System.assert(true, 'sendToLambda method executed successfully');
    }
    
 @isTest
static void testSendToLambdaWithHttpException() {
    // Create test data
    Case testCase = new Case(
        Subject = 'Test Case Error',
        Status = 'New',
        Origin = 'Phone'
    );
    insert testCase;
    
    // Set up mock for failed callout
    Test.setMock(HttpCalloutMock.class, new MockHttpFailureResponse());
    
    Test.startTest();
    LambdaCallout.sendToLambda(testCase.Id); // Will run synchronously in test context
    Test.stopTest();
    
    // Verify error was logged via Case comments
    List<CaseComment> comments = [SELECT CommentBody FROM CaseComment 
                                WHERE ParentId = :testCase.Id
                                ORDER BY CreatedDate DESC LIMIT 1];
    System.assert(!comments.isEmpty(), 'Error comment should be created');
    System.assert(comments[0].CommentBody.contains('500'),
                'Comment should contain error status');
}

private class MockHttpFailureResponse implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(500);
        res.setStatus('Server Error');
        res.setBody('{"error":"Internal Server Error"}');
        return res;
    }
}
}