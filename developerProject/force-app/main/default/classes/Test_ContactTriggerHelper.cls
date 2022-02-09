@isTest
public with sharing class Test_ContactTriggerHelper {
    
    public static testMethod void MyUnitTest() { // for ContactNumberUpdate
        Account acc = new Account(name = 'testaccount',BillingStreet = '1 test st',BillingCity = 'TestCity',
                                     BillingState = 'testState', BillingPostalCode = '1234',
                                      BillingCountry = 'TestCountry');
		upsert acc;
        Contact con = new Contact(AccountId = acc.id,lastname = 'testdata');
		list<Contact> cons = new list<Contact>();
        upsert cons;
        cons.add(con);
		ContactTriggerHelper.ContactNumberincrease(cons); 
        ContactTriggerHelper.ContactNumberdecrease(cons); 
		ContactTriggerHelper.InheritanceAddress(cons); 

      
    }

}