public class InfoReplacementSchedule implements Schedulable {
    //Call a Batch to replace One Object and multiple Field
    public void execute(SchedulableContext SC) {
        //
        Integer i = 1;
    }
    // Abort finished schedule and run the schedule again in 1 min 
    public static void assignOneMinute(){
        // Get current Time
        Datetime Now 	= 	Datetime.now();
        String Year 	= 	String.valueOf(Now.Year());
        String Month 	= 	String.valueOf(Now.Month());
        String day 		= 	String.valueOf(Now.Day());
        String hour 	= 	String.valueOf(Now.hour());
        String min 		= 	String.valueOf(Now.minute() + 1); 
        String ss 		= 	String.valueOf(Now.second());
        //parse to cron expression
        String nextFireTime = ss + ' ' + min + ' ' + hour +' '+ day +' ' + Month +' ? '+ Year;
        // Abort finished Schedule
        List<CronTrigger> ct = [SELECT Id,  State ,CronJobDetail.name 
                                FROM CronTrigger 
                                where CronJobDetail.name like 'InfoReplacementScheduleX%' 
                                and State  = 'DELETED'];
        if (ct.size() > 0) {
            for (CronTrigger c : ct) {
                system.abortJob(c.Id);
                system.debug('job aborted');
            }
        }
        // Set a new schedule, we could Notice that add an extra X 
        // in order to differ the daily schedule 
        InfoReplacementSchedule s = new InfoReplacementSchedule(); 
        System.schedule('InfoReplacementScheduleX'+nextFireTime, nextFireTime, s);
    }
}