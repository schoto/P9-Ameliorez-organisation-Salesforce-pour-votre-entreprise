// Classe de test pour AccountRevenueHandler
// Teste la mise à jour du chiffre d'affaires des comptes lors de l'activation des commandes
@isTest
private class AccountRevenueHandlerTest {
    
    // Test : mise à jour du CA avec une seule commande activée
    @isTest
    static void testUpdateAccountRevenue_SingleOrder() {
        Account acc = TestDataFactory.createAccount('Test Account', true);
        Order ord = TestDataFactory.createOrder(acc.Id, 'Draft', 1000, 50, Date.today(), true);
        
        Test.startTest();
        // Active la commande pour déclencher le trigger
        ord.Status = 'Activated';
        update ord;
        Test.stopTest();
        
        // Vérifie que le chiffre d'affaires a été mis à jour
        Account accAfter = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1000, accAfter.Chiffre_d_affaire__c);
    }
    
    // Test : mise à jour du CA avec plusieurs commandes activées en même temps
    @isTest
    static void testUpdateAccountRevenue_MultipleOrders() {
        Account acc = TestDataFactory.createAccount('Test Account', true);
        Order ord1 = TestDataFactory.createOrder(acc.Id, 'Draft', 1000, 50, Date.today(), true);
        Order ord2 = TestDataFactory.createOrder(acc.Id, 'Draft', 2000, 50, Date.today(), true);
        Order ord3 = TestDataFactory.createOrder(acc.Id, 'Draft', 3000, 50, Date.today(), true);
        
        Test.startTest();
        // Active toutes les commandes en bulk
        ord1.Status = 'Activated';
        ord2.Status = 'Activated';
        ord3.Status = 'Activated';
        update new List<Order>{ord1, ord2, ord3};
        Test.stopTest();
        
        // Vérifie que le CA est la somme de toutes les commandes (1000 + 2000 + 3000 = 6000)
        Account accAfter = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(6000, accAfter.Chiffre_d_affaire__c);
    }
    
    // Test : seules les commandes activées sont comptabilisées
    @isTest
    static void testUpdateAccountRevenue_OnlyActivatedStatus() {
        Account acc = TestDataFactory.createAccount('Test Account', true);
        Order ord1 = TestDataFactory.createOrder(acc.Id, 'Draft', 1000, 50, Date.today(), true);
        Order ord2 = TestDataFactory.createOrder(acc.Id, 'Draft', 2000, 50, Date.today(), true);
        
        Test.startTest();
        // Active seulement la première commande, laisse la seconde en Draft
        ord1.Status = 'Activated';
        ord2.Status = 'Draft';
        update new List<Order>{ord1, ord2};
        Test.stopTest();
        
        // Vérifie que seul le montant de la commande activée est comptabilisé
        Account accAfter = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(1000, accAfter.Chiffre_d_affaire__c);
    }
}
