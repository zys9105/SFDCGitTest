public with sharing class Line_Item {
	
	public list<Line_Item__c> Line_Item {get; set;}

    public Line_Item__c mapping_rec_Line_Item {get; set;}
   	
    public Line_Item(){
        
    }
    // Inituate the page
    public void Init(){
    	Line_Item = [select id, Asset_Category__c, Quantity__c,Total_Price__c,Unit_Price__c
        from Line_Item__c];
        
        if(Line_Item != null && !Line_Item.IsEmpty() && Line_Item.size() >0){
            mapping_rec_Line_Item = Line_Item[0];
        }else{
            mapping_rec_Line_Item = new Line_Item__c();
        }    
    }    
   
	// the save button to save the data
    public PageReference save(){
    	if(IsEmptyFieldExists()){
    		return null;
    	}   
    	 // update the data
    	 upsert mapping_rec_Line_Item;
    	 Line_Item = [select id, Asset_Category__c, Quantity__c,Total_Price__c,Unit_Price__c
    	 from Line_Item__c
         where id= :mapping_rec_Line_Item.id];
         mapping_rec_Line_Item = Line_Item[0];
     	
     	//redirect the current page
		//PageReference pageRef = ApexPages.currentPage();
    	//pageRef.setRedirect(true);
    	//return pageRef
        return null;
    }
   
   // New a record
    public void newRecord(){
        mapping_rec_Line_Item = new Line_Item__c();        
    }
    
    public void test(){
        wbservice.GetListOfYears();
    }
    // check the Mandatory field
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