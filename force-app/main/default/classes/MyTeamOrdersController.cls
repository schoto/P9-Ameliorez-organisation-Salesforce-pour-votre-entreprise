// Contrôleur Apex pour le composant LWC Orders
// Fournit les méthodes pour récupérer les totaux des commandes par compte
public with sharing class MyTeamOrdersController {
    
    // Retourne la somme des montants totaux des commandes activées pour un compte donné
    // Méthode cacheable pour optimiser les performances (mise en cache côté client)
    @AuraEnabled(cacheable=true)
    public static Decimal getSumOrdersByAccount(Id accountId) {
        // Vérifie que l'ID du compte est valide
        if (accountId == null) {
            return 0;
        }
        
        // Requête agrégée pour calculer la somme des TotalAmount
        // Filtre uniquement les commandes activées du compte
        List<AggregateResult> groupedResults = [
            SELECT SUM(TotalAmount) total 
            FROM Order 
            WHERE AccountId = :accountId 
            AND Status = 'Activated'
        ];
        
        // Retourne 0 si aucune commande activée n'existe
        if (groupedResults.isEmpty() || groupedResults[0].get('total') == null) {
            return 0;
        }
        
        // Retourne le total calculé
        return (Decimal)groupedResults[0].get('total');
    }
}