/**
 * File Name: AccountTriggerHelper
 * Description: Contains funtions called by AccountTrigger
 * @author  Jack
 * @version 1.0
 * @since   2017-02-01
 */
public with sharing class AccountTriggerHelper {
  public static list<Contact>               Contacts;
  public static set<id>                     AccountIds;
  
  // if Account is updated, update contact MailingAddress.
  public static void UpdateContactMailingAddress(list<Account> Accounts) {
    AccountIds  = new set<ID>();
    Contacts    = new list<Contact>();
    for (Account acc : Accounts) {
      AccountIds.add(acc.id);
    }
    Contacts = [SELECT Account.BillingStreet,Account.BillingCity,Account.BillingState,
                Account.BillingPostalCode,Account.BillingCountry,MailingStreet, 
                MailingCity,MailingState, MailingPostalCode, MailingCountry
                          FROM Contact WHERE AccountId in: AccountIds];

    for (Contact con : Contacts) {
      con.MailingStreet     = con.Account.BillingStreet;
      con.MailingCity       = con.Account.BillingCity;
      con.MailingState      = con.Account.BillingState;
      con.MailingPostalCode = con.Account.BillingPostalCode;
      con.MailingCountry    = con.Account.BillingCountry;
    }
    if(Contacts!= null &&Contacts.size()>0)
        upsert Contacts;
  }
}