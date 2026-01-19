// Classe de test pour vérifier le scénario complet de création de commande
// Utilise TestDataFactory pour créer un scénario complet avec compte, produit, commande et lignes
@isTest
private class testUpdateAllAccounts {

    // Test : scénario complet avec une commande activée
    // Vérifie que le trigger met à jour automatiquement le CA du compte
    @isTest 
    static void testCompleteOrderScenario() {
        // Crée un scénario complet : compte, produit, prix, commande en Draft avec 2 lignes
        // Note: orderTotalAmount = 21500, mais TotalAmount réel sera 21450 (21500 - 50 ShipmentCost)
        Map<String, SObject> testData = TestDataFactory.createCompleteOrderScenario('Draft', 21500, 2);
        
        Account acc1 = (Account)testData.get('Account');
        Order o1 = (Order)testData.get('Order');
        
        // Récupère le TotalAmount réel de la commande (après création des OrderItems)
        o1 = [SELECT TotalAmount, Status FROM Order WHERE Id = :o1.Id];
        Decimal expectedRevenue = o1.TotalAmount; // Utilise le TotalAmount réel
        
        // Active la commande pour déclencher le trigger
        o1.Status = 'Activated';
        update o1;
        
        // Vérifie que la commande a été activée
        System.assertNotEquals(null, o1.Id);
        Order o1After = [SELECT Status FROM Order WHERE Id = :o1.Id];
        System.assertEquals('Activated', o1After.Status);
        
        // Vérifie que le trigger a mis à jour le CA du compte automatiquement
        // Le CA doit être égal au TotalAmount de la commande (pas orderTotalAmount qui inclut ShipmentCost)
        Account accAfter = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        System.assertEquals(expectedRevenue, accAfter.Chiffre_d_affaire__c, 'Le CA doit être égal au TotalAmount de la commande activée');
    }
}