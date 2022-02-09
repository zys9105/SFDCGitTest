public class EmailSend {
    public Email__c mapping_rec_Email {get; set;}
    
      public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
  set;
  }
    
    public void Init(){
        mapping_rec_Email = new Email__c();

    }
    public void sent_email(){   
		EmailManager em = new EmailManager();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(attachment.Name);
        efa.setBody(attachment.Body);
        //em.sendMail('zhangyushan0412@outlook.com', 'aaaa', 'bbbbb',efa);
        em.sendMail(mapping_rec_Email.Email_Address__c, mapping_rec_Email.Email_Object__c, mapping_rec_Email.Email_Body__c,efa);
    }    



}