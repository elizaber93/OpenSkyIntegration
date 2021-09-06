import { LightningElement, api, track, wire } from 'lwc';
import { MessageContext, subscribe, APPLICATION_SCOPE } from 'lightning/messageService';


import MESSAGE_CHANNEL from '@salesforce/messageChannel/Country_Updated__c';
import followAirplane from '@salesforce/apex/OpenSkyController.followTheAirplane';

export default class RecordFormCreateExample extends LightningElement {
    recordId;
    subscribtion = null;
  
    @wire(MessageContext)
    messageContext

    connectedCallback() {
        this.subscribeMC();
    }

    subscribeMC() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                MESSAGE_CHANNEL,
                (message) => {this.recordId = message.recordId;},
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    followTheAirplane() {
        followAirplane({recordId: this.recordId});
    }

}