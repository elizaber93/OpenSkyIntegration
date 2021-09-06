import { LightningElement, api, track, wire } from 'lwc';
import { subscribe, MessageContext, unsubscribe, APPLICATION_SCOPE, publish} from 'lightning/messageService';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/Country_Updated__c';
import getStatesByCountry from '@salesforce/apex/OpenSkyController.getStatesByCountry';
import getAllStates from '@salesforce/apex/OpenSkyController.getAllStates';
import getTimestamp from '@salesforce/apex/OpenSkycontroller.getTimestamp';
import update from '@salesforce/apex/OpenSkyController.updateData';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class OpenSkyMapLWC extends NavigationMixin(LightningElement) {
    subscription = null;
    searchCountry = '';

    @track timestamp;
    @track mapMarkers;
    @track isLoading = true;
    @track error;

    
    latitude;
    longitude;

    @wire(MessageContext)
    messageContext;


    subscribeToMessageChannel() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                MESSAGE_CHANNEL,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    handleMessage(message) {
        this.searchCountry = message.country;
        console.log(this.searchCountry);
        this.getByCountry();
        
    }

    

    // Standard lifecycle hooks used to subscribe and unsubsubscribe to the message channel
    connectedCallback() {
        this.subscribeToMessageChannel();
    }


    // Helper
    dispatchToast(error) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error loading contact',
                message: reduceErrors(error).join(', '),
                variant: 'error'
            })
        );
    }


    @wire(getTimestamp)
    wiredTimestamp({error, data}) {
        if (data) {
            this.timestamp = data;
        }
    }

    
        @wire(getAllStates)
        wiredStates({error, data}){
            if(data) {
                this.mapMarkers = data.map((airplane) => {
                    return {
                        location: {
                            Longitude: airplane.Current_Location__Longitude__s,
                            Latitude: airplane.Current_Location__Latitude__s
                        },
                        title: airplane.Callsign__c,
                        value: airplane.Id
                    }
                });
                
            this.mapMarkers.unshift({
                location: {
                    Longitude: this.longitude,
                    Latitude: this.latitude
                },
                title: "You\'re here",
            })
            
            
        } }

    
        renderedCallback() {
            this.getLocationFromBrowser();
        }

        getLocationFromBrowser() {                      
            navigator.geolocation.getCurrentPosition((position) => {                             
                this.latitude = position.coords.latitude;
                this.longitude = position.coords.longitude;
            },
            (e) => {
            },
            {
            enableHighAccuracy: true
            }
            );
        }

        @api
        getByCountry() {
        getStatesByCountry({country: this.searchCountry})
            .then(data => {this.mapMarkers = data.map((airplane) => {
                return {
                    location: {
                        Longitude: airplane.Current_Location__Longitude__s,
                        Latitude: airplane.Current_Location__Latitude__s
                    },
                    value: airplane.Id
                }
            });
            this.mapMarkers.unshift({
                location: {
                    Longitude: this.longitude,
                    Latitude: this.latitude
                },
                title: "You\'re here",
            });})
            .catch ((e)=>{});

        }
        
        handleDataUpdate() {
            console.log('im doing smth');
            this.isLoading = true;
            update()
            .then((data) => {
                this.isLoading = false;
            })
            .catch ((e)=>{this.showErrorNotification();});

            
        }

        selectedMarkerValue;

    handleMarkerSelect(event) {
        this.selectedMarkerValue = event.target.selectedMarkerValue;
        publish(this.messageContext, MESSAGE_CHANNEL, {country: this.searchCountry, recordId: this.selectedMarkerValue});
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: 'Data update',
            message: 'Airplane data was successfully updated',
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

    showErrorNotification() {
        const evt = new ShowToastEvent({
            title: 'Data update',
            message: 'Airplane data wasn\'t updated',
            variant: 'error',
        });
        this.dispatchEvent(evt);
    }



}