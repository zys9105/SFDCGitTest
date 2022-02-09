/**
 * File Name:AccountTrigger
 * Description: trigger works while Account is modified 
 * @author  Jack
 * @version 1.0
 * @since   2017-02-01
 */
trigger AccountTrigger on Account(After update) {
  if (trigger.isBefore) { // Call to Helper method before updating
  } 
  else if (trigger.isAfter) { // Call to Helper method after updating
    if (trigger.isUpdate) {
      AccountTriggerHelper.UpdateContactMailingAddress(trigger.new); //Increase contact number on Account
    }
  }
}