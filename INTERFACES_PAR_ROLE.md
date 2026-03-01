# Interfaces Spécifiques par Rôle

Ce document explique les interfaces créées pour chaque rôle dans l'application.

## 🎯 Vue d'ensemble

L'application dispose maintenant de **3 interfaces principales** adaptées à chaque type d'utilisateur :
- **Call Center** : Création de commandes et gestion clients
- **Logistique** : Supervision et optimisation des livraisons
- **Chauffeur** : Gestion des tournées et livraisons

## 📞 Interface Call Center

**Fichier** : `app/(web)/call-center.tsx`

### Fonctionnalités principales :

#### 1. Tableau de bord statistiques
- Commandes du jour
- Commandes en cours
- Commandes livrées
- Commandes reportées

#### 2. Actions rapides
- **Nouvelle Commande** : Créer une livraison (`/commandes/new`)
- **Nouveau Client** : Ajouter un client (`/clients/new`)
- **Planning** : Voir les livraisons planifiées
- **Historique** : Consulter l'historique des statuts

#### 3. Recherche client
- Recherche en temps réel par nom, numéro de compte ou email
- Affichage des informations clients
- Accès rapide au profil client

#### 4. Commandes récentes
- Liste des 5 dernières commandes
- Statuts colorés
- Montants et dates de livraison

### Écrans associés :

#### Nouveau Client (`app/(web)/clients/new.tsx`)
Formulaire complet avec :
- Numéro de compte (unique)
- Nom
- Adresse complète (adresse, code postal, ville)
- Email (optionnel)
- Téléphone (optionnel)
- Validation des données
- Vérification des doublons

#### Historique (`app/(web)/historique.tsx`)
- Historique complet des changements de statuts
- Recherche par numéro de commande ou client
- Affichage des transitions de statuts
- Identification de l'utilisateur ayant effectué le changement

## 🚚 Interface Logistique

**Fichier** : `app/(web)/logistique.tsx`

### Fonctionnalités principales :

#### 1. Supervision en temps réel
Statistiques actualisées automatiquement (toutes les 30 secondes) :
- Commandes en cours
- Commandes livrées
- Commandes reportées
- Nombre de chauffeurs actifs
- Taux de livraison (%)

#### 2. Actions rapides
- **Affectation** : Assigner des chauffeurs
- **Planning** : Voir les tournées
- **Rapports** : Statistiques détaillées
- **Carte** : Suivi GPS (à venir)

#### 3. Alertes commandes reportées
- Liste des commandes avec problèmes
- Accès rapide pour intervention
- Mise en évidence visuelle (bordure rouge)

#### 4. Livraisons en cours
- Vue en temps réel des livraisons actives
- Informations chauffeur
- Statut et localisation
- Montant de la commande

#### 5. Performance chauffeurs
Pour chaque chauffeur :
- Nombre de livraisons du jour
- Nombre de livraisons terminées
- Barre de progression
- Livraisons en cours

### Écrans associés :

#### Rapports (`app/(web)/rapports.tsx`)
Analyses détaillées avec sélection de période (jour/semaine/mois) :

**Statistiques générales :**
- Total commandes
- Commandes livrées
- Commandes reportées
- Taux de réussite

**Performance financière :**
- Montant total livré sur la période

**Équipe :**
- Nombre de chauffeurs actifs
- Moyenne de livraisons par chauffeur

**Répartition par statut :**
- Graphiques en barres
- Détail pour chaque statut
- Pourcentages visuels

## 📱 Interface Chauffeur (Améliorée)

**Fichier** : `app/(driver)/deliveries.tsx`

### Nouvelles fonctionnalités :

#### 1. Statistiques personnelles
- Total de livraisons du jour
- Livraisons en cours
- Livraisons terminées
- Montant total livré

#### 2. Navigation GPS intégrée
- Bouton "Navigation" sur les commandes en livraison
- Ouverture automatique de Google Maps
- Guidage vers l'adresse du client

#### 3. Affichage amélioré
- Design moderne avec cartes colorées
- Badges de statut visuels
- Informations client détaillées
- Montant et mode de paiement

#### 4. Actualisation en temps réel
- Pull-to-refresh
- Mise à jour automatique via Supabase Realtime
- Synchronisation instantanée

## 🧩 Composants Réutilisables

Pour maintenir la cohérence et faciliter la maintenance, j'ai créé des composants réutilisables :

### StatCard (`components/StatCard.tsx`)
Carte de statistique avec :
- Icône personnalisable
- Valeur (nombre ou texte)
- Label
- Couleur de fond

### CommandeCard (`components/CommandeCard.tsx`)
Carte de commande avec :
- Numéro de commande
- Badge de statut coloré
- Informations client
- Montant
- Date de livraison

### ActionCard (`components/ActionCard.tsx`)
Carte d'action rapide avec :
- Icône avec fond coloré
- Titre
- Sous-titre optionnel
- Action au clic

## 🔐 Routing et Permissions

### Redirection automatique

Le dashboard (`app/(web)/dashboard.tsx`) redirige automatiquement vers l'interface appropriée :

```typescript
if (profile?.role === 'call_center') {
  router.replace('/(web)/call-center');
} else if (profile?.role === 'logistique') {
  router.replace('/(web)/logistique');
}
```

### Structure des routes

```
app/
├── (web)/                    # Routes web (call_center, logistique, admin)
│   ├── call-center.tsx      # Interface Call Center
│   ├── logistique.tsx       # Interface Logistique
│   ├── rapports.tsx         # Rapports détaillés
│   ├── historique.tsx       # Historique des statuts
│   ├── clients/
│   │   └── new.tsx          # Création client
│   ├── commandes/
│   │   └── new.tsx          # Création commande (existant)
│   ├── planning.tsx         # Planning (existant)
│   └── affectation.tsx      # Affectation (existant)
│
└── (driver)/                 # Routes chauffeur
    ├── deliveries.tsx        # Liste des livraisons (amélioré)
    ├── delivery/[id].tsx     # Détail livraison (existant)
    └── payment/[id].tsx      # Paiement (existant)
```

## 🎨 Design

### Palette de couleurs

Les interfaces utilisent une palette cohérente :

- **Bleu** (#2563EB) : Actions principales, éléments actifs
- **Vert** (#10B981) : Succès, livraisons complétées
- **Orange** (#F59E0B) : En cours, en attente
- **Rouge** (#EF4444) : Erreurs, reportées
- **Violet** (#8B5CF6) : Statut "chargée"
- **Gris** (#6B7280) : Informations secondaires

### Principes de design

1. **Cohérence** : Même style de cartes et badges partout
2. **Clarté** : Informations importantes bien visibles
3. **Feedback visuel** : Couleurs et icônes explicites
4. **Responsive** : Adapté aux différentes tailles d'écran
5. **Accessibilité** : Bon contraste et tailles de texte adaptées

## 📊 Flux de données

### Temps réel avec Supabase

Les interfaces utilisent Supabase Realtime pour les mises à jour automatiques :

```typescript
const channel = supabase
  .channel('deliveries-changes')
  .on('postgres_changes', {
    event: '*',
    schema: 'public',
    table: 'commandes',
  }, () => {
    fetchDeliveries();
  })
  .subscribe();
```

### Actualisation automatique

- **Logistique** : Toutes les 30 secondes
- **Chauffeur** : En temps réel via Realtime
- **Call Center** : Au chargement et sur action utilisateur

## 🚀 Prochaines étapes suggérées

1. **Carte interactive** : Visualisation GPS des livraisons en cours
2. **Notifications push** : Alertes pour les chauffeurs
3. **Signature électronique** : Preuve de livraison
4. **Scan de documents** : Photos des bons de livraison
5. **Export de rapports** : PDF ou Excel
6. **Optimisation de tournée** : Algorithme de routing
7. **Chat interne** : Communication entre call center et chauffeurs

## 📝 Notes techniques

### Performance

- Pagination des listes longues
- Chargement lazy des images
- Optimisation des requêtes Supabase
- Cache des données fréquentes

### Sécurité

- Vérification des rôles côté serveur (RLS)
- Validation des données
- Protection contre les injections SQL
- Authentification requise pour toutes les routes

### Maintenance

- Code modulaire et réutilisable
- Composants séparés
- Types TypeScript stricts
- Documentation inline
