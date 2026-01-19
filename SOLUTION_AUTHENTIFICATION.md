# Solution Authentification Salesforce

## Le problème
Le CLI Salesforce essaie toujours d'utiliser un refresh token expiré, même après nettoyage.

## La solution qui fonctionne à 100%

### Option 1 : Créer un Connected App (RECOMMANDÉ)

1. Dans Salesforce : Setup → App Manager → New Connected App
2. Remplissez :
   - Connected App Name: `GitHub Actions CI/CD`
   - API Name: `GitHub_Actions_CI_CD`
   - Enable OAuth Settings: ✅
   - Callback URL: `http://localhost:1717/OauthRedirect`
   - Selected OAuth Scopes: 
     - `Access and manage your data (api)`
     - `Perform requests on your behalf at any time (refresh_token, offline_access)`
3. Sauvegardez
4. Copiez le **Consumer Key** et **Consumer Secret**
5. Ajoutez dans GitHub Secrets :
   - `SF_CONSUMER_KEY` = Consumer Key
   - `SF_CONSUMER_SECRET` = Consumer Secret

### Option 2 : Activer SOAP API

1. Dans Salesforce : Setup → API → Enable SOAP API
2. Le workflow utilisera alors l'API SOAP

## Après configuration

Une fois le Connected App créé, le workflow utilisera ces credentials pour s'authentifier sans problème de refresh token.
