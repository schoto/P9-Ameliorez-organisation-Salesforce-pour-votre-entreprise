// Classe de test pour le trigger CalculMontant
// Teste le calcul du montant net (NetAmount__c) lors de la mise à jour des commandes
@isTest
private class CalculMontantTest {
    
    // Test : calcul du montant net pour une seule commande
    // NetAmount = TotalAmount - ShipmentCost
    @isTest
    static void testCalculMontant_SingleOrder() {
        Account acc = TestDataFactory.createAccount('Test Account', true);
        Order ord = TestDataFactory.createOrder(acc.Id, 'Draft', 1000, 50, Date.today(), true);
        
        Test.startTest();
        // Modifie les montants pour déclencher le calcul
        ord.TotalAmount = 1500;
        ord.ShipmentCost__c = 100;
        update ord;
        Test.stopTest();
        
        // Vérifie que NetAmount = 1500 - 100 = 1400
        Order ordAfter = [SELECT NetAmount__c FROM Order WHERE Id = :ord.Id];
        System.assertEquals(1400, ordAfter.NetAmount__c);
    }
    
    // Test : calcul du montant net en traitement bulk (plusieurs commandes)
    // Vérifie que toutes les commandes sont traitées, pas seulement la première
    @isTest
    static void testCalculMontant_BulkProcessing() {
        Account acc = TestDataFactory.createAccount('Test Account', true);
        List<Order> orders = TestDataFactory.createOrders(acc.Id, 5, 'Draft', true);
        
        Test.startTest();
        // Modifie les montants de toutes les commandes
        for (Integer i = 0; i < orders.size(); i++) {
            orders[i].TotalAmount = 1000 + (i * 100);
            orders[i].ShipmentCost__c = 50;
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
