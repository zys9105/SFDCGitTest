public with sharing class pdfcontroller {
    
    public list<string> state {get;set;}
    
public List<SelectOption> getStateFilter() {
            List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('true','Bar')); 
        options.add(new SelectOption('fal2se','Gauge')); 
        options.add(new SelectOption('tru2e','B5ar')); 
        options.add(new SelectOption('tru3e','B6ar')); 
        options.add(new SelectOption('tr4ue','Ba7r')); 
     return options; 
}
public void MapFilter(){
    system.debug('Object msg:'+state[0]+':::::'+state[1]);
}
}