public class FixHeadTableController {
    public list<Account> accs;
    public void FixHeadTableController(){
    }
    public void init(){
        accs = [select id,name,AccountNumber,Website from Account];
    }
    public list<Account> getAccounts(){
        return accs;
    }
    

}