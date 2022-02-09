global class InfoReplacementBatch implements Database.Batchable<sObject>,Database.Stateful {
    global string objectApi = '';
    global string fieldApis  = '';
    global map<string, string> replacedMappingTable = new map<string, string>();
    global list<string> fieldList = new list<string>();
    global InfoReplacementBatch(string objectApi, string fieldApis){
        this.objectApi = objectApi;
        this.fieldApis = fieldApis;
        // get current replace Mapping Field
        buildreplacedMappingTable();
        // get the field that is needed to replace
        fieldList =  fieldApis.split(',');
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, '+ fieldApis + ' FROM ' + objectApi;
        system.debug('query:'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> objectList) {
        list<Sobject> updateObjectList = new list<Sobject>();
        for(Sobject obj : objectList){
          	// if a field has been update, then put this data into update records;
            if(checkAndUpdatefield(obj)){
                updateObjectList.add(obj);
            } 
        }
        if( updateObjectList.size() > 0){
            update updateObjectList;
        }
    }
    
    global void finish(Database.BatchableContext BC) { 
		//InfoReplacementSchedule.assignOneMinute();    
    }
    
    global boolean CheckAndUpdatefield(Sobject obj){
        boolean isUpdate = false;
        for(string keyValue : replacedMappingTable.keySet()){
            for(string  tempFieldApi : fieldList){
                string tempFieldValue = string.valueof(obj.get(tempFieldApi));
                if(string.isNotblank(tempFieldValue) && tempFieldValue.contains(keyValue)){
                    tempFieldValue = 
                        tempFieldValue.replaceAll(keyValue, replacedMappingTable.get(keyValue));
                    obj.put(tempFieldApi,tempFieldValue);
                    isUpdate = true;
                }
            }
        }
        return isupdate;
        
    }
    
    global void BuildreplacedMappingTable(){
        list<replacedMappingTable__c> replacedMappingTableList = 
            [select id ,fromColumn__c,toColumn__c
             from replacedMappingTable__c];
        for(replacedMappingTable__c tempreplacedMappingTable : replacedMappingTableList){
            replacedMappingTable.put(tempreplacedMappingTable.fromColumn__c,
                                     tempreplacedMappingTable.toColumn__c);
            
        }
        
    }
    

    
}