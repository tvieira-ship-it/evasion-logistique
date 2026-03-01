# Configuration Stripe pour les Paiements

Cette application utilise Stripe Payment Links pour permettre aux clients de payer par carte bancaire lors de la livraison.

## 🔑 Prérequis

1. Créer un compte Stripe sur https://stripe.com
2. Activer le mode Test dans le dashboard Stripe

## ⚙️ Configuration des Secrets

Les Edge Functions Supabase nécessitent deux secrets Stripe :

### 1. STRIPE_SECRET_KEY

C'est votre clé secrète Stripe (mode test pour commencer).

**Où la trouver :**
- Allez sur https://dashboard.stripe.com/test/apikeys
- Copiez la "Secret key" (commence par `sk_test_...`)

**Comment la configurer :**
Les secrets sont automatiquement configurés par Supabase. Vous n'avez rien à faire manuellement.

### 2. STRIPE_WEBHOOK_SECRET

C'est la clé de signature pour valider les webhooks Stripe.

**Comment l'obtenir :**
1. Allez sur https://dashboard.stripe.com/test/webhooks
2. Cliquez sur "Add endpoint"
3. URL du endpoint : `https://fsyzgtbnntkqeftgyukr.supabase.co/functions/v1/stripe-webhook`
4. Sélectionnez les événements :
   - `checkout.session.completed`
   - `payment_intent.succeeded`
5. Cliquez sur "Add endpoint"
6. Une fois créé, cliquez sur l'endpoint pour voir la "Signing secret" (commence par `whsec_...`)

**Comment la configurer :**
Les secrets sont automatiquement configurés par Supabase.

## 🧪 Test en Mode Test

Pour tester les paiements en mode test Stripe :

1. Générez un Payment Link depuis l'app (écran paiement chauffeur)
2. Scannez le QR code ou ouvrez le lien
3. Utilisez une carte de test Stripe :
   - Numéro : `4242 4242 4242 4242`
   - Date : N'importe quelle date future
   - CVC : N'importe quel code à 3 chiffres
   - Code postal : N'importe quel code

4. Le paiement devrait être validé et le statut de la commande passe à "payée"

## 🔄 Flux de Paiement

1. **Chauffeur** marque la livraison comme "livrée"
2. **Chauffeur** clique sur "Encaisser maintenant"
3. **Edge Function** `create-payment-link` génère un Payment Link Stripe
4. **QR Code** est affiché à l'écran
5. **Client** scanne et paie avec son téléphone
6. **Stripe** envoie un webhook à `stripe-webhook`
7. **Edge Function** met à jour le statut en "payée"
8. **Chauffeur** voit la confirmation en temps réel

## 📊 Suivi des Paiements

Dans le dashboard Stripe, vous pouvez :
- Voir tous les paiements (test et production)
- Consulter les détails de chaque transaction
- Voir les tentatives échouées
- Gérer les remboursements

## 🚀 Passage en Production

Quand vous êtes prêt pour la production :

1. Désactivez le mode Test dans Stripe
2. Utilisez les clés de production (commencent par `sk_live_...` et `whsec_live_...`)
3. Configurez les secrets de production dans Supabase
4. Configurez le webhook de production avec la même URL

## ⚠️ Important

- Ne commitez JAMAIS vos clés Stripe dans le code
- Utilisez toujours le mode Test pour le développement
- Les clés sont gérées par les Edge Functions (côté serveur)
- Seules les Edge Functions ont accès aux clés secrètes

## 🐛 Dépannage

### Le paiement ne se valide pas
- Vérifiez les logs dans Supabase Edge Functions
- Vérifiez que le webhook Stripe est bien configuré
- Vérifiez les logs des webhooks dans Stripe Dashboard

### Le QR code ne s'affiche pas
- Vérifiez que la Edge Function `create-payment-link` est déployée
- Vérifiez les logs de la fonction dans Supabase
- Assurez-vous que STRIPE_SECRET_KEY est configurée

### Erreur "Invalid signature"
- Vérifiez que STRIPE_WEBHOOK_SECRET est correctement configurée
- Assurez-vous d'utiliser la bonne clé (test vs production)
