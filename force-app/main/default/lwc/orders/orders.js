// Composant Lightning Web Component pour afficher le total des commandes d'un compte
// Affiche un message d'erreur si aucune commande ou un message de succès avec le total
import { LightningElement, api, wire } from 'lwc';
import getSumOrdersByAccount from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';

export default class Orders extends LightningElement {

    // ID du compte depuis la page (passé automatiquement par Salesforce)
    @api recordId;
    // Montant total des commandes activées du compte
    sumOrdersOfCurrentAccount = 0;

    // Wire service : récupère automatiquement les données depuis Apex
    // Se met à jour automatiquement si recordId change
    @wire(getSumOrdersByAccount, { accountId: '$recordId' })
    wiredOrders({ error, data }) {
        if (data) {
            // Met à jour le montant total si les données sont disponibles
            this.sumOrdersOfCurrentAccount = data;
        } else if (error) {
            // En cas d'erreur, initialise à 0
            this.sumOrdersOfCurrentAccount = 0;
        }
    }

    // Getter : vérifie s'il y a des commandes avec un montant supérieur à 0
    // Utilisé dans le template pour afficher le message de succès
    get hasOrders() {
        return this.sumOrdersOfCurrentAccount != null && this.sumOrdersOfCurrentAccount > 0;
    }

    // Getter : vérifie s'il n'y a pas de commandes ou si le montant est égal à 0
    // Utilisé dans le template pour afficher le message d'erreur
    get hasNoOrders() {
        return this.sumOrdersOfCurrentAccount == null || this.sumOrdersOfCurrentAccount === 0;
    }
}