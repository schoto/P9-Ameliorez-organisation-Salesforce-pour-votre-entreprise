# Projet 9: Optimisez un backend Apex

## Prérequis
Avant de commencer, assurez-vous d’avoir :
- Un compte Salesforce valide avec un environnement sandbox ou de développement.
- Les autorisations nécessaires pour créer des objets personnalisés et déployer des packages.
- Git installé sur votre machine pour cloner le projet.

## Installation

### 1. Cloner le dépôt
Commencez par cloner ce dépôt GitHub sur votre machine locale.

```bash
git clone https://github.com/[votre-utilisateur]/[votre-repo].git
cd [votre-repo]
```

### 2. Connexion à votre environnement Salesforce
En Salesforce DX, connectez-vous à votre organisation Salesforce.

```bash
sfdx force:auth:web:login -d -a [nom-de-votre-org]
```

### 3. Déployer le projet sur Salesforce
Une fois connecté, vous pouvez déployer le projet dans votre environnement Salesforce en exécutant la commande suivante :

```bash
sfdx force:source:push
```

### 4. Vérification des objets
Après le déploiement, connectez-vous à votre organisation Salesforce et vérifiez que les objets personnalisés pour les **clients** et **produits** sont créés.

## Utilisation
- Accédez aux objets **Clients** et **Produits** via votre environnement Salesforce pour effectuer des opérations CRUD.
- Vous pouvez également accéder aux informations via des composants Lightning si nécessaire.

## Ressources supplémentaires
- [Salesforce Developer Documentation](https://developer.salesforce.com/docs)
- [Guide d'utilisation de Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli)

