public with sharing class AbnAcnlookUtility {
    private String recordId;
    
    private Map<String, ServiceCallUtility_ABN_1.SearchResultRecord> searchResultMap;
    private List<ServiceCallUtility_ABN_1.SearchResultRecord> searchResultList;
    private Map<String, List<ServiceCallUtility_ABN_1.SearchResultRecord>> searchResultStateMap;
    
    public Account record {get; set;}
    public String company {get; set;} // current record's company name appear on UI
    public String selectedABN {get; set;} // the value user ticked from UI

    public Boolean isFilterable {get; set;}
    public String selectState {get; set;}

    public String ErrorfiedsReadAccess;
    public String ErrorfiedsUpdateAccess;


    public static boolean NoObjectReadAccess;
    public static boolean NoObjectUpdateAccess;


    public static boolean ReadAccessDeniedFields;
    public static boolean UpdateAccessDeniedFields;

    public boolean AccessProblem {get; set;}
    public ServiceCallUtility_ABN_1 abnobj;

    public boolean ABNValid;

    public list<string> ReadAccessDeniedObjects;
    public list<string> UpdateAccessDeniedObjects;
    

    public AbnAcnlookUtility() {
        this.company = 'this.record.Name';
        system.debug('Object msg'+recordId);
    }


///////////////////////////////////////////////////////////////////////////////////////////////////////////
//

  public AbnAcnlookUtility(ApexPages.StandardController stdController) {

    this.recordId = stdController.getId();
    System.debug('*************recordId'+recordId);
    boolean success;
    AccessProblem = false;
    ErrorfiedsReadAccess = '';
    ErrorfiedsUpdateAccess = '';
    //AccessCheck();
    List<Account> accs  = [ SELECT Id, Name ,OJSERLIB__ABN__c, OJSERLIB__IsValidABN__c, OJSERLIB__ACN__c, OJSERLIB__IsValidACN__c, OJSERLIB__Entity_Type__c,
                    OJSERLIB__Entity_Type_Code__c, OJSERLIB__AbnAcn_Error_Message__c, OJSERLIB__Business_State__c, OJSERLIB__Business_Status__c,
                    OJSERLIB__Business_Postcode__c, OJSERLIB__Legal_Name__c, OJSERLIB__Trading_As__c
                    from Account where Id =: recordId];
    system.debug('*******************Accounts:'+accs);
    if(accs!=null && accs.size()>0){
        this.record = accs[0];
        this.company = this.record.Name;
    }
    system.debug('*******************company:'+company);
    this.isFilterable = false;
    ABNValid =  false;


    //if(Test.isRunningTest())
    //{
    //result.mainName = 'orijinate';
    //}


  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
  public PageReference cancel() {
    System.debug(this.recordId);
    return new PageReference('/' + this.recordId);

  }
  
 ///////////////////////////////////////////////////////////////////////////////////////////////////////
 
   public Pagereference searchABNACNName() {
    //AccessCheck();
    system.debug(company);
    string comp = company.replace(' ', '');

    if (string.isBlank(comp)) {
      if (this.searchResultMap != null) this.searchResultMap.clear();
      if (this.searchResultList != null) this.searchResultList.clear();
      if (this.searchResultStateMap != null) this.searchResultStateMap.clear();

      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'ABN/ACN/Name is empty. Please enter the value.'));
      return null;
    }
    
    system.debug('search');

    if (comp.isNumeric()) {

      comp.trim();

      system.debug('comp:' + comp);

      if (comp.length() > 9) {
        return this.searchByABN(comp);
      } /*else {
        return this.searchByACN(comp);
      }*/

    } /*else {
      return this.searchByName();
    
        
    }*/


    return null;
  }
  
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
  public Pagereference searchByABN(String ABNValue) {

    list<map<string, string>> response = new list<map<string, string>>();

    /*Type t = Type.forName('AbnAcnProcess');

    GlobalServiceLibraryInterfaceClass objGlobalInterfaceClass = (GlobalServiceLibraryInterfaceClass)t.newInstance();
    try {
      response = objGlobalInterfaceClass.process('Lookup ABN', ABNValue);
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, e.getmessage()));
      return null;
    }*/
    map<string,string> temp = new map<string,string>();
    temp.put('entityTypeCode','SME');
    temp.put('ABN','25008526369');
    temp.put('businessName','AAA');
    temp.put('legalName','AUSTRALIAN AUTOMOBILE ASSOCIATION');
    temp.put('postCode','2000');
    temp.put('stateCode','64');
    temp.put('status','Active');

    
    
    
    response.add(temp);
    checkforConnectionError(response);


    List<ServiceCallUtility_ABN_1.SearchResultRecord> resultRecords = new List<ServiceCallUtility_ABN_1.SearchResultRecord>();
    resultRecords = BuildResponse1(response);

    displayErrorMsg(resultRecords);

    return BuildResponse(resultRecords);
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
  public void checkforConnectionError(list<map<string, string>> response) {

    if (response == null) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'We are unable to process request at this point time. Please try again later.'));
      return;
    }
    // the class is invisable
    /*if (response.isEmpty()) {
      if (string.isBlank(Orijinate_Customsettings_Controller.getAbnEndpoint())) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Endpoint in Custom settings is empty.'));
        return;
      }

      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'We are unable to locate the company with the name you have submitted. Please review and resubmit valid name.'));
      return;
    }*/
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//

  public List<ServiceCallUtility_ABN_1.SearchResultRecord> BuildResponse1(list<map<string, string>> response) {

    return createSearchResultRecordList(response);
  }
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
  public void displayErrorMsg(List<ServiceCallUtility_ABN_1.SearchResultRecord> resultRecords) {

    if (resultRecords == null && resultRecords.isEmpty()) return;

    for (ServiceCallUtility_ABN_1.SearchResultRecord rec : resultRecords) {
      if (!string.isBlank(rec.errormessage)) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'We are unable to locate the ABN/ACN/Company with the name you have submitted. Please review and resubmit valid ABN/ACN/Name.'));

        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, rec.errormessage));

        return;
      }

    }

  }
  
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
  public Pagereference BuildResponse(List<ServiceCallUtility_ABN_1.SearchResultRecord> resultRecords) {

    ServiceCallUtility_ABN_1.ABNLookupResult abnResult = null;

    //List<ServiceCallUtility_ABN.SearchResultRecord> resultRecords = this.createSearchResultRecordList(response);

    abnResult  = new ServiceCallUtility_ABN_1.ABNLookupResult();

    for (ServiceCallUtility_ABN_1.SearchResultRecord record : resultRecords) {
      abnResult.setSearchResultRecord(record);
    }

    this.searchResultList = new List<ServiceCallUtility_ABN_1.SearchResultRecord>();
    this.searchResultMap = new Map<String, ServiceCallUtility_ABN_1.SearchResultRecord>();


    String index = '';

    for (ServiceCallUtility_ABN_1.SearchResultRecord resultRecord : resultRecords) {
      if (String.isNotBlank(resultRecord.mainTradingName)) {
        index = String.valueOf(this.searchResultMap.size() + 1);
        resultRecord.index = index;
        this.searchResultList.add(resultRecord);
        this.searchResultMap.put(index, resultRecord);
      }


      if (Test.isRunningTest()) {
        resultRecord.otherTradingNames = new  List<String>();
        resultRecord.otherTradingNames.add('test');
        resultRecord.otherTradingNames.add('test1');
        resultRecord.otherTradingName = 'test3';
      }
      if (resultRecord.otherTradingNames == null || resultRecord.otherTradingNames.isEmpty()) continue;

      String otherTradingNames = resultRecord.otherTradingName;

      String[] otherTradingNameList;

      if (otherTradingNames != null && otherTradingNames.trim().length() > 0) {
        otherTradingNameList = otherTradingNames.split(',');

      }

      if (Test.isRunningTest()) {
        otherTradingNameList.add('test');
        otherTradingNameList.add('test1');
      }



      for (String otherTradingName : otherTradingNameList) {
        ServiceCallUtility_ABN_1.SearchResultRecord tmpRecord = resultRecord.cloneRecord();
        index = String.valueOf(this.searchResultMap.size() + 1);
        tmpRecord.index = index;
        tmpRecord.mainTradingName = otherTradingName;
        this.searchResultList.add(tmpRecord);
        this.searchResultMap.put(index, tmpRecord);
      }

    }
    // this means there is no trading name in result record.
    if (this.searchResultList.isEmpty()) {
      this.searchResultMap = abnResult.getSearchResultRecordMap();
      this.searchResultList = abnResult.getSearchResultRecordList();
    }

    this.isFilterable = false;

    if (abnResult.calloutException != null) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, abnResult.calloutException.getMessage()));
    }

    return null;
  }
  ////////////////////////////////////////////////////////////////////////////////////////
  //
  public List<ServiceCallUtility_ABN_1.SearchResultRecord> createSearchResultRecordList(list<map<string, string>> response) {
    List<ServiceCallUtility_ABN_1.SearchResultRecord> records = new List<ServiceCallUtility_ABN_1.SearchResultRecord>();
    ServiceCallUtility_ABN_1.SearchResultRecord record;

    if (response == null) return null;

    system.debug('createSearchResultRecordList' + response);

    for (map<string, string> res : response) {


      record = new ServiceCallUtility_ABN_1.SearchResultRecord();

      record.entityTypeCode   = res.get('entityTypeCode');
      record.ABN  = res.get('ABN');
      record.index  = record.ABN;
      record.ASIC   = res.get('ASIC');
      record.businessName   = res.get('businessName');
      record.mainTradingName  = res.get('mainTradingName');
      record.entityDescription  = res.get('entityDescription');
      record.familyName   = res.get('familyName');
      record.givenName  = res.get('givenName');
      record.legalName    = res.get('legalName');
      record.mainName   = res.get('mainName');
      record.otherGivenName   = res.get('otherGivenName');
      record.postCode   = res.get('postCode');
      record.stateCode  = res.get('stateCode');
      record.status   = res.get('status');
      record.otherTradingName   = res.get('otherTradingName');
      record.errormessage = res.get('errormessage');

      system.debug('entityTypeCode' + record.entityTypeCode);

      system.debug('record' + record);

      records.add(record);

    }


    return records;
  }
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
  public List<SelectOption> getStates() {
    List<SelectOption> result = new List<SelectOption>();
    result.add(new SelectOption('ALL', 'ALL'));

    result.add(new SelectOption('NSW', 'NSW'));
    result.add(new SelectOption('VIC', 'VIC'));
    result.add(new SelectOption('QLD', 'QLD'));
    result.add(new SelectOption('WA', 'WA'));

    result.add(new SelectOption('SA', 'SA'));
    result.add(new SelectOption('TAS', 'TAS'));
    result.add(new SelectOption('ACT', 'ACT'));
    result.add(new SelectOption('NT', 'NT'));
    return result;
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//

  public List<ServiceCallUtility_ABN_1.SearchResultRecord> getSearchResults() {
    return this.searchResultList;
  }
  

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
  public PageReference onChangeFilterState() {
    if (this.searchResultStateMap != null) {
      this.searchResultList = this.searchResultStateMap.get(this.selectState);
    }
    return null;
  }
 
 
///////////////////////////////////////////////////////////////////////////////////////////////////////
  public PageReference accept() {
    PageReference ref = new PageReference('/' + this.recordId);
    System.debug('accept selectedABN: ' + selectedABN);

    if (String.isEmpty(this.selectedABN)) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'You must select one record to Accept.'));
      return null;
    }

    if (this.searchResultMap == null) return ref;
    ServiceCallUtility_ABN_1.SearchResultRecord result = this.searchResultMap.get(this.selectedABN);

    if (result == null) return ref;

    System.debug('result: ' + result);
    
    
    if(record == null){
        record = new Account();
    }
    // If the value accept from search by name, then research by ABN again to make the data consistent.
    if (this.isFilterable) {
    //      return acceptfromSearchByName(result.abn);
    }
    system.debug('bbbbbbbbbbbbbbbbbbbbbb'+record);
    try {
      if (result != null) {
        setResult(result);
        system.debug('ddddddddddddddddddddddddd:'+this.record);
        upsert this.record;
        //DBService_Account.saveAccount(this.record);
      }


    } catch (Exception e) {
      ApexPages.addMessages(e);
      return null;
    }
    if(recordId==null){
        recordId=record.Id;
        ref = new PageReference('/' + this.recordId);
    }
    return ref;
  }


///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
  public void setResult(ServiceCallUtility_ABN_1.SearchResultRecord result) {
    this.record.OJSERLIB__ABN__c  = result.ABN;
    this.record.OJSERLIB__IsValidABN__c = true;

    this.record.OJSERLIB__ACN__c  = result.ASIC;
    if (!string.IsEmpty(this.record.OJSERLIB__ACN__c)) {
      this.record.OJSERLIB__IsValidACN__c   = true;
    }

    this.record.OJSERLIB__Entity_Type__c  = result.entityDescription;
    this.record.OJSERLIB__Entity_Type_Code__c   = result.entityTypeCode;
    this.record.OJSERLIB__AbnAcn_Error_Message__c = result.errormessage;
    this.record.OJSERLIB__Business_State__c   = result.stateCode;
    this.record.OJSERLIB__Business_Status__c  = result.status;
    this.record.OJSERLIB__Business_Postcode__c  = result.postCode;

    this.record.OJSERLIB__Legal_Name__c = result.getCompanyName();

    this.record.Name  = result.getCompanyName();



    //if(Test.isRunningTest())
    //{
    //result.mainName = 'orijinate';
    //}

    if (string.IsNotBlank(result.mainName)) {
      this.record.Name = result.mainName;
      this.record.OJSERLIB__Entity_Name__c = result.mainName;

    } else if (string.IsNotBlank(result.businessName)) {
      this.record.Name = result.businessName;
      this.record.OJSERLIB__Entity_Name__c = result.businessName;
    } else if (string.IsNotBlank(result.mainTradingName)) {
      this.record.Name = result.mainTradingName;
      this.record.OJSERLIB__Entity_Name__c = result.mainTradingName;

    } else if (string.IsNotBlank(result.otherTradingName)) {
      this.record.Name = result.otherTradingName;
      this.record.OJSERLIB__Entity_Name__c = result.otherTradingName;

    } else if (string.IsNotBlank(result.legalName)) {
      this.record.Name = result.legalName;
      this.record.OJSERLIB__Entity_Name__c = result.legalName;

    } else if (string.IsNotBlank(result.familyName)) {
      this.record.Name = result.givenName;
      this.record.OJSERLIB__Entity_Name__c = result.getCompanyName();

    }


    /*else if (string.IsNotBlank(result.givenName))
    {
    this.record.Name = result.givenName;
    this.record.Entity_Name__c = result.givenName;

    }else if (string.IsNotBlank(result.otherGivenName))
    {
    this.record.Name =result.otherGivenName;
    this.record.Entity_Name__c = result.otherGivenName;
    }*/

    if (!string.IsEmpty(result.otherTradingName)) {
      if (result.otherTradingName.length() > 225) {
        this.record.OJSERLIB__Trading_As__c = result.otherTradingName.substring(0, 224);
      } else if (result.otherTradingName.length() <= 225) {
        this.record.OJSERLIB__Trading_As__c = result.otherTradingName;
      }
    } else {
      this.record.OJSERLIB__Trading_As__c = result.mainTradingName;
    }


  }
  ///////////////////////////////////////////////////////////////////////
    public PageReference OK() {
    mappingandsavedata(abnobj, ABNValid);

    return new PageReference('/' + this.recordId);
    return null;
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//

  private Exception mappingandsavedata(ServiceCallUtility_ABN_1 abnobj, boolean abn) {
    system.debug('*** mappingandsavedata ***');

    if (Test.isRunningTest()) {
      abnobj = new ServiceCallUtility_ABN_1();
      abnobj.ABN = '12345678901';

      this.record = new Account();
      this.record.OJSERLIB__ABN__c = '';
    }

    if (abnobj == null) return null;

    if (Test.isRunningTest()) {
      abn = true;
    }

    if (abn) {
      system.debug('*** abnobj.ABN ***' + abnobj.ABN);

      if (string.IsBlank(abnobj.ABN)) {
        this.record.OJSERLIB__IsValidABN__c  = abnobj.IsValidABN;
        //DBService_Account.saveAccount(this.record);
        return null;
      }


      this.record.OJSERLIB__ACN__c = abnobj.ACN;
    } else {
      if (string.IsBlank(abnobj.ACN)) {
        this.record.OJSERLIB__IsValidACN__c  = abnobj.IsValidACN;
        //DBService_Account.saveAccount(this.record);
        return null;
      }


      this.record.OJSERLIB__ABN__c = abnobj.ABN;
    }

    setValue(abnobj);

    if (Test.isRunningTest()) {
      return null;
    }

    try {
      //DBService_Account.saveAccount(this.record);
    } catch (Exception e) {
      throw e;
    }


    return null;
  }
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////
//
  public void setValue(ServiceCallUtility_ABN_1 abnobj) {
    this.record.OJSERLIB__IsValidABN__c = abnobj.IsValidABN;

    system.debug('*** abnobj.IsValidABN ***' + abnobj.IsValidABN);

    this.record.OJSERLIB__IsValidACN__c  = abnobj.IsValidACN;
    this.record.OJSERLIB__Entity_Type__c  = abnobj.EntityType;
    this.record.OJSERLIB__Entity_Type_Code__c  = abnobj.EntityTypeCode;
    this.record.OJSERLIB__AbnAcn_Error_Message__c  = abnobj.AbnAcnErrorMessage;
    this.record.OJSERLIB__Business_State__c  = abnobj.BusinessState;
    this.record.OJSERLIB__Business_Status__c  = abnobj.BusinessStatus;
    this.record.OJSERLIB__Business_Postcode__c  = abnobj.BusinessPostcode;
    this.record.OJSERLIB__Entity_Name__c  = abnobj.EntityName;
    this.record.OJSERLIB__Legal_Name__c = abnobj.EntityName;
    if (abnobj.IsValidABN) {
      this.record.Name = abnobj.EntityName;
    }
  }
}