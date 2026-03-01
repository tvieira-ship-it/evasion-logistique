# 🚀 Guide de Démarrage Rapide - Livraisons Pro

## Étape 1️⃣ : Créer les Utilisateurs (5 minutes)

### A. Accéder à Supabase
1. Ouvrez : https://fsyzgtbnntkqeftgyukr.supabase.co
2. Connectez-vous avec votre compte Supabase
3. Cliquez sur **Authentication** dans le menu de gauche
4. Cliquez sur **Users**

### B. Créer 3 utilisateurs

Pour chaque utilisateur, cliquez sur **"Add user"** → **"Create new user"** :

#### 👨‍💼 Utilisateur 1 : Chauffeur
```
Email: chauffeur@test.com
Password: password123
☑️ Auto Confirm User

Cliquez sur "Advanced" et ajoutez dans User Metadata :
{
  "nom": "Jean Dupont",
  "role": "chauffeur"
}
```

#### 📞 Utilisateur 2 : Call Center
```
Email: callcenter@test.com
Password: password123
☑️ Auto Confirm User

User Metadata :
{
  "nom": "Marie Martin",
  "role": "call_center"
}
```

#### 📊 Utilisateur 3 : Logistique
```
Email: logistique@test.com
Password: password123
☑️ Auto Confirm User

User Metadata :
{
  "nom": "Pierre Durand",
  "role": "logistique"
}
```

### C. Lier le chauffeur à la base de données

1. Dans Supabase, allez dans **SQL Editor**
2. Copiez-collez ce script et exécutez-le :

```sql
DO $$
DECLARE
  chauffeur_user_id uuid;
BEGIN
  SELECT id INTO chauffeur_user_id
  FROM profiles
  WHERE email = 'chauffeur@test.com'
  LIMIT 1;

  IF chauffeur_user_id IS NOT NULL THEN
    INSERT INTO chauffeurs (user_id, nom, email, telephone, actif)
    VALUES (
      chauffeur_user_id,
      'Jean Dupont',
      'chauffeur@test.com',
      '0612345678',
      true
    )
    ON CONFLICT DO NOTHING;
  END IF;
END $$;
```

✅ **Vérification** : Exécutez cette requête pour confirmer
```sql
SELECT email, nom, role FROM profiles;
SELECT nom, email FROM chauffeurs;
```

Vous devriez voir 3 profils et 1 chauffeur.

---

## Étape 2️⃣ : Créer une Commande de Test (2 minutes)

Dans le **SQL Editor** de Supabase, exécutez :

```sql
DO $$
DECLARE
  client_id uuid;
  chauffeur_id uuid;
BEGIN
  SELECT id INTO client_id FROM clients WHERE numero_compte = 'GAR001' LIMIT 1;
  SELECT id INTO chauffeur_id FROM chauffeurs WHERE email = 'chauffeur@test.com' LIMIT 1;

  INSERT INTO commandes (
    client_id, date_livraison, bon_livraison, montant_ttc,
    option_paiement, statut, chauffeur_id
  ) VALUES (
    client_id, CURRENT_DATE, 'BL-2024-001', 150.50,
    'cb_livraison', 'accepte', chauffeur_id
  );
END $$;
```

---

## Étape 3️⃣ : Lancer l'Application (1 minute)

Dans votre terminal, à la racine du projet :

```bash
npm run dev
```

L'application démarre sur :
- 🌐 **Web** : http://localhost:8081
- 📱 **Mobile** : Scanner le QR code avec Expo Go

---

## Étape 4️⃣ : Tester les Interfaces

### 🌐 Interface Web (Call Center / Logistique)

Ouvrez http://localhost:8081 dans votre navigateur.

#### Test Call Center
1. Connectez-vous avec :
   - Email : `callcenter@test.com`
   - Mot de passe : `password123`

2. Vous verrez le dashboard avec :
   - Statistiques des livraisons
   - Bouton "Nouvelle commande"
   - Commandes récentes

3. Testez la création d'une commande :
   - Cliquez sur "Nouvelle commande"
   - Recherchez un client (tapez "Martin")
   - Remplissez le formulaire
   - Créez la commande

#### Test Logistique
1. Déconnectez-vous (icône en haut à droite)
2. Connectez-vous avec :
   - Email : `logistique@test.com`
   - Mot de passe : `password123`

3. Testez l'affectation :
   - Cliquez sur "Affectation"
   - Cliquez sur "Affecter" pour une commande
   - Choisissez le chauffeur "Jean Dupont"

### 📱 Interface Mobile (Chauffeur)

#### Sur ordinateur (web) :
1. Dans un nouvel onglet, ouvrez http://localhost:8081
2. Connectez-vous avec :
   - Email : `chauffeur@test.com`
   - Mot de passe : `password123`

#### Sur téléphone (avec Expo Go) :
1. Installez **Expo Go** sur votre téléphone
2. Scannez le QR code affiché dans le terminal
3. Connectez-vous avec les identifiants chauffeur

#### Tester le flux chauffeur :
1. Vous voyez la liste des livraisons du jour
2. Cliquez sur une livraison
3. Testez les actions :
   - ✅ "Marquer comme chargée"
   - 🚗 "Démarrer la livraison"
   - 📦 "Marquer comme livrée"
   - 💳 "Encaisser maintenant" (si CB à livraison)

---

## Étape 5️⃣ : Tester le Paiement (Optionnel)

Pour tester les paiements par carte :

1. **Configurer Stripe** (voir `STRIPE_SETUP.md`)
2. **Générer un QR code** depuis l'écran paiement chauffeur
3. **Scanner et payer** avec une carte de test Stripe :
   - Numéro : `4242 4242 4242 4242`
   - Date : N'importe quelle date future
   - CVC : `123`

---

## 🎯 Récapitulatif du Flux Complet

```
1. Call Center → Crée une commande
              ↓
2. Logistique → Affecte un chauffeur
              ↓
3. Chauffeur → Marque "chargée"
              ↓
4. Chauffeur → "Départ livraison"
              ↓
5. Chauffeur → "Livrée"
              ↓
6. Chauffeur → Encaisse le paiement (QR code)
              ↓
7. Client → Paie avec son téléphone
              ↓
8. ✅ Statut automatiquement "Payée"
```

---

## ✅ Liste de Vérification

- [ ] 3 utilisateurs créés dans Supabase Auth
- [ ] Chauffeur lié dans la table `chauffeurs`
- [ ] Commande de test créée
- [ ] Application lancée (`npm run dev`)
- [ ] Connexion Call Center OK
- [ ] Connexion Logistique OK
- [ ] Connexion Chauffeur OK
- [ ] Création de commande testée
- [ ] Affectation chauffeur testée
- [ ] Changement de statut testé

---

## 🆘 Besoin d'Aide ?

### Problème de connexion
- Vérifiez que "Auto Confirm User" était coché
- Vérifiez le rôle dans les User Metadata

### Le chauffeur ne voit pas ses livraisons
- Vérifiez que l'entrée `chauffeurs` existe
- Exécutez : `SELECT * FROM chauffeurs WHERE email = 'chauffeur@test.com';`

### Erreur Permission Denied
- Les RLS policies sont actives
- Vérifiez que le rôle est correct dans `profiles`

### Stripe ne fonctionne pas
- C'est normal, suivez `STRIPE_SETUP.md` pour configurer

---

## 📚 Documentation Complète

- **`README.md`** : Documentation technique complète
- **`STRIPE_SETUP.md`** : Configuration des paiements
- **`CREER_UTILISATEURS.md`** : Guide détaillé création utilisateurs
- **`scripts/`** : Scripts SQL utiles

Bon développement ! 🚀
