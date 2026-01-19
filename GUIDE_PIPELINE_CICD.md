# Guide du Pipeline CI/CD - GitHub Actions

## 📋 Vue d'ensemble

Le pipeline CI/CD automatise les tests et le déploiement de votre code Salesforce vers votre organisation. Il utilise **sfdx-git-delta** pour déployer uniquement les fichiers modifiés, ce qui accélère les déploiements.

**Fichier** : `.github/workflows/main_deploy.yml`

---

## 🔄 Fonctionnement du Pipeline

### Déclencheurs

Le pipeline s'exécute automatiquement quand :
- ✅ Un **push** est fait sur la branche `main`
- ✅ Une **pull request** est créée vers la branche `main`

### Étapes du Pipeline

1. **Checkout code** - Récupère le code depuis GitHub
2. **Setup Node.js** - Configure Node.js 18.x
3. **Install SFDX CLI** - Installe Salesforce CLI et sfdx-git-delta
4. **Authentification** - Se connecte à Salesforce via les secrets GitHub
5. **Generate delta** - Identifie les fichiers modifiés (sfdx-git-delta)
6. **Validate** - Valide les métadonnées (syntaxe, erreurs)
7. **Run Tests** - Exécute les tests Apex (pour les PR)
8. **Deploy** - Déploie sur Salesforce (uniquement sur push vers main)
9. **Coverage Report** - Génère un rapport de couverture

---

## 🔐 Configuration des Secrets GitHub

### Étape 1 : Obtenir les informations Salesforce

1. **SF_USERNAME** : Votre nom d'utilisateur Salesforce
   - Exemple : `schoto.9a2e8a817969@agentforce.com`

2. **SF_PASSWORD** : Votre mot de passe Salesforce

3. **SF_SECURITY_TOKEN** : Token de sécurité
   - ⚙️ > **My Personal Information** > **Reset My Security Token**
   - Vérifiez votre email et copiez le token

4. **SF_LOGIN_URL** : URL de connexion SFDX
   - Format : `force://PlatformCLI::[TOKEN]@[URL]?username=[USERNAME]&password=[PASSWORD]`
   - Utilisez le script `generate-sfdx-url.ps1` pour la générer

### Étape 2 : Ajouter les secrets dans GitHub

1. Allez sur votre dépôt GitHub
2. **Settings** > **Secrets and variables** > **Actions**
3. Cliquez sur **New repository secret**
4. Ajoutez les 4 secrets :
   - `SF_USERNAME`
   - `SF_PASSWORD`
   - `SF_SECURITY_TOKEN`
   - `SF_LOGIN_URL`

---

## 🚀 Utilisation

### Déclencher le pipeline

#### Option 1 : Push sur main
```bash
git add .
git commit -m "Modifications"
git push origin main
```
→ Le pipeline s'exécute automatiquement et **déploie** sur Salesforce

#### Option 2 : Pull Request
1. Créez une branche
2. Faites vos modifications
3. Créez une PR vers `main`
→ Le pipeline **valide** et **teste** (sans déployer)

---

## 📊 Résultats

### Où voir les résultats ?

1. Allez sur votre dépôt GitHub
2. Cliquez sur l'onglet **Actions**
3. Vous verrez tous les workflows exécutés
4. Cliquez sur un workflow pour voir les détails

### Statuts possibles

- ✅ **Succès** (vert) : Tout fonctionne
- ❌ **Échec** (rouge) : Erreur à corriger
- ⚠️ **En cours** (jaune) : En train de s'exécuter

---

## 🔍 Détails Techniques

### sfdx-git-delta

Le plugin **sfdx-git-delta** compare les commits Git et génère un `package.xml` avec uniquement les fichiers modifiés. Cela permet de :
- ⚡ Déployer plus rapidement
- 🎯 Éviter de déployer des fichiers non modifiés
- 🔒 Réduire les risques d'erreurs

### Structure du delta

```
.temp/
└── package/
    ├── package.xml          # Liste des métadonnées modifiées
    └── force-app/           # Fichiers modifiés uniquement
```

---

## ⚠️ Dépannage

### Le pipeline échoue à l'authentification

**Problème** : Les secrets GitHub ne sont pas configurés ou incorrects

**Solution** :
1. Vérifiez que les 4 secrets sont bien ajoutés
2. Vérifiez que `SF_LOGIN_URL` est correctement formatée
3. Utilisez le script `generate-sfdx-url.ps1` pour générer l'URL

### Le pipeline ne détecte pas les changements

**Problème** : sfdx-git-delta ne trouve pas de différences

**Solution** :
- Le pipeline déploiera tout le projet en fallback
- Vérifiez que vous avez bien commité vos changements

### Les tests échouent

**Problème** : Des tests unitaires échouent

**Solution** :
1. Vérifiez les logs dans l'onglet Actions
2. Corrigez les tests localement
3. Re-poussez vos modifications

---

## 📝 Exemple de Logs

```
✅ Métadonnées modifiées détectées
📦 Contenu du package.xml:
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <types>
    <members>AccountRevenueHandler</members>
    <name>ApexClass</name>
  </types>
  <version>60.0</version>
</Package>
🚀 Déploiement des métadonnées modifiées...
✅ Déploiement réussi
```

---

## 🔗 Ressources

- **Documentation sfdx-git-delta** : https://github.com/scolladon/sfdx-git-delta
- **Documentation Salesforce CLI** : https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/
- **Documentation GitHub Actions** : https://docs.github.com/en/actions

---

**Fichier du pipeline** : `.github/workflows/main_deploy.yml`
