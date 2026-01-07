// Classe de test pour vérifier le scénario complet de création de commande
// Utilise TestDataFactory pour créer un scénario complet avec compte, produit, commande et lignes
@isTest
private class testUpdateAllAccounts {

    // Test : scénario complet avec une commande activée
    // Vérifie que le trigger met à jour automatiquement le CA du compte
    @isTest 
    static void testCompleteOrderScenario() {
        // Crée un scénario complet : compte, produit, prix, commande activée avec 2 lignes
        Map<String, SObject> testData = TestDataFactory.createCompleteOrderScenario('Activated', 21500, 2);
        
        Account acc1 = (Account)testData.get('Account');
        Order o1 = (Order)testData.get('Order');
        
        // Vérifie que la commande a été créée avec le bon statut
        System.assertNotEquals(null, o1.Id);
        System.assertEquals('Activated', o1.Status);
        
        // Vérifie que le trigger a mis à jour le CA du compte automatiquement
        Account accAfter = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        System.assertEquals(21500, accAfter.Chiffre_d_affaire__c);
    }
}