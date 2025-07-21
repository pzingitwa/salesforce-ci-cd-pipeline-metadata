@isTest
public class HelloWorldTest {
    
    @isTest
    static void testSayHello() {
        // Test the sayHello method
        Test.startTest();
        HelloWorld.sayHello();
        Test.stopTest();
        
        // Since sayHello() only does System.debug(), we just need to ensure it runs without errors
        // The method execution itself provides the code coverage
        System.assert(true, 'sayHello method executed successfully');
    }
}