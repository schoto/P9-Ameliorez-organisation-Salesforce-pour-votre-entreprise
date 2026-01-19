// Classe de test pour MyTeamOrdersController
// Teste la méthode qui retourne la somme des commandes activées d'un compte
@isTest
private class MyTeamOrdersControllerTest {
    
    // Test : retourne la somme de plusieurs commandes activées
    @isTest
    static void testGetSumOrdersByAccount_WithActivatedOrders() {
        Account acc = TestDataFactory.createAccount('Test Account', true);
        Product2 prod = TestDataFactory.createProduct('Test Product', 'Test', true);
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100, true);
        
        Order ord1 = TestDataFactory.createOrder(acc.Id, 'Draft', 0, 50, Date.today(), true);
        Order ord2 = TestDataFactory.createOrder(acc.Id, 'Draft', 0, 50, Date.today(), true);
        
        // Crée des OrderItems pour que TotalAmount soit calculé
        insert new List<OrderItem>{
            new OrderItem(OrderId = ord1.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 100),
            new OrderItem(OrderId = ord2.Id, PricebookEntryId = pbe.Id, Quantity = 20, UnitPrice = 100)
        };
        
        // Active les commandes
        ord1.Status = 'Activated';
        ord2.Status = 'Activated';
        update new List<Order>{ord1, ord2};
        
        Test.startTest();
        Decimal total = MyTeamOrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();
        
        // Vérifie que la somme est correcte (1000 + 2000 = 3000)
        System.assertEquals(3000, total);
    }
    
    // Test : ne compte que les commandes activées, ignore les autres statuts
    @isTest
    static void testGetSumOrdersByAccount_OnlyActivatedOrders() {
        Account acc = TestDataFactory.createAccount('Test Account', true);
        Product2 prod = TestDataFactory.createProduct('Test Product', 'Test', true);
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100, true);
        
        Order ord1 = TestDataFactory.createOrder(acc.Id, 'Draft', 0, 50, Date.today(), true);
        Order ord2 = TestDataFactory.createOrder(acc.Id, 'Draft', 0, 50, Date.today(), true);
        
        // Crée des OrderItems pour que TotalAmount soit calculé
        insert new List<OrderItem>{
            new OrderItem(OrderId = ord1.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 100),
            new OrderItem(OrderId = ord2.Id, PricebookEntryId = pbe.Id, Quantity = 20, UnitPrice = 100)
        };
        
        // Active seulement la première commande
        ord1.Status = 'Activated';
        update ord1;
        
        Test.startTest();
        Decimal total = MyTeamOrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();
        
        // Vérifie que seule la commande activée est comptabilisée (1000, pas 3000)
        System.assertEquals(1000, total);
    }
    
    // Test : retourne 0 si aucune commande n'existe pour le compte
    @isTest
    static void testGetSumOrdersByAccount_NoOrders() {
        Account acc = TestDataFactory.createAccount('Test Account', true);
        
        Test.startTest();
        Decimal total = MyTeamOrdersController.getSumOrdersByAccount(acc.Id);
        Test.stopTest();
        
        // Vérifie que 0 est retourné quand il n'y a pas de commandes
        System.assertEquals(0, total);
    }
}
