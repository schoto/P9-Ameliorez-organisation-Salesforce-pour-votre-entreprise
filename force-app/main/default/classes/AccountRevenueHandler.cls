// Classe handler pour mettre à jour le chiffre d'affaires des comptes
// Gère la logique métier de manière bulk pour éviter les SOQL/DML dans les boucles
public with sharing class AccountRevenueHandler {
    
    // Met à jour le chiffre d'affaires des comptes lorsque des commandes sont activées
    // Ne traite que les commandes dont le statut passe à 'Activated'
    public static void updateAccountRevenue(List<Order> newOrders, Map<Id, Order> oldOrders) {
        // Ensemble des IDs de comptes à mettre à jour
        Set<Id> accountIds = new Set<Id>();
        // Map pour agréger les montants par compte (évite les requêtes multiples)
        Map<Id, Decimal> accountRevenueMap = new Map<Id, Decimal>();
        
        // Parcourt toutes les commandes mises à jour
        for (Order newOrder : newOrders) {
            Order oldOrder = oldOrders != null ? oldOrders.get(newOrder.Id) : null;
            
            // Vérifie si la commande vient d'être activée (statut changé vers 'Activated')
            if (newOrder.Status == 'Activated' && 
                (oldOrder == null || oldOrder.Status != 'Activated') &&
                newOrder.AccountId != null &&
                newOrder.TotalAmount != null) {
                
                accountIds.add(newOrder.AccountId);
                
                // Agrège les montants par compte (plusieurs commandes peuvent être activées en même temps)
                if (accountRevenueMap.containsKey(newOrder.AccountId)) {
                    accountRevenueMap.put(newOrder.AccountId, 
                        accountRevenueMap.get(newOrder.AccountId) + newOrder.TotalAmount);
                } else {
                    accountRevenueMap.put(newOrder.AccountId, newOrder.TotalAmount);
                }
            }
        }
        
        // Sort si aucune commande n'a été activée
        if (accountIds.isEmpty()) {
            return;
        }
        
        // Requête unique pour récupérer tous les comptes concernés (bulk)
        List<Account> accountsToUpdate = [
            SELECT Id, Chiffre_d_affaire_c 
            FROM Account 
            WHERE Id IN :accountIds
        ];
        
        // Met à jour le chiffre d'affaires de chaque compte
        for (Account acc : accountsToUpdate) {
            Decimal currentRevenue = acc.Chiffre_d_affaire_c != null ? acc.Chiffre_d_affaire_c : 0;
            Decimal additionalRevenue = accountRevenueMap.get(acc.Id);
            acc.Chiffre_d_affaire_c = currentRevenue + additionalRevenue;
        }
        
        // Mise à jour groupée de tous les comptes (bulk)
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
