// Classe batch pour mettre à jour le chiffre d'affaires de tous les comptes
// Utilisée pour la migration de données ou la mise à jour en masse
global class UpdateAllAccounts implements Database.Batchable<sObject> {
    
    // Méthode start : définit la requête pour récupérer les comptes à traiter
    // Ne récupère que les comptes ayant au moins une commande activée
    global Database.QueryLocator start(Database.BatchableContext info) {
        return Database.getQueryLocator([
            SELECT Id, Chiffre_d_affaire__c 
            FROM Account 
            WHERE Id IN (
                SELECT AccountId 
                FROM Order 
                WHERE Status = 'Activated' 
                AND AccountId != null
            )
        ]);
    }
     
    // Méthode execute : traite un lot de comptes
    // Calcule le chiffre d'affaires pour chaque compte et le met à jour
    global void execute(Database.BatchableContext info, List<Account> scope) {
        // Récupère les IDs des comptes du lot actuel
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : scope) {
            accountIds.add(acc.Id);
        }
        
        // Requête agrégée pour calculer la somme des TotalAmount par compte
        // Optimise les performances en utilisant une seule requête au lieu de plusieurs
        List<AggregateResult> orderTotals = [
            SELECT AccountId, SUM(TotalAmount) totalRevenue
            FROM Order
            WHERE AccountId IN :accountIds
            AND Status = 'Activated'
            AND TotalAmount != null
            GROUP BY AccountId
        ];
        
        // Crée une map pour associer chaque compte à son chiffre d'affaires total
        Map<Id, Decimal> accountRevenueMap = new Map<Id, Decimal>();
        for (AggregateResult ar : orderTotals) {
            Id accountId = (Id)ar.get('AccountId');
            Decimal totalRevenue = (Decimal)ar.get('totalRevenue');
            accountRevenueMap.put(accountId, totalRevenue);
        }
        
        // Met à jour le champ Chiffre_d_affaire__c pour chaque compte
        List<Account> accountsToUpdate = new List<Account>();
        for (Account acc : scope) {
            Decimal newRevenue = accountRevenueMap.get(acc.Id);
            if (newRevenue != null) {
                acc.Chiffre_d_affaire__c = newRevenue;
                accountsToUpdate.add(acc);
            }
        }
        
        // Mise à jour groupée des comptes (bulk)
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }    
     
    // Méthode finish : appelée après le traitement de tous les lots
    // Peut être utilisée pour envoyer des notifications ou des logs
    global void finish(Database.BatchableContext info) {
    } 
}