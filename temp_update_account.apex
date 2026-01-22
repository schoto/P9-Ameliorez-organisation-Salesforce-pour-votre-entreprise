// Met à jour directement le compte TEST ACCOUNT SOUTENANCE
Id accountId = '001fj00000aWzOcAAK';

Account acc = [SELECT Id, Name, Chiffre_d_affaire__c FROM Account WHERE Id = :accountId];
System.debug('=== COMPTE ===');
System.debug('Account ID: ' + acc.Id);
System.debug('Account Name: ' + acc.Name);
System.debug('Chiffre d\'affaire actuel: ' + acc.Chiffre_d_affaire__c);

// Calcule le total des commandes activées
List<AggregateResult> totals = [
    SELECT SUM(TotalAmount) total
    FROM Order
    WHERE AccountId = :accountId
    AND Status = 'Activated'
    AND TotalAmount != null
];

if (!totals.isEmpty() && totals[0].get('total') != null) {
    Decimal total = (Decimal)totals[0].get('total');
    System.debug('Total calculé des commandes activées: ' + total);
    
    // Met à jour le compte
    acc.Chiffre_d_affaire__c = total;
    update acc;
    
    // Vérifie la mise à jour
    Account accUpdated = [SELECT Chiffre_d_affaire__c FROM Account WHERE Id = :accountId];
    System.debug('✅ Chiffre d\'affaire après mise à jour: ' + accUpdated.Chiffre_d_affaire__c);
} else {
    System.debug('❌ Aucune commande activée avec TotalAmount pour ce compte');
    
    // Liste les commandes pour debug
    List<Order> orders = [
        SELECT Id, Status, TotalAmount 
        FROM Order 
        WHERE AccountId = :accountId
        LIMIT 10
    ];
    System.debug('Commandes trouvées: ' + orders.size());
    for (Order o : orders) {
        System.debug('  - Order: ' + o.Id + ' | Status: ' + o.Status + ' | TotalAmount: ' + o.TotalAmount);
    }
}
