public with sharing class MapFieldSetController {
    // current all SObject label and Api
    public List<SelectOption> objectOptions {get;set;}
    // the field options after selection of SObject
    public List<List<SelectOption>> fieldOptionsList {get;set;}
    
    // Saved Mapping fields Table
    public list<replacedMappingTable__c> savedMapTable; 
    // currently displayed Mapping fields Table
    public list<replacedMappingTable__c> displayedMapTable {get;set;}
  
    // Saved replacement object and field
    public list<MappedOject__c> saveMappedOjects;
    // currently displayed Object and Field
    public list<MappedOject__c> displayedMappedOjects {get;set;}
        
    public MapFieldSetController(){
        
    }
    public PageReference init(){ 
        displayedMappedOjects = new list<MappedOject__c>();
        displayedMappedOjects.add(new MappedOject__c());
       	buildObjectOption();
        return null; 
    }
    public void buildObjectOption(){
        ObjectOptions = new List<SelectOption>();
        ObjectOptions.add(new SelectOption('--',''));
        map<string,Schema.SObjectType> SObjectTypeMap = Schema.getGlobalDescribe();
        for(string tempApi : SObjectTypeMap.keyset()){
            ObjectOptions.add(
                new SelectOption(
                    SObjectTypeMap.get(tempApi).getDescribe().getlabel(),
                    tempApi));
        }
    }
    
    public PageReference save(){
        return null;
    }
    public PageReference edit(){
        return null;
    }
    public PageReference cancel(){
        return null;
    }
    public void buildFieldOption(){
        
    }

}