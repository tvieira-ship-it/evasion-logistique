# Guide de Création des Utilisateurs - Evasion Logistique

Ce guide vous explique comment créer des utilisateurs pour votre application de gestion de livraisons.

## Vue d'ensemble

Votre application utilise maintenant un **système automatisé** :
1. **Authentication** de Supabase pour la connexion (email/mot de passe)
2. **Création automatique du profil** dès qu'un utilisateur est créé
3. Pas besoin de manipulation manuelle des tables

## Rôles disponibles

- **chauffeur** : Accès à l'application mobile pour les livraisons
- **call_center** : Gestion des commandes et affectations
- **logistique** : Planning et organisation des livraisons
- **admin** : Accès complet à toutes les fonctionnalités

## Méthode 1 : Fonction SQL (RECOMMANDÉE)

Cette méthode crée l'utilisateur et son profil en une seule commande.

### Étapes :

1. Ouvrez **SQL Editor** dans Supabase
2. Utilisez la fonction `create_user_with_profile` :

```sql
-- Créer un chauffeur
SELECT create_user_with_profile(
  'chauffeur@example.com',
  'motdepasse123',
  'Jean Dupont',
  'chauffeur'
);

-- Créer un admin
SELECT create_user_with_profile(
  'admin@example.com',
  'admin123',
  'Marie Martin',
  'admin'
);

-- Créer un call center
SELECT create_user_with_profile(
  'call@example.com',
  'call123',
  'Pierre Durant',
  'call_center'
);

-- Créer un logistique
SELECT create_user_with_profile(
  'logistique@example.com',
  'logistique123',
  'Sophie Leroy',
  'logistique'
);
```

3. Vérifiez la création :
```sql
SELECT id, nom, email, role, created_at
FROM profiles
ORDER BY created_at DESC;
```

## Méthode 2 : Interface Authentication (SIMPLE)

Cette méthode est plus simple mais le profil aura des valeurs par défaut.

### Étapes :

1. Allez dans **Authentication** > **Users**
2. Cliquez sur **Add user** > **Create new user**
3. Remplissez :
   - **Email** : L'adresse email
   - **Password** : Un mot de passe sécurisé
   - **Auto Confirm User** : Cochez cette case ✓
4. Cliquez sur **Create user**

Le profil sera créé automatiquement avec :
- **nom** : Extrait de l'email (partie avant @)
- **role** : chauffeur (par défaut)

5. Si nécessaire, modifiez le profil :
   - Allez dans **Table Editor** > **profiles**
   - Trouvez l'utilisateur et modifiez `nom` et `role`

## Méthode 3 : Script de test complet

Pour créer plusieurs utilisateurs de test rapidement :

```sql
-- Créer 3 chauffeurs
SELECT create_user_with_profile('chauffeur1@test.com', 'test123', 'Chauffeur 1', 'chauffeur');
SELECT create_user_with_profile('chauffeur2@test.com', 'test123', 'Chauffeur 2', 'chauffeur');
SELECT create_user_with_profile('chauffeur3@test.com', 'test123', 'Chauffeur 3', 'chauffeur');

-- Créer les autres rôles
SELECT create_user_with_profile('admin@test.com', 'admin123', 'Admin Test', 'admin');
SELECT create_user_with_profile('call@test.com', 'call123', 'Call Center Test', 'call_center');
SELECT create_user_with_profile('logistique@test.com', 'log123', 'Logistique Test', 'logistique');

-- Vérifier
SELECT id, nom, email, role FROM profiles ORDER BY role, nom;
```

## Exemples d'utilisateurs de test

### Chauffeur
```
Email: chauffeur@evasion.com
Password: Chauffeur2024!
Role: chauffeur
```
⚠️ N'oubliez pas de créer aussi dans la table `chauffeurs`

### Call Center
```
Email: callcenter@evasion.com
Password: CallCenter2024!
Role: call_center
```

### Logistique
```
Email: logistique@evasion.com
Password: Logistique2024!
Role: logistique
```

### Admin
```
Email: admin@evasion.com
Password: Admin2024!
Role: admin
```

## Vérification

Pour vérifier que vos utilisateurs sont bien créés, exécutez cette requête SQL :

```sql
SELECT
  p.id,
  p.nom,
  p.email,
  p.role,
  CASE WHEN c.id IS NOT NULL THEN 'Oui' ELSE 'Non' END as est_chauffeur
FROM public.profiles p
LEFT JOIN public.chauffeurs c ON c.user_id = p.id
ORDER BY p.created_at DESC;
```

## Dépannage

### Erreur : "Contrainte de clé étrangère" lors de la création de profil

**NE CRÉEZ JAMAIS** de profil directement dans la table `profiles` !

**Solution** : Utilisez toujours l'une des méthodes ci-dessus (fonction SQL ou interface Authentication).

### L'utilisateur ne peut pas se connecter
- Vérifiez que l'utilisateur existe dans **Authentication** > **Users**
- Vérifiez que son email est confirmé (colonne "email_confirmed_at" doit être remplie)
- Vérifiez que le profil existe dans la table `profiles` avec le même UUID

### Le profil n'a pas été créé automatiquement

Si vous avez un utilisateur sans profil (créé avant la mise en place du système automatique) :

```sql
-- Créer manuellement le profil pour un utilisateur existant
INSERT INTO profiles (id, nom, email, role)
SELECT
  id,
  split_part(email, '@', 1),
  email,
  'chauffeur'
FROM auth.users
WHERE email = 'email@example.com'
  AND id NOT IN (SELECT id FROM profiles);
```

### Erreur "Un utilisateur avec cet email existe déjà"
- L'utilisateur existe déjà dans Authentication
- Utilisez un autre email ou supprimez l'utilisateur existant
- Vérifiez dans **Authentication** > **Users**

## Sécurité

- Utilisez des mots de passe forts (minimum 8 caractères, avec majuscules, minuscules, chiffres)
- Ne partagez jamais les mots de passe par email ou SMS
- Changez les mots de passe de test avant la mise en production
- Les utilisateurs peuvent changer leur mot de passe via l'application

## Support

Si vous rencontrez des problèmes :
1. Vérifiez les logs dans Supabase (Database > Logs)
2. Vérifiez les politiques RLS (Database > Policies)
3. Consultez la documentation Supabase : https://supabase.com/docs
