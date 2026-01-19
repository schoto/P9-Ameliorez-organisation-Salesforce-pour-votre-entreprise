// Classe de test pour le trigger CalculMontant
// Teste le calcul du montant net (NetAmount__c) lors de la mise à jour des commandes
@isTest
private class CalculMontantTest {
    
    // Test : calcul du montant net pour une seule commande
    // NetAmount = TotalAmount - ShipmentCost
    @isTest
    static void testCalculMontant_SingleOrder() {
        Account acc = TestDataFactory.createAccount('Test Account', true);
        Product2 prod = TestDataFactory.createProduct('Test Product', 'Test', true);
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100, true);
        Order ord = TestDataFactory.createOrder(acc.Id, 'Draft', 0, 50, Date.today(), true);
        
        // Crée un OrderItem pour que TotalAmount soit calculé automatiquement
        OrderItem oi = new OrderItem(
            OrderId = ord.Id,
            PricebookEntryId = pbe.Id,
            Quantity = 15,
            UnitPrice = 100
        );
        insert oi;
        
        // Récupère la commande avec le TotalAmount calculé
        ord = [SELECT TotalAmount FROM Order WHERE Id = :ord.Id];
        
        Test.startTest();
        // Modifie seulement ShipmentCost pour déclencher le calcul de NetAmount
        ord.ShipmentCost__c = 100;
        update ord;
        Test.stopTest();
        
        // Vérifie que NetAmount = 1500 - 100 = 1400
        Order ordAfter = [SELECT NetAmount__c, TotalAmount FROM Order WHERE Id = :ord.Id];
        System.assertEquals(ordAfter.TotalAmount - 100, ordAfter.NetAmount__c);
    }
    
    // Test : calcul du montant net en traitement bulk (plusieurs commandes)
    // Vérifie que toutes les commandes sont traitées, pas seulement la première
    @isTest
    static void testCalculMontant_BulkProcessing() {
        Account acc = TestDataFactory.createAccount('Test Account', true);
        Product2 prod = TestDataFactory.createProduct('Test Product', 'Test', true);
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100, true);
        
        // Crée plusieurs commandes avec OrderItems pour avoir des TotalAmount différents
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < 5; i++) {
            Order ord = TestDataFactory.createOrder(acc.Id, 'Draft', 0, 50, Date.today(), true);
            OrderItem oi = new OrderItem(
                OrderId = ord.Id,
                PricebookEntryId = pbe.Id,
                Quantity = 10 + i,
                UnitPrice = 100
            );
            insert oi;
            orders.add(ord);
        }
        
        // Récupère les commandes avec TotalAmount calculé
        orders = [SELECT Id, TotalAmount FROM Order WHERE Id IN :orders];
        
        Test.startTest();
        // Modifie seulement ShipmentCost pour toutes les commandes
        for (Order ord : orders) {
            ord.ShipmentCost__c = 50;
        }
        update orders;
        Test.stopTest();
        
        // Vérifie que le NetAmount est calculé correctement pour chaque commande
        List<Order> ordersAfter = [SELECT NetAmount__c, TotalAmount, ShipmentCost__c FROM Order WHERE Id IN :orders];
        for (Order ord : ordersAfter) {
            System.assertEquals(ord.TotalAmount - ord.ShipmentCost__c, ord.NetAmount__c);
        }
    }
}
