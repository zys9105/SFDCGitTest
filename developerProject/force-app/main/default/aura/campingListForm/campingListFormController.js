({
	submitForm: function(component, event, helper) {
        if(helper.validateCampingForm(component)){
            var newItem = component.get("v.newItem");
            helper.createItem(component, newItem);
        }
    }
})