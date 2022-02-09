public with sharing class removerowfrompageblocktable

{

	private List<String> sList;
	private List<Integer> iList;

	public List<MyWrapper>  myWrapperList {get;set;}

	public class MyWrapper {
   		public String str {get; set;}
   		public Integer int1 {get; set;}
   		public boolean IncludeDocFee {get;set;}
   		public MyWrapper(String s, Integer i) {
      		this.str = s;
      		this.int1 = i;
      		this.IncludeDocFee = false;
		}
	}
    public void init(){
        myWrapperList = new List<MyWrapper>();
    }
	public void addrow(){
		
		MyWrapper MyWrapper = new MyWrapper('a',0);
		myWrapperList.add(MyWrapper);
		
		MyWrapper MyWrapper2 = new MyWrapper('b',1);
		myWrapperList.add(MyWrapper2);
    }
    
    public void removerow(){
		for(integer i = 0; i<myWrapperList.size();i++){
			if(myWrapperList[i].IncludeDocFee){
				myWrapperList.remove(i);
				i--;
			}
		}
    }
}