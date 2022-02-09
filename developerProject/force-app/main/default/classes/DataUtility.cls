public with sharing class DataUtility {
    
    public static list<Contact> getContacts(String AccountId){
        
        list<Contact> contacts = new list<Contact>();
        if(null != AccountId && !String.isEmpty(AccountId)){
            list<Contact> temp = [select Name from Contact where Account.id =: AccountId];
            if(temp != null && temp.size()>0)
                contacts.addAll(temp);
        }
        return contacts;
       
    }
	
}