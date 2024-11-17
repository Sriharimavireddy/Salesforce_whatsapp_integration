import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendTemplateMessage from '@salesforce/apex/whatsappIntergrationCont.sendTemplateMessage';

export default class WhatsappMessageIntegration extends LightningElement {
    @api recordId
    onSendMessageTemplate(){
        sendTemplateMessage({contactId : this.recordId})
        
        .then(result =>{
            const toasEvent = new ShowToastEvent({
                title: 'Message sent successfully',
                message: 'The message has been sent successfully',
                variant: 'success'
            });
            this.dispatchEvent(toasEvent);
        })
        .catch(error =>{
            const toasEvent = new ShowToastEvent({
                title: 'Message failed',
                message: 'An error occured while sending whatspp message',
                variant: 'error',
        });
        this.dispatchEvent(toasEvent);
    })
    }
}