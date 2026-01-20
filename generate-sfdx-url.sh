#!/bin/bash
# Script bash pour générer l'URL SFDX pour GitHub Secrets
# Remplacez les valeurs ci-dessous par vos informations

USERNAME="VOTRE_USERNAME"  # Exemple: schoto.9a2e8a817969@agentforce.com
PASSWORD="VOTRE_MOT_DE_PASSE"  # Votre mot de passe Salesforce
SECURITY_TOKEN="VOTRE_SECURITY_TOKEN"  # Le token reçu par email
LOGIN_URL="https://login.salesforce.com"  # Ou https://test.salesforce.com pour sandbox

# Génère l'URL SFDX
SFDX_URL="force://PlatformCLI::${SECURITY_TOKEN}@${LOGIN_URL}?username=${USERNAME}&password=${PASSWORD}"

echo "========================================="
echo "URL SFDX pour GitHub Secret SF_LOGIN_URL"
echo "========================================="
echo ""
echo "$SFDX_URL"
echo ""
echo "========================================="
echo "Valeurs pour GitHub Secrets:"
echo "========================================="
echo ""
echo "SF_USERNAME: $USERNAME"
echo "SF_PASSWORD: $PASSWORD"
echo "SF_SECURITY_TOKEN: $SECURITY_TOKEN"
echo "SF_LOGIN_URL: $SFDX_URL"
echo ""
echo "⚠️  Copiez ces valeurs et ajoutez-les dans GitHub Secrets!"
