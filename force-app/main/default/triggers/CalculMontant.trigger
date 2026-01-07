// Trigger qui calcule le montant net (NetAmount__c) avant la mise à jour de la commande
// NetAmount = TotalAmount - ShipmentCost
// Traite tous les enregistrements en bulk (pas seulement le premier)
trigger CalculMontant on Order (before update) {
    // Parcourt toutes les commandes mises à jour
    for (Order order : Trigger.new) {
        // Gère les valeurs null en les remplaçant par 0
        Decimal totalAmount = order.TotalAmount != null ? order.TotalAmount : 0;
        Decimal shipmentCost = order.ShipmentCost__c != null ? order.ShipmentCost__c : 0;
        // Calcule le montant net
        order.NetAmount__c = totalAmount - shipmentCost;
    }
}