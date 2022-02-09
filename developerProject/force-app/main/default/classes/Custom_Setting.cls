public with sharing class Custom_Setting {   
    
    public static Custom_Setting__c     Custom_Setting;
    public static void LoadCustomSettingsdata(){
        Custom_Setting = Custom_Setting__c.getInstance();
    }
    // because there's a static, we can access to the function
    
    public static double getGST(){
        LoadCustomsettingsdata();    
        return Custom_Setting.GST__c * 100;
    }
    
    public static void setCustomSettings(Custom_Setting__c CustomSetting){
        Custom_Setting = CustomSetting;
    }    
}