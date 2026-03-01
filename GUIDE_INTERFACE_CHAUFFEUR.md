# Guide d'Accès à l'Interface Chauffeur

## 🚀 Accès Rapide

L'interface chauffeur existe déjà dans votre application! Pour y accéder:

### Compte Chauffeur de Test Disponible

**Email:** `test-demo@evasion.com`

**Pour définir/réinitialiser le mot de passe:**

1. Restez connecté avec votre compte admin actuel
2. Allez dans l'onglet **"Utilisateurs"**
3. Recherchez "Test Demo" dans la liste
4. Cliquez sur l'utilisateur pour ouvrir sa fiche
5. Cliquez sur le bouton **"Réinitialiser mot de passe"**
6. Définissez un nouveau mot de passe (ex: `Chauffeur123!`)
7. Déconnectez-vous de votre compte admin
8. Reconnectez-vous avec `test-demo@evasion.com` et le nouveau mot de passe

### Autres Comptes Chauffeur Disponibles

Vous avez également ces comptes chauffeurs existants:
- `rachis.kaadhi@sofibrie.fr` - Kaadhi
- `ruben.pierregabriel@sofibrie.fr` - Pierre Gabriel

## Commandes de Test Créées

J'ai créé **3 commandes de test** pour aujourd'hui (2026-03-01) affectées au chauffeur "Test Demo":

1. **Commande #1005** - Statut: Acceptée - 150,00 € - CB à livraison
2. **Commande #1006** - Statut: Chargée - 220,50 € - Facture
3. **Commande #1007** - Statut: En livraison - 89,90 € - CB à livraison

## Accès à l'Interface

### Option 1: Se connecter avec le compte chauffeur

1. Déconnectez-vous de votre compte actuel
2. Connectez-vous avec `test-demo@evasion.com`
3. Vous serez automatiquement redirigé vers l'interface chauffeur

### Option 2: Réinitialiser le mot de passe

Si vous ne connaissez pas le mot de passe du compte chauffeur:

1. Allez dans **Utilisateurs** (avec votre compte admin)
2. Recherchez "Test Demo"
3. Cliquez sur l'utilisateur
4. Utilisez le bouton **"Réinitialiser mot de passe"**
5. Un email sera envoyé avec un lien de réinitialisation

## Fonctionnalités de l'Interface Chauffeur

### Page Principale (`/deliveries`)

**Statistiques en temps réel:**
- Total de livraisons du jour
- Livraisons en cours
- Livraisons livrées
- Montant total à encaisser

**Liste des livraisons:**
- Numéro de commande
- Statut avec badge coloré
- Informations client (nom, adresse complète)
- Montant et mode de paiement
- Bouton de navigation GPS (pour les livraisons en cours)

**Actions:**
- Pull-to-refresh pour actualiser
- Bouton de déconnexion
- Cliquer sur une livraison pour voir les détails

### Page Détail Livraison (`/delivery/[id]`)

**Informations affichées:**
- Détails de la commande (numéro, bon de livraison)
- Informations client complètes (adresse, téléphone, email)
- Montant et mode de paiement
- Statut de paiement si CB à livraison

**Workflow de changement de statut:**

1. **"Acceptée"** → Bouton "Marquer comme chargée"
2. **"Chargée"** → Bouton "Démarrer la livraison"
3. **"En livraison"** → Boutons:
   - "Marquer comme livrée" (vert)
   - "Reporter la livraison" (gris)
   - "Décharger (non livrée)" (rouge)
4. **"Livrée"** avec CB → Bouton "Encaisser maintenant"

**Alerte paiement:**
Si la commande nécessite un paiement CB à la livraison, une alerte rouge s'affiche avec le montant à encaisser.

### Page Paiement Stripe (`/payment/[id]`)

**Pour les paiements CB à livraison:**

1. Cliquez sur "Encaisser maintenant"
2. L'écran affiche le montant à encaisser
3. Cliquez sur "Générer le QR Code"
4. Un QR Code Stripe s'affiche
5. Le client scanne le QR Code avec son téléphone
6. Le client effectue le paiement sur son téléphone
7. Le statut passe automatiquement à "Payée"
8. Écran de confirmation avec ✓ vert

**Mise à jour en temps réel:**
L'interface se met à jour automatiquement dès que le paiement est confirmé par Stripe.

## Test du Workflow Complet

Pour tester toutes les fonctionnalités:

1. **Connectez-vous** avec le compte chauffeur
2. **Commande #1005** (Acceptée):
   - Marquez-la comme "Chargée"
3. **Commande #1006** (Chargée):
   - Démarrez la livraison
4. **Commande #1007** (En livraison):
   - Utilisez le bouton de navigation (s'ouvre dans Google Maps)
   - Marquez comme livrée
   - Testez le paiement CB (génération du QR code)

## Mise à Jour Temps Réel

L'interface chauffeur utilise Supabase Realtime pour se mettre à jour automatiquement:
- Nouvelles commandes affectées
- Changements de statut
- Confirmations de paiement

Aucun rechargement de page nécessaire!

## Notes Importantes

- Seules les livraisons du **jour en cours** sont affichées
- Seules les livraisons **affectées au chauffeur connecté** sont visibles
- Les statistiques se recalculent automatiquement
- La navigation GPS fonctionne uniquement si les coordonnées GPS sont renseignées dans la base

## Architecture

L'interface chauffeur est dans le dossier `app/(driver)/`:
- `deliveries.tsx` - Liste des livraisons
- `delivery/[id].tsx` - Détail d'une livraison
- `payment/[id].tsx` - Écran de paiement Stripe

Le routage se fait automatiquement selon le rôle de l'utilisateur connecté.
