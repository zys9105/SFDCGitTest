public with sharing class LoanDetails {
	
	public list<Loan_Details__c> Loan_Details {get; set;}
   
    public Loan_Details__c mapping_rec {get; set;}
   
    public LoanDetails(){
        
    }
    public void Init(){
        
        Loan_Details = [select id, Address__c, Applicant_Name__c, Drivers_Licence_Number__c from Loan_Details__c];
        
        if(Loan_Details != null && !Loan_Details.IsEmpty() && Loan_Details.size() >0){
        
            mapping_rec = Loan_Details[0];
        }else{
            mapping_rec = new Loan_Details__c();
        }    
    }    
   
    public void save(){
        
        upsert mapping_rec;
        
    }
   
    public void newRecord(){
        
        mapping_rec = new Loan_Details__c();
        
    }
    
}