trigger ExecOrderTrigger on Contact (before insert, before update, after insert, after update) { 

if (Trigger.isBefore && testHelperClass.a) {
 testHelperClass.testmethod1(Trigger.New);
 testHelperClass.a = false;
} 

}