import { createElement } from 'lwc';
import Orders from 'c/orders';
import { registerApexTestWireAdapter } from '@salesforce/sfdx-lwc-jest';
import getSumOrdersByAccount from '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount';

jest.mock(
    '@salesforce/apex/MyTeamOrdersController.getSumOrdersByAccount',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

const getSumOrdersByAccountAdapter =
    registerApexTestWireAdapter(getSumOrdersByAccount);

function flushPromises() {
    return Promise.resolve();
}

describe('c-orders', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('affiche le total des commandes quand Apex retourne un montant > 0', async () => {
        const element = createElement('c-orders', {
            is: Orders
        });
        element.recordId = '001000000000001AAA';

        document.body.appendChild(element);

        getSumOrdersByAccountAdapter.emit(1500);
        await flushPromises();

        const successDiv = element.shadowRoot.querySelector(
            'div.slds-theme_success'
        );
        const errorDiv = element.shadowRoot.querySelector('div.slds-theme_error');

        expect(successDiv).not.toBeNull();
        expect(successDiv.textContent).toContain('Total des Commandes : 1500');
        expect(errorDiv).toBeNull();
    });

    it("affiche l'erreur quand Apex retourne 0", async () => {
        const element = createElement('c-orders', {
            is: Orders
        });
        element.recordId = '001000000000002AAA';

        document.body.appendChild(element);

        getSumOrdersByAccountAdapter.emit(0);
        await flushPromises();

        const successDiv = element.shadowRoot.querySelector(
            'div.slds-theme_success'
        );
        const errorDiv = element.shadowRoot.querySelector('div.slds-theme_error');

        expect(errorDiv).not.toBeNull();
        expect(errorDiv.textContent).toContain(
            "Erreur, pas de commandes rattachées à ce compte"
        );
        expect(successDiv).toBeNull();
    });

    it("affiche l'erreur quand Apex renvoie une erreur", async () => {
        const element = createElement('c-orders', {
            is: Orders
        });
        element.recordId = '001000000000003AAA';

        document.body.appendChild(element);

        getSumOrdersByAccountAdapter.error();
        await flushPromises();

        const successDiv = element.shadowRoot.querySelector(
            'div.slds-theme_success'
        );
        const errorDiv = element.shadowRoot.querySelector('div.slds-theme_error');

        expect(errorDiv).not.toBeNull();
        expect(successDiv).toBeNull();
    });
});