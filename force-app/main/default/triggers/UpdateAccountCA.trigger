// Trigger qui met à jour le chiffre d'affaires du compte après activation d'une commande
// Délègue la logique à AccountRevenueHandler pour respecter les bonnes pratiques
trigger UpdateAccountCA on Order (after update) {
    AccountRevenueHandler.updateAccountRevenue(Trigger.new, Trigger.oldMap);
}