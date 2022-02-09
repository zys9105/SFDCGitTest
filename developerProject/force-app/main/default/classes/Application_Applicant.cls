public with sharing class Application_Applicant {
	
	public list<Application_Applicant__c> Application_Applicant {get; set;}
//  	public list<Application_Applicant__c> Application_Applicant {get; set;}

   
    public Application_Applicant__c mapping_rec {get; set;}
    //   	public Application_Applicant__c mapping_rec_Applicant {get; set;}
   	
    public Application_Applicant(){
        
    }
    
    public void Init(){
    	
        
        Application_Applicant = [select id,ABN__c, Business_Name__c, Business_Type__c, 
                                 Business_Address_Street__c,Business_Address_State__c,
                                 Business_Address_PostCode__c,Business_Address_City__c, 
                                 Primary_Applicant__c,Years_in_Business__c,Application__c
                                 from Application_Applicant__c];
        
        if(Application_Applicant != null && !Application_Applicant.IsEmpty() && Application_Applicant.size() >0){
        
            mapping_rec = Application_Applicant[0];
        }else{
            mapping_rec = new Application_Applicant__c();
        }    
    }    
   
    public void save(){
        
        upsert mapping_rec;
        
    }
   
    public void newRecord(){
        
        mapping_rec = new Application_Applicant__c();
        
    }
    
}