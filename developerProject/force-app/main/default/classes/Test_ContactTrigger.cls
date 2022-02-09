@isTest
public with sharing class Test_ContactTrigger {
    public static testMethod void MyUnitTest() {
 		    Account acc = new Account(name = 'testaccount',BillingStreet = '1 test st',BillingCity = 'TestCity',
                                     BillingState = 'testState', BillingPostalCode = '1234',
                                      BillingCountry = 'TestCountry');
			insert acc;
            Contact con = new Contact(AccountId = acc.id,lastname = 'testdata');
			insert con;
            delete con;
        	undelete con;
        
    }

}