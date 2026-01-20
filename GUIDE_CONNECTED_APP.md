# Guide : Créer un Connected App dans Salesforce

## Option 1 : Connected Apps (Classique) - RECOMMANDÉ

1. **Dans Salesforce** : Setup (roue dentée en haut à droite)
2. **Barre de recherche** : tape `Connected Apps`
3. **Clique sur** : "Connected Apps" (pas External Client Apps)
4. **Clique sur** : "New" (bouton en haut à droite)
5. **Remplis** :
   - **Connected App Name** : `GitHub Actions CI/CD`
   - **API Name** : `GitHub_Actions_CI_CD` (généré automatiquement)
   - **Contact Email** : ton email
   - **Enable OAuth Settings** : ✅ COCHER
   - **Callback URL** : `http://localhost:1717/OauthRedirect`
   - **Selected OAuth Scopes** : 
     - `Full access (full)`
     - `Perform requests on your behalf at any time (refresh_token, offline_access)`
   - **Require Secret for Web Server Flow** : ✅ COCHER
   - **Require Secret for Refresh Token Flow** : ✅ COCHER
6. **Clique sur** : "Save"
7. **Après sauvegarde** : tu verras la page de détails avec :
   - **Consumer Key** (visible directement)
   - **Consumer Secret** (clique sur "Click to reveal")

## Option 2 : External Client Apps (Nouveau)

Si tu as créé un External Client App :

1. **Dans Salesforce** : Setup
2. **Barre de recherche** : `External Client App Manager`
3. **Clique sur** : "External Client App Manager"
4. **Clique sur** : le nom de ton app
5. **Sur la page de détails** : tu devrais voir Consumer Key et Consumer Secret

## Si tu ne vois toujours pas les credentials

- Vérifie que l'app est bien créée (liste des apps)
- Vérifie que "Enable OAuth Settings" est bien coché
- Essaie de créer un **Connected App classique** (Option 1) au lieu d'External Client App
