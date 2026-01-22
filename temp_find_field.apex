// Trouve le nom exact du champ
Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Account.fields.getMap();
System.debug('=== RECHERCHE DU CHAMP ===');
for (String fieldName : fieldMap.keySet()) {
    Schema.SObjectField field = fieldMap.get(fieldName);
    Schema.DescribeFieldResult fieldDesc = field.getDescribe();
    String label = fieldDesc.getLabel().toLowerCase();
    String name = fieldName.toLowerCase();
    if (label.contains('chiffre') || label.contains('affaire') || name.contains('chiffre') || name.contains('affaire')) {
        System.debug('✅ TROUVÉ: ' + fieldName + ' | Label: ' + fieldDesc.getLabel() + ' | Type: ' + fieldDesc.getType());
    }
}
System.debug('=== FIN RECHERCHE ===');
