// Classe de test pour UpdateAllAccounts batch
// Teste le processus batch qui met à jour le chiffre d'affaires de tous les comptes
@isTest
private class UpdateAllAccountsTest {
    
    // Test : exécution du batch avec plusieurs comptes ayant des commandes activées
    @isTest
    static void testUpdateAllAccounts_BatchExecution() {
        List<Account> accounts = TestDataFactory.createAccounts(3, true);
        Product2 prod = TestDataFactory.createProduct('Test Product', 'Test', true);
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100, true);
        
        // Crée des commandes en Draft pour chaque compte avec des montants différents
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < accounts.size(); i++) {
            orders.add(TestDataFactory.createOrder(accounts[i].Id, 'Draft', 0, 50, Date.today(), false));
        }
        insert orders;
        
        // Crée des OrderItems pour que TotalAmount soit calculé
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Integer i = 0; i < orders.size(); i++) {
            orderItems.add(new OrderItem(
                OrderId = orders[i].Id,
                PricebookEntryId = pbe.Id,
                Quantity = 10 * (i + 1),
                UnitPrice = 100
            ));
        }
        insert orderItems;
        
        // Active toutes les commandes
        for (Order ord : orders) {
            ord.Status = 'Activated';
        }
        update orders;
        
        Test.startTest();
        // Exécute le batch
        UpdateAllAccounts batch = new UpdateAllAccounts();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Vérifie que le CA a été mis à jour correctement pour chaque compte
        List<Account> accountsAfter = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts ORDER BY Id];
        System.assertEquals(1000, accountsAfter[0].Chiffre_d_affaire__c);
        System.assertEquals(2000, accountsAfter[1].Chiffre_d_affaire__c);
        System.assertEquals(3000, accountsAfter[2].Chiffre_d_affaire__c);
    }
    
    // Test : seuls les comptes avec des commandes activées sont mis à jour
    @isTest
    static void testUpdateAllAccounts_OnlyAccountsWithActivatedOrders() {
        List<Account> accounts = TestDataFactory.createAccounts(3, true);
        Product2 prod = TestDataFactory.createProduct('Test Product', 'Test', true);
        PricebookEntry pbe = TestDataFactory.createPricebookEntry(prod.Id, 100, true);
        
        // Crée des commandes en Draft
        Order ord1 = TestDataFactory.createOrder(accounts[0].Id, 'Draft', 0, 50, Date.today(), true);
        Order ord2 = TestDataFactory.createOrder(accounts[1].Id, 'Draft', 0, 50, Date.today(), true);
        Order ord3 = TestDataFactory.createOrder(accounts[2].Id, 'Draft', 0, 50, Date.today(), true);
        
        // Crée des OrderItems pour que TotalAmount soit calculé
        insert new List<OrderItem>{
            new OrderItem(OrderId = ord1.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 100),
            new OrderItem(OrderId = ord2.Id, PricebookEntryId = pbe.Id, Quantity = 20, UnitPrice = 100),
            new OrderItem(OrderId = ord3.Id, PricebookEntryId = pbe.Id, Quantity = 30, UnitPrice = 100)
        };
        
        // Active seulement les commandes 1 et 3
        ord1.Status = 'Activated';
        ord3.Status = 'Activated';
        update new List<Order>{ord1, ord3};
        
        Test.startTest();
        UpdateAllAccounts batch = new UpdateAllAccounts();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Vérifie que seul le compte avec commande activée a été mis à jour
        List<Account> accountsAfter = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id IN :accounts ORDER BY Id];
        System.assertEquals(1000, accountsAfter[0].Chiffre_d_affaire__c); // Activée
        System.assertEquals(null, accountsAfter[1].Chiffre_d_affaire__c); // Draft, non mise à jour
        System.assertEquals(3000, accountsAfter[2].Chiffre_d_affaire__c); // Activée
    }
}
