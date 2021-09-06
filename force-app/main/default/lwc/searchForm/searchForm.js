import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import getCountries from '@salesforce/apex/OpenSkyController.getCountries';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/Country_Updated__c';

export default class SearchForm extends LightningElement {
    @wire(MessageContext)
    messageContext;

    value = 'inProgress';
    options;

    @wire(getCountries)
        wiredCountries({error, data}){
            if(data) {
                
                this.options = data.map((row) => {
                    return {
                            label: row,
                            value: row
                    }
                });
                this.options.unshift({label:'Select All', value: ''});
            } else if (error) {
                this.error = error;
            }
            
        }

    handleChange(event) {
        this.value = event.detail.value;
        var payload = { country: this.value };
        publish(this.messageContext, MESSAGE_CHANNEL, payload);
    }
}
