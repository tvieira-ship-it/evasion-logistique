# 🎯 Guide Rapide : Créer les Utilisateurs de Test

## ⚡ Méthode EXPRESS : Via SQL (RECOMMANDÉE)

La façon la plus rapide de créer tous vos utilisateurs de test !

### 1️⃣ Ouvrir SQL Editor

1. Allez sur votre Dashboard Supabase
2. Cliquez sur **"SQL Editor"** dans le menu de gauche
3. Cliquez sur **"New query"**

### 2️⃣ Coller et Exécuter

Copiez-collez ce script complet et cliquez sur **"Run"** :

```sql
-- Créer 3 chauffeurs de test
SELECT create_user_with_profile('chauffeur1@test.com', 'password123', 'Jean Dupont', 'chauffeur');
SELECT create_user_with_profile('chauffeur2@test.com', 'password123', 'Marie Durand', 'chauffeur');
SELECT create_user_with_profile('chauffeur3@test.com', 'password123', 'Pierre Martin', 'chauffeur');

-- Créer les autres rôles
SELECT create_user_with_profile('admin@test.com', 'admin123', 'Admin Test', 'admin');
SELECT create_user_with_profile('callcenter@test.com', 'password123', 'Call Center', 'call_center');
SELECT create_user_with_profile('logistique@test.com', 'password123', 'Logistique', 'logistique');
```

### 3️⃣ Vérifier la Création

```sql
-- Voir tous les utilisateurs créés
SELECT id, nom, email, role, created_at
FROM profiles
ORDER BY created_at DESC;
```

✅ Vous devriez voir 6 utilisateurs avec leurs profils automatiquement créés !

---

## 📱 Méthode Alternative : Interface Supabase

Si vous préférez utiliser l'interface graphique :

### 1️⃣ Ouvrir Authentication

1. Dans le menu de gauche, cliquez sur **"Authentication"**
2. Puis cliquez sur **"Users"**
3. Cliquez sur **"Add user"** > **"Create new user"**

### 2️⃣ Créer un Utilisateur

**Informations à saisir :**
- **Email** : `chauffeur@test.com`
- **Password** : `password123`
- **Auto Confirm User** : ✅ **Cochez cette case !**

Cliquez sur **"Create user"**

### 3️⃣ Modifier le Profil (si nécessaire)

Le profil est créé automatiquement avec :
- **Nom** : partie avant @ de l'email
- **Rôle** : chauffeur (par défaut)

Pour modifier :
1. Allez dans **"Table Editor"** > **"profiles"**
2. Trouvez l'utilisateur par son email
3. Modifiez le **nom** et le **role** si besoin

## ✅ Vérification

Pour vérifier que tout est bien créé, exécutez cette requête SQL :

```sql
-- Voir tous les profils créés
SELECT id, email, nom, role FROM profiles;

-- Voir le chauffeur créé
SELECT * FROM chauffeurs;
```

Vous devriez voir :
- 3 profils (chauffeur, call_center, logistique)
- 1 entrée dans chauffeurs

## 🚀 Connexion

Vous pouvez maintenant vous connecter à l'application avec :

**Mobile (Chauffeur)** :
- Email : `chauffeur@test.com`
- Mot de passe : `password123`

**Web (Call Center)** :
- Email : `callcenter@test.com`
- Mot de passe : `password123`

**Web (Logistique)** :
- Email : `logistique@test.com`
- Mot de passe : `password123`

## 🎯 Tester le Flux Complet

1. **Connexion Call Center** → Créer une nouvelle commande
2. **Connexion Logistique** → Affecter la commande au chauffeur
3. **Connexion Chauffeur** (mobile) → Voir la livraison, la marquer comme livrée
4. **Tester le paiement** → Cliquer sur "Encaisser maintenant" et scanner le QR code

## ⚠️ Problèmes Courants

### Erreur : "Contrainte de clé étrangère"
**NE créez JAMAIS un profil directement dans la table `profiles` !**

Utilisez toujours :
- La fonction SQL `create_user_with_profile()`
- OU l'interface Authentication (le profil se crée automatiquement)

### L'utilisateur ne peut pas se connecter
- Vérifiez que **"Auto Confirm User"** était coché lors de la création
- Si non, allez dans Authentication > Users, cliquez sur l'utilisateur et confirmez-le manuellement
- Vérifiez que le profil existe dans la table `profiles`

### Erreur : "Un utilisateur avec cet email existe déjà"
L'email est déjà utilisé. Pour le supprimer :
1. Allez dans **Authentication** > **Users**
2. Trouvez l'utilisateur et cliquez sur les **...** > **Delete user**
3. Le profil sera supprimé automatiquement (cascade)
