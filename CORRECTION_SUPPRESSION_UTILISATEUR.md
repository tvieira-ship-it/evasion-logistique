# Correction de la suppression d'utilisateurs

## Problème identifié

La suppression d'utilisateurs ne fonctionnait pas correctement à cause de :
1. Les politiques RLS (Row Level Security) sur la table `profiles`
2. Un trigger de suppression en cascade qui ne fonctionnait pas correctement
3. L'API Admin de Supabase (`auth.admin.deleteUser()`) qui ne déclenche pas les CASCADE PostgreSQL

### Détails techniques

Initialement, un trigger `on_auth_user_deleted` essayait de supprimer manuellement le profil lors de la suppression d'un utilisateur dans `auth.users`. Cependant, ce trigger rencontrait des problèmes avec les politiques RLS, même avec `SECURITY DEFINER`.

De plus, l'API Admin de Supabase ne déclenche pas les contraintes CASCADE de PostgreSQL, ce qui empêchait la suppression automatique du profil.

## Solution appliquée

La solution combine deux approches :

1. **ON DELETE CASCADE** sur la contrainte de clé étrangère (pour les suppressions SQL directes)
2. **Fonction RPC dédiée** qui effectue une suppression SQL et déclenche le CASCADE

### Changements effectués

1. **Suppression du trigger manuel** :
   - Supprimé le trigger `on_auth_user_deleted`
   - Supprimé la fonction `delete_profile_on_user_delete()`

2. **Ajout de CASCADE sur la contrainte FK** :
   ```sql
   ALTER TABLE public.profiles
   ADD CONSTRAINT profiles_id_fkey
   FOREIGN KEY (id)
   REFERENCES auth.users(id)
   ON DELETE CASCADE;
   ```

3. **Création d'une fonction RPC** :
   ```sql
   CREATE OR REPLACE FUNCTION delete_user_by_id(user_id_to_delete uuid)
   RETURNS void
   LANGUAGE plpgsql
   SECURITY DEFINER
   AS $$
   BEGIN
     DELETE FROM auth.users WHERE id = user_id_to_delete;
   END;
   $$;
   ```

4. **Modification de la Edge Function** pour utiliser la fonction RPC au lieu de l'API Admin

Cette approche est plus simple, plus fiable et déclenche correctement le CASCADE PostgreSQL.

## Flux de suppression

1. L'utilisateur super-admin clique sur "Supprimer l'utilisateur"
2. Une confirmation est demandée
3. L'application appelle la Edge Function `delete-user` avec l'ID de l'utilisateur
4. La fonction vérifie que :
   - L'utilisateur est authentifié
   - L'utilisateur est super-admin
   - L'utilisateur ne supprime pas son propre compte
5. La fonction utilise la clé service role pour supprimer l'utilisateur de `auth.users`
6. PostgreSQL supprime automatiquement le profil associé grâce à `ON DELETE CASCADE`
7. L'utilisateur est redirigé vers la liste des utilisateurs qui se rafraîchit automatiquement

## Test de la suppression

1. Connectez-vous en tant que super-admin
2. Allez dans le menu "Utilisateurs"
3. Créez un utilisateur de test (ex: Test Suppression)
4. Cliquez sur l'utilisateur dans la liste
5. Cliquez sur le bouton rouge "Supprimer l'utilisateur"
6. Confirmez la suppression
7. Vous devriez être redirigé vers la liste et l'utilisateur ne devrait plus apparaître

## Vérification en base de données

Pour vérifier que l'utilisateur a bien été supprimé :

```sql
-- Vérifier dans auth.users
SELECT id, email FROM auth.users WHERE email = 'email@utilisateur.com';

-- Vérifier dans profiles
SELECT id, email, nom, prenom FROM profiles WHERE email = 'email@utilisateur.com';
```

Les deux requêtes devraient retourner 0 résultat.

## Sécurité

- Seuls les super-administrateurs peuvent supprimer des utilisateurs
- Un utilisateur ne peut pas supprimer son propre compte
- La suppression est définitive et supprime toutes les données associées
- L'opération est sécurisée via la Edge Function qui utilise la clé service role

## Code modifié

### Fichiers modifiés :
1. `supabase/migrations/[timestamp]_fix_profile_deletion_with_system_role.sql` - Nouvelle migration
2. `app/(web)/utilisateurs/[id].tsx` - Amélioration de la redirection après suppression

### Edge Function utilisée :
- `supabase/functions/delete-user/index.ts`
