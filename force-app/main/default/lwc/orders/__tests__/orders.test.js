// Tests unitaires pour le composant LWC Orders
import { createElement } from 'lwc';
import Orders from 'c/orders';
import getSumOrdersByAccount from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';

// Mock de la méthode Apex pour éviter les appels réels lors des tests
jest.mock(
    '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

describe('c-orders', () => {
    // Nettoie le DOM et les mocks après chaque test
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    // Test : affiche un message d'erreur quand il n'y a pas de commandes
    it('displays error message when no orders', () => {
        const element = createElement('c-orders', { is: Orders });
        element.recordId = '001000000000000AAA';
        // Simule une réponse avec 0 (aucune commande)
        getSumOrdersByAccount.mockResolvedValue(0);

        document.body.appendChild(element);

        // Vérifie que le message d'erreur est affiché
        return Promise.resolve().then(() => {
            const errorDiv = element.shadowRoot.querySelector('.slds-theme_error');
            expect(errorDiv).not.toBeNull();
        });
    });

    // Test : affiche un message de succès avec le montant total quand des commandes existent
    it('displays success message when orders exist', () => {
        const element = createElement('c-orders', { is: Orders });
        element.recordId = '001000000000000AAA';
        // Simule une réponse avec un montant positif
        getSumOrdersByAccount.mockResolvedValue(1354390);

        document.body.appendChild(element);

        // Vérifie que le message de succès est affiché avec le bon montant
        return Promise.resolve().then(() => {
            const successDiv = element.shadowRoot.querySelector('.slds-theme_success');
            expect(successDiv).not.toBeNull();
            expect(successDiv.textContent).toContain('1354390');
        });
    });
});