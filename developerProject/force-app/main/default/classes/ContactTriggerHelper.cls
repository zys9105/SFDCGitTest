/**
 * File Name: ContactTriggerHelper
 * Description Contains the funtions called by ContactTrigger
 * @author  Jack
 * @version 1.0
 * @since   2017-02-01 
 */
public with sharing class ContactTriggerHelper {
    public static list<Account>                 Accounts;
    public static Set<ID>                       AccountIds;
    //Incease the contact number in Account
    public static void ContactNumberincrease(list<Contact> Contacts){
           AccountIds = new Set<ID>();
        for(Contact con: Contacts){
            if(con.AccountId!=null)
                AccountIds.add(con.AccountId);
        }
        Accounts = [select Contact_Number__c from Account where Id in: AccountIds];
        for(Contact con: Contacts)
            for(Account acc: Accounts)
                if(con.AccountId.equals(acc.Id)){
                    system.debug('con.AccountId:'+con.AccountId+'\n  con.Account.Id:'+con.Account.Id+
                        '\n acc.Contact_Number__c:'+acc.Contact_Number__c+'\n  con.Account.Contact_Number__c:'
                        +con.Account);
                    acc.Contact_Number__c++;
                    break;
                }
        upsert Accounts;
    }
    
    // Decrease the contact number in Account
    public static void ContactNumberdecrease(list<Contact> Contacts){
        AccountIds = new Set<ID>();
        for(Contact con: Contacts){
            if(con.AccountId!=null)
                AccountIds.add(con.AccountId);
        }
        Accounts = [select Contact_Number__c from Account where Id in: AccountIds];
        for(Contact con: Contacts)
            for(Account acc: Accounts)
                if(con.AccountId.equals(acc.Id)){
                    acc.Contact_Number__c--;
                    break;
                }
        upsert Accounts;
    }
    
    //Inherite the Account Billing Address
    public static void InheritanceAddress(list<Contact> Contacts){
        Accountids = new Set<Id>();
        for(Contact con: Contacts){
            AccountIds.add(con.AccountId);
        }
        Accounts = [select BillingStreet,BillingCity,
                           BillingState,BillingPostalCode,BillingCountry
                           from Account where Id in: AccountIds];
        for(Contact con: Contacts){
            for(Account acc: Accounts){
                if(con.AccountId.equals(acc.Id)){
                    con.MailingStreet 		= acc.BillingStreet;
                    con.MailingCity 		= acc.BillingCity; 
                    con.MailingState		= acc.BillingState; 
                    con.MailingPostalCode	= acc.BillingPostalCode;
                    con.MailingCountry		= acc.BillingCountry;
                }
            }
        }    
    }
}