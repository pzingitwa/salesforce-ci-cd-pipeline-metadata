import { LightningElement, api } from 'lwc';
import sendToLambdaAction from '@salesforce/apex/LambdaCallout.sendToLambdaAction';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SendToLambdaButton extends LightningElement {
    @api recordId; // Salesforce passes current record Id here

    handleClick() {
        sendToLambdaAction({ recordId: this.recordId })
            .then(result => {
                this.showToast('Success', result, 'success');
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        }));
    }
}