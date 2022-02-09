global class AccountUtility {
  
   webservice static Account GetAccount(String AccId) {
       if(AccId == null || string.Isempty(AccId))
           return null;
       Account acc = [select Id, Name from Account where Id =: AccId];
       return acc;
  }
  

}