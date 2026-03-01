# Changelog - Evasion Logistique

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

## [Non publié]

### À venir
- Notifications push pour chauffeurs
- Mode hors ligne avec cache local
- Géolocalisation temps réel
- Export PDF personnalisé des rapports

---

## [1.0.0] - 2026-03-01

### Version Initiale

#### Ajouté

**Authentification et Utilisateurs**
- Système d'authentification Supabase avec email/password
- Gestion multi-rôles (Super Admin, Call Center, Logistique, Chauffeur)
- Création et gestion des utilisateurs
- Réinitialisation de mot de passe
- Profils utilisateurs avec permissions

**Gestion des Commandes**
- Création de commandes depuis call center
- Statuts multiples (attente, validée, en_cours, livrée, etc.)
- Système de validation/refus avec commentaires
- Affectation des chauffeurs aux commandes
- Historique complet des commandes
- Filtres et recherche avancée

**Gestion des Clients**
- Base de données clients complète
- Import CSV en masse avec validation
- Édition et modification des clients
- Gestion des statuts clients (actif/inactif)
- Champs détaillés (adresse, téléphone, email, marque, site vendeur)

**Interface Chauffeur**
- Vue liste des livraisons assignées
- Détail de chaque livraison
- Navigation GPS vers adresse client
- Validation de livraison avec statut
- Collecte du montant
- Interface mobile optimisée

**Logistique et Affectation**
- Tableau de bord logistique temps réel
- Affectation des chauffeurs aux commandes
- Vue d'ensemble des chauffeurs disponibles
- Gestion des tournées
- Système de priorités
- Tracking des kilomètres

**Gestion des Chauffeurs**
- Profils chauffeurs détaillés
- Synchronisation automatique avec auth users
- Statut disponibilité
- Historique des livraisons par chauffeur
- Statistiques de performance

**Véhicules**
- Base de données des véhicules
- Association chauffeur-véhicule
- Suivi du kilométrage
- Maintenance et historique

**Système de Tournées**
- Création et gestion des tournées
- Affectation multiple de commandes
- Pauses et temps de trajet
- Optimisation des trajets
- Historique des tournées

**Rapports et Statistiques**
- Dashboard avec métriques clés
- Rapports de livraisons
- Statistiques par chauffeur
- Statistiques par période
- Export des données

**Système d'Annulation**
- Annulation de commandes avec motif
- Suivi des raisons d'annulation
- Réactivation de commandes annulées
- Historique des annulations

**Import/Export**
- Import CSV clients avec validation
- Export CSV des rejets d'import
- Rapport d'import détaillé
- Modèle CSV fourni

#### Sécurité

- Row Level Security (RLS) sur toutes les tables
- Politiques d'accès basées sur les rôles
- Validation des permissions par endpoint
- Trigger automatique de création de profil
- Cascade delete sécurisé
- Protection contre les injections SQL

#### Performance

- Index sur colonnes fréquemment requêtées
- Optimisation des requêtes Supabase
- Cache navigateur pour assets statiques
- Code splitting automatique
- Lazy loading des composants

#### Interface Utilisateur

- Design moderne et responsive
- Thème cohérent avec bleu (#2563eb)
- Navigation intuitive par rôle
- Feedback visuel sur toutes actions
- Messages de confirmation/erreur clairs
- Chargement progressif
- Animations fluides

#### Base de Données

**Tables créées :**
- `profiles` : Profils utilisateurs avec rôles
- `clients` : Base clients
- `commandes` : Commandes et livraisons
- `chauffeurs` : Informations chauffeurs
- `vehicules` : Parc véhicule
- `tournees` : Tournées quotidiennes
- `tournee_commandes` : Lien tournée-commande
- `pauses` : Pauses chauffeurs
- `trajets` : Historique trajets
- `rapports_rejets` : Suivi rejets import
- `commandes_annulees` : Historique annulations

**Fonctions SQL :**
- `create_user_with_profile()` : Création utilisateur + profil
- `delete_user_complete()` : Suppression complète utilisateur
- `check_user_permission()` : Vérification permissions

**Triggers :**
- Auto-création profil à l'inscription
- Cascade delete sur suppression utilisateur
- Synchronisation chauffeurs-profiles
- Validation contraintes métier

#### Edge Functions

- `create-user` : Création utilisateur via admin
- `delete-user` : Suppression utilisateur
- `reset-user-password` : Réinitialisation mot de passe
- `send-notification` : Envoi notifications
- `create-payment-link` : Stripe (optionnel)
- `stripe-webhook` : Webhooks Stripe
- `create-test-users` : Génération données test

#### Documentation

- README complet avec guide démarrage
- Guide de déploiement PWA détaillé
- Guide d'interface chauffeur
- Documentation du système d'affectation
- Guide de création d'utilisateurs
- Modèle d'import clients documenté
- Scripts SQL fournis pour tests
- Guide de mise à jour (ce document)

#### Configuration

- Configuration PWA complète
- Manifeste web app
- Variables d'environnement
- Configuration Vercel/Netlify/Firebase
- CORS configuré
- TypeScript strict mode

#### Tests

- Scripts de création utilisateurs test
- Données de test pour développement
- CSV de test pour import
- Commandes et livraisons de test

---

## Notes de Version

### Compatibilité Navigateurs

- Chrome 90+ ✅
- Safari 14+ ✅
- Firefox 88+ ✅
- Edge 90+ ✅
- Safari iOS 14+ ✅
- Chrome Android 90+ ✅

### Compatibilité Mobile

- Responsive design complet
- Interface chauffeur optimisée mobile
- Touch gestures supportés
- PWA installable sur iOS et Android

### Base de Données

- Supabase PostgreSQL 15+
- Toutes les migrations appliquées
- RLS activé sur toutes les tables
- Backup quotidien recommandé

### Variables d'Environnement Requises

```env
EXPO_PUBLIC_SUPABASE_URL=https://votre-projet.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=votre_clé_anonyme
```

### Dépendances Principales

- React 19.1.0
- React Native 0.81.4
- Expo 54.0.10
- Expo Router 6.0.8
- Supabase JS 2.58.0
- TypeScript 5.9.2

---

## Roadmap Future

### Version 1.1.0 (Prochainement)

**Prévu :**
- Notifications push temps réel
- Mode hors ligne avec cache
- Scan QR code pour validation
- Signature client à la livraison
- Photos de preuve de livraison
- Géolocalisation tracking temps réel
- Optimisation automatique des tournées
- Prévision temps de livraison

### Version 1.2.0

**Prévu :**
- Tableau de bord analytique avancé
- Export PDF personnalisable
- Intégration facturation automatique
- Système de notation chauffeurs
- Multi-dépôts
- Planning prévisionnel J+7
- API publique pour intégrations

### Version 2.0.0

**Prévu :**
- Application mobile native (iOS/Android)
- Interface client pour suivi
- Chatbot support client
- IA pour optimisation tournées
- Prédiction de demandes
- Intégration ERP tiers

---

## Comment Contribuer

Si vous ajoutez une fonctionnalité ou corrigez un bug :

1. Incrémentez la version dans `package.json`
2. Ajoutez une entrée dans ce CHANGELOG
3. Créez un tag Git : `git tag -a v1.x.x -m "Description"`
4. Documentez les changements dans la section appropriée

### Format des Entrées

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Ajouté
- Nouvelles fonctionnalités

### Modifié
- Changements de fonctionnalités existantes

### Déprécié
- Fonctionnalités bientôt supprimées

### Supprimé
- Fonctionnalités retirées

### Corrigé
- Corrections de bugs

### Sécurité
- Correctifs de vulnérabilités
```

---

## Support et Contact

Pour toute question sur une version :
- Consulter la documentation dans `/docs`
- Vérifier les guides de démarrage
- Consulter le README.md

**Version actuelle stable : 1.0.0**
**Dernière mise à jour changelog : 2026-03-01**
