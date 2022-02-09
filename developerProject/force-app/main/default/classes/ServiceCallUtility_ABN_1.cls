public with sharing class ServiceCallUtility_ABN_1 {

	public String ABN  			{get; set;}
	public String ACN  			{get; set;}
	public String CompanyName 		{get; set;}
	public boolean IsValidABN 		{get; set;}
	public boolean IsValidACN 		{get; set;}
	public String EntityType		{get; set;}
	public String EntityTypeCode	{get; set;}
	public String AbnAcnErrorMessage {get; set;}
	public String BusinessState {get; set;}
	public String BusinessStatus {get; set;}
	public String BusinessPostcode {get; set;}
	public String EntityName {get; set;}

	public ServiceCallUtility_ABN_1() {
		this.ABN 		= '';
		this.ACN 		= '';
		this.CompanyName = '';
		this.IsValidABN = false;
		this.IsValidACN = false;
		EntityType = '';
		EntityTypeCode = '';
		AbnAcnErrorMessage = '';
		BusinessState = '';
		BusinessStatus = '';
		BusinessPostcode = '';
		EntityName = '';
	}


	public class SearchResultRecord {
		public String entityTypeCode {get; set;}
		public String entityDescription {get; set;}
		public String givenName {get; set;}
		public String otherGivenName {get; set;}
		public String familyName {get; set;}
		public String legalName {get; set;}
		public String mainName {get; set;}
		public String businessName {get; set;}
		//From mid 2013 all Trading Names will be removed from the ABR and hence ABN Lookup.
		public String mainTradingName {get; set;}
		public String otherTradingName {get; set;}
		public List<String> otherTradingNames {get; set;}
		public String index {get; set;}
		public String ABN {get; set;}
		public String ASIC {get; set;}
		public String status {get; set;}
		public String stateCode {get; set;}
		public String postCode {get; set;}
		public String errormessage {get; set;}

		//private String name;


		public Boolean isSoleTrader() {
			return (!(String.isBlank(entityTypeCode)) && entityTypeCode.trim() == 'IND');
		}



		public String getCompanyName() {

			system.debug('**** entityTypeCode' + entityTypeCode);


			if (!(String.isBlank(entityTypeCode)) && entityTypeCode.trim() == 'IND') {

				system.debug('**** Entering');

				return (!(String.isBlank(this.familyName)) ? this.familyName : '') + ', '
				       + (!(String.isBlank(this.givenName)) ? this.givenName : '') + ' '
				       + (!(String.isBlank(this.otherGivenName)) ? this.otherGivenName : '');
			} else {
				return this.getName();
			}
		}



		public String getName() {

			if (!(String.isBlank(this.mainName))) {
				system.debug('this.mainName' + this.mainName);
				return this.mainName;
			} else if (!(String.isBlank(this.legalName))) {
				system.debug('this.legalName' + this.legalName);
				return this.legalName;
			} else if (!(String.isBlank(this.businessName))) {
				return this.businessName;
			} else if (!(String.isBlank(this.mainTradingName))) {
				return this.mainTradingName;
			} else if (!(String.isBlank(this.otherTradingName))) {
				return this.otherTradingName;
			}
			return '';
		}




		public String getTradingName() {
			if (!(String.isBlank(this.mainTradingName))) {
				return this.mainTradingName;
			} else if (!(String.isBlank(this.otherTradingName))) {
				return this.otherTradingName;
			}
			return '';
		}

		public SearchResultRecord cloneRecord() {
			SearchResultRecord result = new SearchResultRecord();

			result.entityTypeCode = this.entityTypeCode;
			result.entityDescription = this.entityDescription;
			result.givenName = this.givenName;
			result.otherGivenName = this.otherGivenName;
			result.otherGivenName = this.familyName;
			result.legalName = this.legalName;
			result.mainName = this.mainName;
			result.businessName = this.businessName;
			result.mainTradingName = this.mainTradingName;
			result.otherTradingName = this.otherTradingName;
			result.otherTradingNames = this.otherTradingNames;
			result.ABN = this.ABN;
			result.ASIC = this.ASIC;
			result.status = this.status;
			result.stateCode = this.stateCode;
			result.postCode = this.postCode;

			return result;
		}

		public SearchResultRecord() {
			this.entityTypeCode = '';
			this.entityDescription = '';
			this.givenName = '';
			this.otherGivenName = '';
			this.familyName = '';
			this.legalName = '';
			this.mainName = '';
			this.businessName = '';
			this.mainTradingName = '';
			this.otherTradingName = '';
			this.otherTradingNames = new List<String>();
			this.ABN = '';
			this.ASIC = '';
			this.status = '';
			this.stateCode = '';
			this.postCode = '';
		}
	}


	public class ABNLookupResult {
		public Exception calloutException;
		private Map<String, SearchResultRecord> searchResultRecordMap;
		private List<SearchResultRecord> searchResultRecordList;
		private Map<String, List<SearchResultRecord>> searchResultStateMap;

		public ABNLookupResult() {
			searchResultRecordMap = new Map<String, SearchResultRecord>();
			searchResultRecordList = new List<SearchResultRecord>();
			searchResultStateMap = new Map<String, List<SearchResultRecord>>();
		}

		public void setSearchResultRecord(SearchResultRecord record) {
			searchResultRecordMap.put(record.ABN, record);
			searchResultRecordList.add(record);
		}

		public void setSearchResultStateMap(SearchResultRecord record) {
			List<SearchResultRecord> stateRecords = searchResultStateMap.get(record.stateCode);
			if (stateRecords == null) {
				stateRecords = new List<SearchResultRecord>();
				stateRecords.add(record);
				searchResultStateMap.put(record.stateCode, stateRecords);
			} else {
				stateRecords.add(record);
			}

			stateRecords = searchResultStateMap.get('ALL');
			if (stateRecords == null) {
				stateRecords = new List<SearchResultRecord>();
				stateRecords.add(record);
				searchResultStateMap.put('ALL', stateRecords);
			} else {
				stateRecords.add(record);
			}
		}


		public SearchResultRecord getSearchResultRecord(String abn) {
			return searchResultRecordMap.get(abn);
		}

		public Map<String, SearchResultRecord> getSearchResultRecordMap() {
			return searchResultRecordMap;
		}

		public List<SearchResultRecord> getSearchResultRecordList() {
			return searchResultRecordList;
		}

		public Map<String, List<SearchResultRecord>> getSearchResultStateMap() {
			return searchResultStateMap;
		}

	}


	public class ABNLookupException extends Exception {

	}


////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
	public static boolean abncalculation(string ABN) {
		String[] cha = ABN.split('');

		if (cha.size() < 11) {
			return false;
		}

		cha.remove(0);

		system.debug(cha);
		system.debug(cha.size());
		cha.get(0);
		system.debug(cha.get(0));

		Integer[] weight = new Integer[] {10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19};
		Integer total = 0;
		Integer i = 0;

		for (String ref : cha) {
			if (i == 0) {
				total += (Integer.valueOf(ref) - 1) * Integer.valueOf(weight.get(i));
			} else {
				total += Integer.valueOf(ref) * Integer.valueOf(weight.get(i));
			}

			i = i + 1;
		}


		system.debug(String.valueOf(total));
		Long total2 = 89;
		Long result = math.mod(total, total2);
		if (Integer.valueOf(result) == 0) {
			system.debug('valid');
			return true;
		}

		system.debug(result);
		return false;
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
	public static boolean acncalculation(string ACN) {
		//String ACN = '008249979';
		//'51164567711';
		String[] cha = ACN.split('');

		if (cha.size() < 9) {
			return false;
		}

		cha.remove(0);

		String lastdigit = cha.get(8);
		cha.remove(8);

		system.debug(cha);
		system.debug(cha.size());
		cha.get(0);
		system.debug(cha.get(0));


		Integer[] weight = new Integer[] {8, 7, 6, 5, 4, 3, 2, 1};
		Integer total = 0;
		Integer i = 0;

		for (String ref : cha) {

			total += Integer.valueOf(ref) * Integer.valueOf(weight.get(i));
			i = i + 1;
		}

		system.debug(String.valueOf(total));

		Long total2 = 10;

		Long result = math.mod(total, total2);

		Integer complement;

		if (Integer.valueOf(result) == 10) {
			complement = 0;
		} else {
			complement = 10 - Integer.valueOf(result);
		}

		if (complement == Integer.valueOf(lastdigit)) {
			system.debug('valid acn');
			return true;
		}

		system.debug('Invalid acn');
		return false;

	}

}