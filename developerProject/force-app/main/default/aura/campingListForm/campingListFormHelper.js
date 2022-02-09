({   
    validateCampingForm : function(component){
        var validitem = true;

        // Name must not be blank
        var nameField = component.find("itemname");
        var itemname = nameField.get("v.value");
        if ($A.util.isEmpty(itemname)){
            validitem = false;
            var nameField = component.find("itemnam");
            nameField.set("v.errors", [{message:"Item name can't be blank."}]);
        }
        else {
            nameField.set("v.errors", null);
        }
        
        // price must not be blank
        var PriceField = component.find("Itemprice");
        var itemPrice = PriceField.get("v.value");
        
        if ($A.util.isEmpty(itemPrice) || itemPrice == 0){
            validitem = false;
            PriceField.set("v.errors", [{message:"Item price can't be blank or 0."}]);
        }
        else {
            PriceField.set("v.errors", null);
        }
        
		// Quantity must not be blank

        var QuantityField = component.find("ItemQuantity");
        var itemQuantity = QuantityField.get("v.value");
        
        if ($A.util.isEmpty(itemQuantity) || itemQuantity == 0){
            validitem = false;
            QuantityField.set("v.errors", [{message:"Item Quantity can't be blank or 0."}]);
        }
        else {
            QuantityField.set("v.errors", null);
        }
        return (validitem);
        
    },
        
		
     createItem : function(component) {
        var newItem = component.get("v.newItem");
        var addEvent = component.getEvent("addItem");
        addEvent.setParams({"item" : newItem});
        addEvent.fire();
        component.set("v.newItem",
                     { 'sobjectType': 'Camping_Item__c',
                    'Name': '',
                    'Packed__c': false,
                    'Price__c': 0,
                    'Quantity__c': 0});
    }
})