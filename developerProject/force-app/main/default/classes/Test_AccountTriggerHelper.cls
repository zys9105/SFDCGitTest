@isTest
public with sharing class Test_AccountTriggerHelper {
    public static testMethod void testUpdateContactMailingAddress() {
        list<Account> Accounts = new list<Account>();
        list<Contact> Contacts = new list<Contact>();
        for (integer i=0;i<200;i++){
 		    Account acc = new Account(name = 'testaccount',BillingStreet = '1 test st',BillingCity = 'TestCity',
                                     BillingState = 'testState', BillingPostalCode = '1234',
                                      BillingCountry = 'TestCountry');
			Accounts.add(acc);
            
        }
        system.debug('Account:'+Accounts+' \n Contacts:'+ Contacts);
        upsert Accounts;
        
        for(Account acc: Accounts){
            Contact con = new Contact(AccountId = acc.id,lastname = 'testdata');
			Contacts.add(con);
            acc.BillingStreet = '5 test st';
        }
        upsert Contacts;
        upsert Accounts;
            
            
        system.debug('accounts list'+ Accounts);
        	AccountTriggerHelper.UpdateContactMailingAddress(Accounts);  
    }
}