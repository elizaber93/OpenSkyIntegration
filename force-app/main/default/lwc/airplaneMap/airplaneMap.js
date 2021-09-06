import { LightningElement, wire, track } from 'lwc';
import { MessageContext, subscribe, APPLICATION_SCOPE } from 'lightning/messageService';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import LONGITUDE_FIELD from '@salesforce/schema/Airplane__c.Current_Location__Longitude__s';
import LATITUDE_FIELD from '@salesforce/schema/Airplane__c.Current_Location__Latitude__s';
const FIELDS = [LONGITUDE_FIELD,LATITUDE_FIELD];
export default class AirplaneMap extends LightningElement {
    @track recordId = '';
    subscribtion = null;
    @track mapMarker;
/*
    @wire(getRecord, { recordId: this.recordId, fields: FIELDS })
    createMapMarker() {
        this.mapMarker = [{Longitude: getFieldValue(this.airplane.data, LONGITUDE_FIELD), Latitude: getFieldValue(this.airplane.data, LATITUDE_FIELD)}];
    }

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
                (message) => {this.recordId = message.recordId; this.createMapMarker();},
                { scope: APPLICATION_SCOPE }
            );
        }
    }


*/



}