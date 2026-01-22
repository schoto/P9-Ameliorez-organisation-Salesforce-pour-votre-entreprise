import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import CHIFFRE_AFFAIRE_FIELD from '@salesforce/schema/Account.Chiffre_d_affaire_c';

export default class ChiffreAffaire extends LightningElement {
    @api recordId;
    chiffreAffaire = 0;

    @wire(getRecord, { recordId: '$recordId', fields: [CHIFFRE_AFFAIRE_FIELD] })
    wiredAccount({ error, data }) {
        if (data) {
            this.chiffreAffaire = data.fields.Chiffre_d_affaire_c?.value || 0;
        } else if (error) {
            this.chiffreAffaire = 0;
        }
    }

    get formattedChiffreAffaire() {
        return new Intl.NumberFormat('fr-FR', { 
            style: 'currency', 
            currency: 'EUR' 
        }).format(this.chiffreAffaire);
    }
}
