public with sharing class ApplicationProcess {
	
	public list<Application__c> Application {get; set;}
	public list<Application_Applicant__c> Application_Applicant {get; set;}
	public list<Line_Item__c> Line_Item {get; set;}

    public Application_Applicant__c mapping_rec {get; set;}
	public Application__c mapping_rec_Application {get; set;}
	public Line_Item__c mapping_rec_Line_Item {get; set;}
    public Email__c mapping_rec_Email {get; set;}
	
    public Boolean bApplication{get;set;}
    public Boolean bApplication_Applicant{get;set;}
    public Boolean bLine_Item{get;set;}    
        // value
    public double i =0;

    
    public ApplicationProcess(){
    	bApplication= true;
    	bApplication_Applicant=false;
    	bLine_Item=false;        
    }
  
    public void Init(){    	
        Application = [select id,Application_Number__c, Asset_type__c, Comments__c, 
                       Company_Name__c,Contract_Amount__c,Customer_type__c,Frequency__c,
                       No_Of_Payments__c,Status__c,Total_Amount__c,GST__c ,Total_Amount_and_GST__c
                       from Application__c];
        
        if(Application != null && !Application.IsEmpty() && Application.size() >0){
            mapping_rec_Application = Application[0];
        }else{
            mapping_rec_Application = new Application__c();
            mapping_rec_Application.GST__c = Custom_Setting.getGST();
        }
        mapping_rec = new Application_Applicant__c();
        mapping_rec_Line_Item = new Line_Item__c();
        mapping_rec_Email = new Email__c();
    }
    public PageReference save(){
        if(IsEmptyFieldExists()){
            return null;
    	}
        upsert mapping_rec_Application;
        return null;
    }
   
    public PageReference save_new(){
    	if(IsEmptyFieldExists()){
    		return null;
    	}
        upsert mapping_rec_Application;
        mapping_rec.Application__c=mapping_rec_Application.Id;	
        upsert mapping_rec;
        mapping_rec_Line_Item.Application__c= mapping_rec_Application.Id;	
        upsert mapping_rec_Line_Item;
        newRecord();
        i=0;
        switch_page();
        return null;
    }
  
    public PageReference next(){
    	i++;
        switch_page();
        return null;
    }
  
    public PageReference previous(){
    	i--;
        switch_page();
        return null;
    }
  
    public void switch_page(){
        system.debug('abbbbbbbbbbbb');
        if (i ==0){
            bApplication= true;
            bApplication_Applicant= false;
            bLine_Item= false;        
            
        }else if (i ==1){
            bApplication= false;
            bApplication_Applicant= true;
            bLine_Item= false;
    	}else if(2==i){
    		bApplication= false;
    		bApplication_Applicant= false;
    		bLine_Item= true;
    	}
    }
    
    public void newRecord(){   
        mapping_rec_Application = new Application__c();
        mapping_rec = new Application_Applicant__c();
        mapping_rec_Line_Item = new Line_Item__c();
        mapping_rec_Application.GST__c = Custom_Setting.getGST();
        }
        
    public void sent_email(){   
		EmailManager em = new EmailManager();
    // Reference the attachment page and pass in the account ID
    PageReference pdf = Page.attachmentPDF;
    pdf.getParameters().put('id',(String)ApexPages.currentPage().getParameters().get('id'));
    pdf.setRedirect(true);
    // Take the PDF content
    Blob b = pdf.getContent();
    // Create the email attachment
    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
    efa.setFileName('attachment.pdf');
    efa.setBody(b);
		em.sendMail(mapping_rec_Email.Email_Address__c, mapping_rec_Email.Email_Object__c, mapping_rec_Email.Email_Body__c,efa);
        system.debug('aaaaaaaaaaaaa '+mapping_rec_Email.Email_Address__c);
        }     
    
    public boolean IsEmptyFieldExists(){
        boolean IsEmpty = false;  
		if(mapping_rec_Line_Item != null && 
		0 == mapping_rec_Line_Item.Quantity__c){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
			GlobalConstant.INCOMPLETE));
			IsEmpty = true;
		}
		return  IsEmpty;
	}    
    
}