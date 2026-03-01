# Evasion Logistique - Application de Gestion de Livraisons B2B

Application full-stack PWA pour la gestion de livraisons de pièces automobiles aux garagistes.

> **🌐 Progressive Web App (PWA)** : Cette application fonctionne directement dans le navigateur et peut être installée comme une application native sur tous les appareils (mobile, tablette, desktop).

## 🚀 Fonctionnalités

### Interface Mobile Chauffeurs
- Liste des livraisons du jour
- Détail de chaque commande avec infos client
- Mise à jour des statuts (chargée, en livraison, livrée)
- Paiement CB via QR code (Stripe Payment Links)
- Synchronisation temps réel
- Reporting livraison ratée

### Interface Web Call Center
- Création de nouvelles commandes
- Recherche clients (nom, numéro compte, ville)
- Planification des livraisons
- Vue planning global

### Interface Web Logistique
- Affectation des chauffeurs aux commandes
- Vue planning par date
- Tableau de bord temps réel
- Suivi des statuts

### Gestion des Commandes
- Annulation de commandes avec raison
- Réactivation de commandes annulées
- Historique centralisé avec filtres avancés
- Traçabilité complète de tous les changements

## 📋 Technologies

- **Frontend**: Expo React Native (mobile + web/PWA)
- **Backend**: Supabase (PostgreSQL + Auth + Realtime + Edge Functions)
- **Paiement**: Stripe Payment Links
- **QR Code**: react-native-qrcode-svg
- **Déploiement**: Vercel / Netlify / Firebase Hosting (PWA)

## 🗄️ Structure de la base de données

- **profiles**: Utilisateurs avec rôles (chauffeur, call_center, logistique, admin)
- **clients**: Garagistes clients
- **chauffeurs**: Informations des chauffeurs
- **commandes**: Commandes de livraison
- **historique_statuts**: Traçabilité des changements de statut

## 🔐 Rôles utilisateur

- **chauffeur**: Accès mobile uniquement, voit ses livraisons
- **call_center**: Création de commandes, vue planning
- **logistique**: Affectation chauffeurs, validation planning
- **admin**: Accès complet

## 🚦 Statuts des commandes

1. **planifie**: Commande créée, en attente d'affectation
2. **accepte**: Affectée à un chauffeur
3. **refuse**: Refusée par la logistique
4. **chargee**: Marchandise chargée dans le véhicule
5. **en_livraison**: Chauffeur en route
6. **livree**: Marchandise livrée
7. **payee**: Paiement CB encaissé (si CB à livraison)
8. **reportee**: Livraison reportée
9. **dechargee**: Livraison annulée, marchandise déchargée
10. **annulee**: Commande annulée (n'apparaît plus dans les vues opérationnelles)

## 💳 Flux de paiement

Pour les commandes avec option "CB à livraison":

1. Le chauffeur marque la commande comme "livrée"
2. Un bouton "Encaisser maintenant" apparaît
3. Génération d'un Stripe Payment Link
4. Affichage d'un QR code en plein écran
5. Le client scanne et paie avec son téléphone
6. Le webhook Stripe met à jour le statut en "payee"
7. Animation de confirmation côté chauffeur

## 🛠️ Installation

```bash
npm install
```

## 🔑 Variables d'environnement

Les variables Supabase sont déjà configurées dans `.env` et `app.json`.

Pour Stripe (mode test), les clés sont gérées automatiquement par les Edge Functions Supabase.

## 🏃 Démarrage en développement

```bash
npm run dev
```

L'application démarre sur:
- Mobile: Scanner le QR code avec Expo Go
- Web: http://localhost:8081

## 🚀 Déploiement PWA en production

### Option 1 : Déploiement rapide (2 minutes)

```bash
# Build
npm run build

# Déployer sur Vercel (recommandé)
npm run deploy:vercel
```

Voir le guide complet : **[DEMARRAGE_RAPIDE_PWA.md](./DEMARRAGE_RAPIDE_PWA.md)**

### Option 2 : Autres plateformes

- **Netlify** : `npm run deploy:netlify`
- **Firebase** : `npm run deploy:firebase`

Documentation détaillée : **[DEPLOIEMENT_PWA.md](./DEPLOIEMENT_PWA.md)**

### Avantages de la PWA

- ✅ Pas d'App Store (Apple/Google)
- ✅ Une seule URL pour tous les utilisateurs
- ✅ Installation optionnelle sur mobile/desktop
- ✅ Mises à jour instantanées
- ✅ Fonctionne sur tous les OS
- ✅ HTTPS inclus
- ✅ Hébergement gratuit (Vercel/Netlify)

## 👥 Utilisateurs de test

Pour tester l'application, créez des utilisateurs dans Supabase Dashboard (Authentication > Users):

### Chauffeur
- Email: `chauffeur@test.com`
- Password: `password123`
- User Metadata: `{"nom": "Jean Dupont", "role": "chauffeur"}`

### Call Center
- Email: `callcenter@test.com`
- Password: `password123`
- User Metadata: `{"nom": "Marie Martin", "role": "call_center"}`

### Logistique
- Email: `logistique@test.com`
- Password: `password123`
- User Metadata: `{"nom": "Pierre Durand", "role": "logistique"}`

Après création, créez aussi l'entrée correspondante dans la table `chauffeurs` pour l'utilisateur chauffeur.

## 📱 Clients de test

3 clients sont déjà créés:
- Garage Martin (Paris)
- Auto Services Plus (Lyon)
- Mécanique Express (Bordeaux)

## 🔄 Realtime

L'application utilise Supabase Realtime pour:
- Synchroniser les changements de statut
- Mettre à jour les tableaux de bord instantanément
- Notifier les chauffeurs des nouvelles assignations

## 🏗️ Architecture

```
app/
├── (auth)/           # Écrans d'authentification
│   └── login.tsx
├── (driver)/         # Interface chauffeurs (mobile)
│   ├── deliveries.tsx
│   ├── delivery/[id].tsx
│   └── payment/[id].tsx
├── (web)/            # Interface web (call center, logistique)
│   ├── dashboard.tsx
│   ├── commandes/
│   ├── planning.tsx
│   └── affectation.tsx
contexts/
├── AuthContext.tsx   # Gestion authentification
lib/
├── supabase.ts       # Client Supabase
types/
├── database.ts       # Types TypeScript
supabase/functions/
├── create-payment-link/  # Génération Payment Links
└── stripe-webhook/       # Réception webhooks Stripe
```

## 🎨 Design

- Palette: Bleu (#2563EB), Gris (#6B7280), Vert succès (#10B981), Rouge erreur (#EF4444)
- Design responsive adapté mobile et web
- Interface simple et professionnelle

## 📝 TODO / Améliorations futures

- [ ] Géolocalisation en temps réel des chauffeurs
- [ ] Carte Leaflet pour voir position sur interface logistique
- [ ] Notifications push pour nouvelles assignations
- [ ] Export CSV des commandes
- [ ] Gestion des produits détaillés par commande
- [ ] Statistiques et analytics
- [ ] Mode hors-ligne pour chauffeurs
- [ ] Signature électronique à la livraison

## 🐛 Debug

En cas de problème:
1. Vérifier que Supabase est bien configuré
2. S'assurer que les Edge Functions sont déployées
3. Vérifier les RLS policies si problème de permissions
4. Consulter les logs Supabase pour les erreurs backend

## 📄 Licence

Projet privé - Tous droits réservés
