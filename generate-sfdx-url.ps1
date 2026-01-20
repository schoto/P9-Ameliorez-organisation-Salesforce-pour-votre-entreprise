# Script PowerShell pour générer l'URL SFDX pour GitHub Secrets
# ⚠️ REMPLACEZ les valeurs ci-dessous par vos informations

$username = "VOTRE_USERNAME"  # Exemple: votre.email@example.com
$password = "VOTRE_MOT_DE_PASSE"  # ⚠️ REMPLACEZ PAR VOTRE VRAI MOT DE PASSE
$securityToken = "VOTRE_SECURITY_TOKEN"  # ⚠️ REMPLACEZ PAR VOTRE TOKEN
$loginUrl = "https://login.salesforce.com"

# Génère l'URL SFDX
$sfdxUrl = "force://PlatformCLI::${securityToken}@${loginUrl}?username=${username}&password=${password}"

Write-Host "=========================================" -ForegroundColor Green
Write-Host "URL SFDX pour GitHub Secret SF_LOGIN_URL" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host $sfdxUrl -ForegroundColor Yellow
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "Valeurs pour GitHub Secrets:" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "SF_USERNAME: $username" -ForegroundColor Cyan
Write-Host "SF_PASSWORD: $password" -ForegroundColor Cyan
Write-Host "SF_SECURITY_TOKEN: $securityToken" -ForegroundColor Cyan
Write-Host "SF_LOGIN_URL: $sfdxUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  Copiez ces valeurs et ajoutez-les dans GitHub Secrets!" -ForegroundColor Red
