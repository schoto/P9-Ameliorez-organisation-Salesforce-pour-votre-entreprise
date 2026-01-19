// Classe utilitaire pour créer des données de test
// Facilite la création de données de test réutilisables dans les classes de test
@isTest
public class TestDataFactory {
    
    // Crée un compte de test
    // withInsert : true pour insérer directement en base, false pour retourner l'objet non inséré
    public static Account createAccount(String name, Boolean withInsert) {
        Account acc = new Account(Name = name);
        if (withInsert) {
            insert acc;
        }
        return acc;
    }
    
    // Crée plusieurs comptes de test
    // count : nombre de comptes à créer
    public static List<Account> createAccounts(Integer count, Boolean withInsert) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(createAccount('Test Account ' + i, false));
        }
        if (withInsert) {
            insert accounts;
        }
        return accounts;
    }
    
    // Crée un produit de test
    public static Product2 createProduct(String name, String family, Boolean withInsert) {
        Product2 prod = new Product2(Name = name, Family = family, IsActive = true);
        if (withInsert) {
            insert prod;
        }
        return prod;
    }
    
    // Crée une entrée de catalogue de prix (PricebookEntry) de test
    // Utilise le catalogue de prix standard de Salesforce
    public static PricebookEntry createPricebookEntry(Id productId, Decimal unitPrice, Boolean withInsert) {
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productId,
            UnitPrice = unitPrice,
            IsActive = true
        );
        if (withInsert) {
            insert pbe;
        }
        return pbe;
    }
    
    // Crée une commande de test
    // Note : TotalAmount est calculé automatiquement par Salesforce à partir des OrderItems
    // effectiveDate : date d'effet (par défaut aujourd'hui si null)
    public static Order createOrder(Id accountId, String status, Decimal totalAmount, 
                                     Decimal shipmentCost, Date effectiveDate, Boolean withInsert) {
        if (effectiveDate == null) {
            effectiveDate = Date.today();
        }
        
        Order ord = new Order(
            AccountId = accountId,
            Status = status,
            ShipmentCost__c = shipmentCost,
            EffectiveDate = effectiveDate,
            Pricebook2Id = Test.getStandardPricebookId()
        );
        
        if (withInsert) {
            insert ord;
        }
        return ord;
    }
    
    // Crée plusieurs commandes de test pour un compte
    // Les montants sont incrémentés automatiquement (1000, 1100, 1200, etc.)
    public static List<Order> createOrders(Id accountId, Integer count, String status, Boolean withInsert) {
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < count; i++) {
            orders.add(createOrder(accountId, status, 1000 + (i * 100), 50, Date.today(), false));
        }
        if (withInsert) {
            insert orders;
        }
        return orders;
    }
    
    // Crée un scénario complet de test avec compte, produit, prix, commande et lignes de commande
    // Retourne une map contenant tous les objets créés pour faciliter leur utilisation dans les tests
    public static Map<String, SObject> createCompleteOrderScenario(String orderStatus, 
                                                                    Decimal orderTotalAmount, 
                                                                    Integer numberOfOrderItems) {
        Map<String, SObject> testData = new Map<String, SObject>();
        
        // Crée le compte
        Account acc = createAccount('Test Account', true);
        testData.put('Account', acc);
        
        // Crée le produit
        Product2 prod = createProduct('Test Product', 'Test Family', true);
        testData.put('Product', prod);
        
        // Crée l'entrée de catalogue de prix
        PricebookEntry pbe = createPricebookEntry(prod.Id, 100, true);
        testData.put('PricebookEntry', pbe);
        
        // Crée la commande (sans TotalAmount, il sera calculé automatiquement)
        Order ord = createOrder(acc.Id, orderStatus, 0, 50, Date.today(), true);
        testData.put('Order', ord);
        
        // Crée les lignes de commande
        // Le prix unitaire est calculé pour que le total corresponde à orderTotalAmount
        List<OrderItem> orderItems = new List<OrderItem>();
        Decimal unitPrice = (orderTotalAmount - 50) / numberOfOrderItems;
        for (Integer i = 0; i < numberOfOrderItems; i++) {
            OrderItem oi = new OrderItem(
                OrderId = ord.Id,
                PricebookEntryId = pbe.Id,
                Quantity = 1,
                UnitPrice = unitPrice
            );
            orderItems.add(oi);
        }
        insert orderItems;
        // Met à jour la commande pour recalculer TotalAmount
        ord = [SELECT TotalAmount FROM Order WHERE Id = :ord.Id];
        
        return testData;
    }
}
