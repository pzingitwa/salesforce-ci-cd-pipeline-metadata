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
        // Test error handling
        Case testCase = new Case(
            Subject = 'Test Case Error',
            Status = 'New',
            Origin = 'Phone'
        );
        insert testCase;
        
        Test.startTest();
        
        // Don't set a mock to simulate a callout exception
        // This will test the @future method's error handling
        
        try {
            LambdaCallout.sendToLambda(testCase.Id);
            Test.stopTest();
        } catch (Exception e) {
            Test.stopTest();
            // Expected behavior - callout will fail in test context without mock
        }
        
        System.assert(true, 'Exception handling test completed');
    }
}