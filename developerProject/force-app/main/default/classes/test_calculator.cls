public class test_calculator {
    public CalculatorUtility obj;
	public List<SelectOption> Frequency_list {get;set;}
	public List<SelectOption>Term_list {get;set;}
    public List<SelectOption> PaymentPeriod_list {get;set;}
    public List<SelectOption> IncludeDocFee_list {get;set;}
    public List<SelectOption> ExternalBrokerageRate_list {get;set;}
    public List<SelectOption> InternalBrokerageRate_list {get;set;}
    
    
    public decimal result{get;set;}
    
    public decimal FinancedAmount {get;set;}
    public string Frequency {get;set;}
    public integer Term {get;set;}
    public string PaymentPeriod {get;set;}
    public decimal ExternalBrokerageRate {get;set;}
    public decimal InternalBrokerageRate {get;set;}
    public decimal MarginRate {get;set;}
    public decimal SwapRate {get;set;}
    public decimal RV {get;set;}
    public decimal DocumentationFees {get;set;} 
    public boolean IncludeDocFee {get;set;}
	

    
    public test_calculator(){
   
    }    
    
    public void Init(){
        FinancedAmount=0;
		Frequency_list = Frequency_list();
        Term_list = Term_list();
        PaymentPeriod_list = PaymentPeriod_list();
        IncludeDocFee_list = IncludeDocFee_list();
        ExternalBrokerageRate_list = ExternalBrokerageRate_list();
        InternalBrokerageRate_list = InternalBrokerageRate_list();
		MarginRate =0;
        SwapRate = 0;
        RV =0;
        DocumentationFees = 0;
        Result = 0;
        Frequency = '';
    }
	

    
	 public List<SelectOption> Frequency_list(){

       	List<SelectOption>  Frequency_list= new List<SelectOption>();
        Frequency_list.add(new SelectOption('','Select'));
        Frequency_list.add(new SelectOption('Monthly','Monthly'));
        Frequency_list.add(new SelectOption('Quaterly','Quaterly'));
        return Frequency_list;
      }
	 public List<SelectOption> Term_list(){

       	List<SelectOption>  Term_list= new List<SelectOption>();
         Term_list.add(new SelectOption('','Select'));
        Term_list.add(new SelectOption('24','24'));
        Term_list.add(new SelectOption('36','36'));
        Term_list.add(new SelectOption('48','48'));
        Term_list.add(new SelectOption('60','60'));
         
        return Term_list;
      }
	 public List<SelectOption> PaymentPeriod_list(){

       	List<SelectOption>  PaymentPeriod_list= new List<SelectOption>();
        PaymentPeriod_list.add(new SelectOption('Advance','Advance'));
        PaymentPeriod_list.add(new SelectOption('Arrears','Arrears'));
        return PaymentPeriod_list;
      }
	 public List<SelectOption> IncludeDocFee_list(){

       	List<SelectOption>  IncludeDocFee_list= new List<SelectOption>();
        IncludeDocFee_list.add(new SelectOption('true','true'));
        IncludeDocFee_list.add(new SelectOption('false','false'));
        return IncludeDocFee_list;
      }
	 public List<SelectOption> ExternalBrokerageRate_list(){

       	List<SelectOption>  ExternalBrokerageRate_list= new List<SelectOption>();
        ExternalBrokerageRate_list.add(new SelectOption('1.0','1.0'));
        ExternalBrokerageRate_list.add(new SelectOption('2.0','2.0'));
        return ExternalBrokerageRate_list;
      }
	 public List<SelectOption> InternalBrokerageRate_list(){

       	List<SelectOption>  InternalBrokerageRate_list= new List<SelectOption>();
        InternalBrokerageRate_list.add(new SelectOption('10','10'));
        InternalBrokerageRate_list.add(new SelectOption('2.0','2.0'));
        return InternalBrokerageRate_list;
      }

  	public static void PackageInsystonCall(){
        system.debug('going through Address Utilities');
        Type t = Type.forName('OJ_PM.doInsystoncCall');
           OJ_PM.doInsystoncCall doInsystoncCall = (OJ_PM.doInsystoncCall)t.newInstance();
        OJ_PM.InsystonLixiutility.InsystonLixi_PutRequest Request = new OJ_PM.InsystonLixiutility.InsystonLixi_PutRequest();
        doInsystoncCall.PutRequest(Request);
       
    }  
    public PageReference refresh(){
        Init();
        return null;
    }
    
    public void test(){
        system.debug('***************** FinancedAmount:'+FinancedAmount+'   Frequency: '+Frequency+'  Term:'+ Term + 
                     ' PaymentPeriod:'+ PaymentPeriod +' ExternalBrokerageRate:' +ExternalBrokerageRate +' InternalBrokerageRate'+ InternalBrokerageRate+
                    	' MarginRate: '+ MarginRate+ ' SwapRate :'+ SwapRate+ ' RV: '+RV+ ' DocumentationFees: '+DocumentationFees+' IncludeDocFee:' +IncludeDocFee );
       	//result = CalculatorUtility.CalculatePaymentAmount(FinancedAmount, Frequency, Term, PaymentPeriod, ExternalBrokerageRate, InternalBrokerageRate, MarginRate, SwapRate, RV, DocumentationFees, IncludeDocFee);
        result = OJ_PM.CalculatorUtility.CalculatePaymentAmount(FinancedAmount, Frequency, Term, PaymentPeriod, ExternalBrokerageRate, InternalBrokerageRate, MarginRate, SwapRate, RV, DocumentationFees, IncludeDocFee);
    }
}