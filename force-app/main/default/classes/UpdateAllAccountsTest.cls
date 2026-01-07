// Classe de test pour UpdateAllAccounts batch
// Teste le processus batch qui met à jour le chiffre d'affaires de tous les comptes
@isTest
private class UpdateAllAccountsTest {
    
    // Test : exécution du batch avec plusieurs comptes ayant des commandes activées
    @isTest
    static void testUpdateAllAccounts_BatchExecution() {
        List<Account> accounts = TestDataFactory.createAccounts(3, true);
        
        // Crée des commandes activées pour chaque compte avec des montants différents
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < accounts.size(); i++) {
            orders.add(TestDataFactory.createOrder(accounts[i].Id, 'Activated', 1000 * (i + 1), 50, Date.today(), false));
        }
        insert orders;
        
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
        // Crée des commandes avec différents statuts
        TestDataFactory.createOrder(accounts[0].Id, 'Activated', 1000, 50, Date.today(), true);
        TestDataFactory.createOrder(accounts[1].Id, 'Draft', 2000, 50, Date.today(), true);
        TestDataFactory.createOrder(accounts[2].Id, 'Activated', 3000, 50, Date.today(), true);
        
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
