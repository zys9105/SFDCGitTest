/**
 * File Name: ContactTrigger
 * Description: trigger works while Contact is modified  
 * @author  Jack
 * @version 1.0
 * @since   2017-02-01 
 */
trigger ContactTrigger on Contact (before insert,before delete, After insert,after undelete) {
    if(trigger.isBefore){   // Call to Helper method before updating    
        if(trigger.isInsert){ 
            ContactTriggerHelper.InheritanceAddress(trigger.new);    //Inherite the Account Address
        }else if(trigger.isdelete){
            ContactTriggerHelper.ContactNumberdecrease(trigger.old); //Decrease contact number on Account
        }
    }
    else if(trigger.isAfter){   // Call to Helper method after updating
        if(trigger.isInsert){ 
            ContactTriggerHelper.ContactNumberincrease(trigger.new); //Increase contact number on Account
        }
        else if(trigger.isundelete){// Call to Helper method for undelete context
        ContactTriggerHelper.ContactNumberincrease(trigger.new); //Increase contact number on Account
        }
    }
}