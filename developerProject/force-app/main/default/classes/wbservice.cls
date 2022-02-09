public class wbservice {
    public static list<String> Response =new list<String>();
    //public static ServiceCallUtility_Glasss.ListOfYearsResponse GetListOfYears()
    public static void GetListOfYears() {
        //string strTrnXML =  buildRequestHeader() + buildListOfYearsBody(Request);
        string strTrnXML =  buildRequestHeader() + buildListOfYearsBody();
        system.debug('*** strTrnXML *** ' + strTrnXML);
        HttpResponse httpResponse = new httpResponse();
        httpResponse = BuildAndSendHttpRequest(strTrnXML);
        
        string httpResponsestring = httpResponse.getBody();
        system.debug('*** httpResponsestring *** ' + httpResponsestring);
            /*Response = decodeListOfYearsResponseXML(httpResponse);
            system.debug('*** PPSResp *** ' + Response);*/
        
        XMLDom objXMLDom = new XMLDom(httpResponsestring);
        XMLDom.Element lvElement =  new XMLDom.Element();
     
        lvElement=objXMLDom.getElementByTagName('NewDataSet');
		
        if (lvElement!=NULL)
        {
            if(lvElement.hasChildNodes())
            {
               for(XMLDom.Element rec: lvElement.childNodes) // go through the child nodes
               {
                   lvElement=rec.getElementByTagName('YearCreate');
                   
                   if(lvElement!=NULL)
                   {
                      system.debug('*********************************** its here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                      Response.add(lvElement.nodeValue);
                     //system.debug('123456789'); 
                       
                   }
               }
               system.debug('00000000000000' + Response);  
            } 
   
        }
        
              


        //return response;
    }

    ///////////////////////////////////////////////////////////////////////////////
    public static string buildRequestHeader() {
        string strTrnXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://microsoft.com/webservices/"> '+
                           '<soapenv:Header>'+
                           '<web:AuthHeader>'+
                           //Orijinate_Customsettings_Controller.getGlass_s_Username() custom setting get username
                           '<web:Username>'+ 'orijinate' +'</web:Username>'+
                           //Orijinate_Customsettings_Controller.getGlass_s_Password()
                           '<web:Password>'+ 'orijinatetest' +'</web:Password>'+
                           '</web:AuthHeader>'+
                           '</soapenv:Header> ';

        return strTrnXML;
    }

    ////////////////////////////////////////////////////////////////

    //public static string buildListOfYearsBody(ServiceCallUtility_Glasss.ListOfYearsRequest request){
    public static string buildListOfYearsBody() {
        string strTrnXML = '<soapenv:Body>'+
                           '<web:GetListOfYears>'+
                           //request.ModelTypeCode; get from custom setting
                           '<web:ModelTypeCode>'+ 'A'+'</web:ModelTypeCode>'+
                           '</web:GetListOfYears>'+
                           '</soapenv:Body>'+
                           '</soapenv:Envelope>';

        return strTrnXML;

    }
    //////////////////////////////////////////////////////////////

    public static HttpResponse BuildAndSendHttpRequest(string strTrnXML) {
        Http 			http;
        HttpRequest		httpRequest;
        HttpResponse 	httpResponse;
        system.debug('*** BuildAndSendHttpRequestForCollateralRegisteration ***' + strTrnXML);
        try {
            http = new Http();
            httpRequest = new HttpRequest();
            httpRequest.setMethod('POST');
            httpRequest.setEndpoint('http://www.eurotaxglasswebservices.com.au/GeneralGGWebService.asmx');

            //httpRequest.setEndpoint(Orijinate_Customsettings_Contro//ller.getGlass_s_Endpoint());
            httpRequest.setBody(strTrnXML);
            httpRequest.setHeader('Content-Type', 'text/xml');
            httpRequest.setTimeout(120000);
            httpResponse = http.send(httpRequest);
            System.Debug('*** httpResponse ' + httpResponse);
            if (httpResponse.getStatusCode() != 200) {
                System.Debug('*** Error thrown - ' + httpResponse.getStatusCode());
                system.debug('*** response body: ' + httpResponse.getBody());
            }
        }
        catch (Exception e) {
            system.debug('*** CALLOUT EXCEPTION ***' + e.getMessage());
        }
        return httpResponse;
    }
}