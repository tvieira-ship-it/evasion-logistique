# Guide de Mise à Jour - Evasion Logistique

## Vue d'ensemble

Ce guide explique comment gérer les mises à jour de l'application après son déploiement initial.

## Types de mises à jour

### 1. Mise à jour du Code Frontend

**Quand ?**
- Correction de bugs dans l'interface
- Ajout de nouvelles fonctionnalités UI
- Amélioration de l'expérience utilisateur
- Changements de style/design

**Processus :**

```bash
# 1. Faire vos modifications dans le code
# 2. Tester localement
npm run dev

# 3. Vérifier que tout compile
npm run typecheck

# 4. Créer le nouveau build
npm run build

# 5. Déployer selon votre plateforme
npm run deploy:vercel
# ou
npm run deploy:netlify
# ou
npm run deploy:firebase
```

**Impact utilisateur :**
- ✅ Mise à jour automatique au prochain chargement
- ✅ Pas d'interruption de service
- ✅ Pas d'action requise de l'utilisateur
- ⏱️ Délai : Immédiat à quelques minutes (cache CDN)

### 2. Mise à jour de la Base de Données

**Quand ?**
- Ajout de nouvelles tables
- Modification de colonnes existantes
- Ajout de nouvelles fonctions SQL
- Modification des politiques RLS
- Ajout d'index pour performance

**Processus :**

```bash
# 1. Créer une nouvelle migration
npm run migration:create nom_de_la_migration

# 2. Éditer le fichier généré dans supabase/migrations/
# 3. Tester la migration localement si possible
# 4. Appliquer via l'interface Supabase ou CLI
```

**Impact utilisateur :**
- ⚠️ Peut nécessiter une maintenance brève selon la complexité
- ✅ Les données existantes sont préservées
- ⚠️ Certaines requêtes peuvent être plus lentes pendant l'application

### 3. Mise à jour des Edge Functions

**Quand ?**
- Modification de la logique serveur
- Ajout de nouveaux webhooks
- Changement d'intégrations tierces (Stripe, notifications, etc.)

**Processus :**

Les Edge Functions sont déployées via les outils MCP Supabase intégrés. Aucun redéploiement de l'app frontend n'est nécessaire.

**Impact utilisateur :**
- ✅ Mise à jour instantanée
- ✅ Pas d'interruption
- ⏱️ Délai : Quelques secondes

## Workflow Complet de Mise à Jour

### Scénario 1 : Correction de Bug UI Simple

```bash
# Exemple : Correction d'un bouton qui ne fonctionne pas
# Fichier : app/(web)/dashboard.tsx

# 1. Corriger le code
# 2. Tester localement
npm run dev

# 3. Build et déploiement
npm run build
npm run deploy:vercel

# Temps total : ~3 minutes
# Utilisateurs impactés : Mise à jour automatique au prochain refresh
```

### Scénario 2 : Ajout d'une Nouvelle Fonctionnalité

```bash
# Exemple : Ajout d'un système de notes sur les commandes

# 1. Créer la migration pour la nouvelle colonne
# Fichier : supabase/migrations/20260301_add_notes_to_commandes.sql
# Contenu :
# ALTER TABLE commandes ADD COLUMN IF NOT EXISTS notes text;

# 2. Mettre à jour le type TypeScript
# Fichier : types/database.ts
# Ajouter : notes?: string;

# 3. Créer le composant UI
# Fichier : components/NotesField.tsx

# 4. Intégrer dans la page
# Fichier : app/(web)/call-center.tsx

# 5. Build et déploiement
npm run build
npm run deploy:vercel

# Temps total : ~15-30 minutes selon complexité
# Impact : Migration DB d'abord, puis déploiement code
```

### Scénario 3 : Mise à Jour Majeure avec Breaking Changes

**⚠️ ATTENTION : Nécessite planification**

```bash
# Exemple : Refonte du système d'affectation des chauffeurs

# ÉTAPE 1 : PRÉPARATION (J-7)
# - Créer une branche Git
# - Développer et tester exhaustivement
# - Documenter les changements

# ÉTAPE 2 : MIGRATION DB (J-1)
# - Créer les nouvelles tables/colonnes avec IF NOT EXISTS
# - NE PAS supprimer les anciennes colonnes tout de suite
# - Garder la compatibilité ascendante

# ÉTAPE 3 : DÉPLOIEMENT CODE (Jour J)
# - Déployer pendant heures creuses (ex: 2h du matin)
# - Monitorer les erreurs
# - Avoir un plan de rollback

# ÉTAPE 4 : NETTOYAGE (J+7)
# - Une fois stable, nettoyer les anciennes colonnes
# - Supprimer le code de compatibilité
```

## Gestion des Versions

### Fichier package.json

Votre version actuelle : `1.0.0`

**Semantic Versioning (MAJOR.MINOR.PATCH) :**

- **PATCH** (1.0.X) : Corrections de bugs, changements mineurs
- **MINOR** (1.X.0) : Nouvelles fonctionnalités compatibles
- **MAJOR** (X.0.0) : Breaking changes, refonte majeure

**Quand incrémenter :**

```bash
# Correction de bug
npm version patch  # 1.0.0 → 1.0.1

# Nouvelle fonctionnalité
npm version minor  # 1.0.1 → 1.1.0

# Breaking change
npm version major  # 1.1.0 → 2.0.0
```

**Créer un tag Git :**

```bash
git tag -a v1.2.0 -m "Ajout système de notes + optimisations"
git push origin v1.2.0
```

## Changelog Automatisé

Créez un fichier `CHANGELOG.md` pour suivre les changements :

```markdown
# Changelog - Evasion Logistique

## [1.1.0] - 2026-03-15

### Ajouté
- Système de notes sur les commandes
- Export PDF des rapports
- Filtres avancés dans l'historique

### Modifié
- Interface du call center plus rapide
- Amélioration du système d'affectation

### Corrigé
- Bug d'affichage sur iOS Safari
- Problème de validation des numéros de téléphone

## [1.0.1] - 2026-03-05

### Corrigé
- Correction du bouton de validation
- Fix de l'export CSV

## [1.0.0] - 2026-03-01
- Version initiale
```

## Migrations de Base de Données

### Conventions de Nommage

Format : `YYYYMMDDHHMMSS_description.sql`

Exemple : `20260315103000_add_notes_to_commandes.sql`

### Template de Migration

```sql
/*
  # [Titre court de la migration]

  1. Changements
    - Description détaillée des modifications
    - Impact sur les données existantes
    - Nouvelles tables/colonnes

  2. Sécurité
    - Politiques RLS ajoutées/modifiées
    - Permissions modifiées

  3. Notes importantes
    - Compatibilité ascendante : OUI/NON
    - Nécessite downtime : OUI/NON
    - Rollback possible : OUI/NON
*/

-- ========================================
-- NOUVELLES TABLES
-- ========================================

CREATE TABLE IF NOT EXISTS nouvelle_table (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz DEFAULT now() NOT NULL
);

-- ========================================
-- MODIFICATIONS DE COLONNES
-- ========================================

-- Vérifier si la colonne existe avant de l'ajouter
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'commandes' AND column_name = 'notes'
  ) THEN
    ALTER TABLE commandes ADD COLUMN notes text;
  END IF;
END $$;

-- ========================================
-- RLS ET SÉCURITÉ
-- ========================================

ALTER TABLE nouvelle_table ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own data"
  ON nouvelle_table FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

-- ========================================
-- INDEX POUR PERFORMANCE
-- ========================================

CREATE INDEX IF NOT EXISTS idx_commandes_notes
  ON commandes(notes)
  WHERE notes IS NOT NULL;

-- ========================================
-- DONNÉES DE MIGRATION (si nécessaire)
-- ========================================

-- Exemple : Migrer données anciennes vers nouveau format
UPDATE commandes
SET notes = description
WHERE notes IS NULL AND description IS NOT NULL;
```

### Checklist avant Application

- [ ] Migration testée localement si possible
- [ ] Backup de la base de données effectué
- [ ] Documentation des changements écrite
- [ ] Compatibilité avec le code existant vérifiée
- [ ] Politiques RLS ajoutées pour nouvelles tables
- [ ] Index créés pour colonnes fréquemment requêtées
- [ ] Plan de rollback préparé

### Rollback d'une Migration

Si une migration pose problème :

```sql
-- ROLLBACK TEMPLATE
-- Copier cette structure dans un nouveau fichier
-- Nom : YYYYMMDDHHMMSS_rollback_nom_migration_originale.sql

/*
  # Rollback de : [nom de la migration]

  1. Actions de rollback
    - Suppression des colonnes ajoutées
    - Restauration des valeurs par défaut
    - Suppression des index créés

  2. ATTENTION
    - Peut causer perte de données
    - Vérifier dépendances avant exécution
*/

-- Exemple : Supprimer colonne ajoutée
ALTER TABLE commandes DROP COLUMN IF EXISTS notes;

-- Exemple : Supprimer table créée
DROP TABLE IF EXISTS nouvelle_table CASCADE;

-- Exemple : Restaurer ancienne policy
DROP POLICY IF EXISTS "New policy" ON commandes;
CREATE POLICY "Old policy" ON commandes...;
```

## Stratégie de Rollback

### Frontend (Code)

**Méthode 1 : Revert Git**

```bash
# Trouver le commit à restaurer
git log --oneline

# Revenir en arrière
git revert <commit-hash>

# Rebuild et redéployer
npm run build
npm run deploy:vercel
```

**Méthode 2 : Déploiement précédent (Vercel/Netlify)**

1. Aller dans le dashboard Vercel/Netlify
2. Section "Deployments"
3. Trouver le déploiement précédent stable
4. Cliquer "Promote to Production"
5. ✅ Rollback instantané

### Base de Données

**Méthode 1 : Migration de Rollback**

Créer une migration inverse (voir template ci-dessus)

**Méthode 2 : Restore depuis Backup**

```sql
-- Via Supabase Dashboard :
-- 1. Settings → Database → Backups
-- 2. Choisir le backup point-in-time
-- 3. Restore (créer nouvelle instance ou écraser)
```

**⚠️ ATTENTION :**
- Les données créées après le backup seront perdues
- Coordonner avec le rollback du code frontend
- Prévenir les utilisateurs si downtime nécessaire

## Monitoring des Mises à Jour

### Vérifications Post-Déploiement

```bash
# 1. Vérifier que le build est déployé
curl https://votre-app.vercel.app

# 2. Vérifier les logs (Vercel/Netlify dashboard)

# 3. Tester les fonctionnalités critiques
# - Connexion
# - Création de commande
# - Affectation chauffeur
# - Validation livraison

# 4. Monitorer les erreurs (Console navigateur)
```

### Indicateurs de Succès

- ✅ Aucune erreur 500 dans les logs
- ✅ Temps de chargement < 3 secondes
- ✅ Toutes les routes accessibles
- ✅ Authentification fonctionnelle
- ✅ Requêtes Supabase réussies

## Communication avec les Utilisateurs

### Mises à jour mineures (bug fixes)

Aucune communication nécessaire - mise à jour transparente

### Nouvelles fonctionnalités

**Email/Notification :**

```
Sujet : Nouvelle fonctionnalité disponible - Notes sur commandes

Bonjour,

Une nouvelle fonctionnalité est disponible dans Evasion Logistique :

✨ Vous pouvez maintenant ajouter des notes aux commandes
📝 Accessible depuis le centre d'appel et la vue logistique
🔄 Automatiquement synchronisé en temps réel

Aucune action requise de votre part, rechargez simplement l'application.

Bonne journée !
```

### Mises à jour majeures avec downtime

**Email préventif (J-2) :**

```
Sujet : Maintenance planifiée - Samedi 15 mars, 2h-4h du matin

Bonjour,

Nous effectuerons une mise à jour majeure de l'application :

📅 Quand : Samedi 15 mars 2026
🕐 Horaire : 2h00 - 4h00 (durée estimée : 30 minutes)
⚠️ Impact : Application inaccessible pendant la maintenance

Nouveautés après la mise à jour :
- Nouveau système de tournées optimisé
- Interface chauffeur améliorée
- Rapports PDF avancés

Merci de votre compréhension.
```

## Scripts Utiles

### Créer une Nouvelle Migration

```bash
# Ajouter dans package.json scripts :
"migration:create": "node scripts/create-migration.js"
```

Créer `scripts/create-migration.js` :

```javascript
const fs = require('fs');
const path = require('path');

const name = process.argv[2];
if (!name) {
  console.error('Usage: npm run migration:create nom_de_la_migration');
  process.exit(1);
}

const timestamp = new Date().toISOString()
  .replace(/[-:]/g, '')
  .replace(/\..+/, '')
  .replace('T', '');

const filename = `${timestamp}_${name}.sql`;
const filepath = path.join(__dirname, '../supabase/migrations', filename);

const template = `/*
  # ${name.replace(/_/g, ' ')}

  1. Changements
    - [Décrire les changements]

  2. Sécurité
    - [Politiques RLS]

  3. Notes
    - Compatibilité ascendante : OUI
    - Nécessite downtime : NON
    - Rollback possible : OUI
*/

-- Votre code SQL ici
`;

fs.writeFileSync(filepath, template);
console.log(`✅ Migration créée : ${filename}`);
```

### Vérifier la Santé de l'App

```bash
# Ajouter dans package.json scripts :
"health:check": "node scripts/health-check.js"
```

Créer `scripts/health-check.js` :

```javascript
const https = require('https');

const APP_URL = 'https://votre-app.vercel.app';

async function checkHealth() {
  return new Promise((resolve) => {
    https.get(APP_URL, (res) => {
      if (res.statusCode === 200) {
        console.log('✅ App accessible');
        resolve(true);
      } else {
        console.error(`❌ Status code : ${res.statusCode}`);
        resolve(false);
      }
    }).on('error', (err) => {
      console.error(`❌ Erreur : ${err.message}`);
      resolve(false);
    });
  });
}

checkHealth();
```

## Bonnes Pratiques

### ✅ À FAIRE

1. **Toujours tester localement** avant de déployer
2. **Créer des migrations incrémentales** (petites et fréquentes)
3. **Utiliser IF EXISTS / IF NOT EXISTS** dans les migrations
4. **Documenter chaque changement** dans CHANGELOG.md
5. **Faire des backups** avant migrations DB importantes
6. **Déployer pendant heures creuses** pour updates majeures
7. **Monitorer les erreurs** après chaque déploiement
8. **Garder compatibilité ascendante** quand possible
9. **Versionner avec Git tags** les releases importantes
10. **Communiquer** avec les utilisateurs pour nouveautés

### ❌ À ÉVITER

1. **Déployer sans tester**
2. **Supprimer des colonnes** sans migration de données
3. **Déployer DB et code** en même temps pour breaking changes
4. **Ignorer les erreurs** dans les logs
5. **Faire des changements** directement en production
6. **Oublier les politiques RLS** sur nouvelles tables
7. **Déployer le vendredi soir** (si problème, week-end compliqué)
8. **Modifier des migrations** déjà appliquées
9. **Hardcoder des valeurs** qui devraient être configurables
10. **Négliger la documentation** des changements

## Checklist de Mise à Jour

### Avant Déploiement

- [ ] Code testé localement (`npm run dev`)
- [ ] Build réussit (`npm run build`)
- [ ] Types TypeScript valides (`npm run typecheck`)
- [ ] Migrations DB créées et documentées
- [ ] CHANGELOG.md mis à jour
- [ ] Version incrémentée dans package.json
- [ ] Git commit + tag si nécessaire
- [ ] Backup DB effectué (si migration DB)
- [ ] Plan de rollback préparé

### Pendant Déploiement

- [ ] Build déployé (`npm run deploy:vercel`)
- [ ] Migrations DB appliquées (si applicable)
- [ ] Vérification URL principale accessible
- [ ] Test des fonctionnalités critiques

### Après Déploiement

- [ ] Monitoring des logs (10-15 minutes)
- [ ] Vérification des erreurs utilisateur
- [ ] Test sur mobile + desktop
- [ ] Validation données DB cohérentes
- [ ] Communication utilisateurs (si nécessaire)
- [ ] Documentation équipe mise à jour

## Ressources Complémentaires

- [Guide de déploiement PWA](./DEPLOIEMENT_PWA.md)
- [Documentation Supabase Migrations](https://supabase.com/docs/guides/cli/local-development#database-migrations)
- [Semantic Versioning](https://semver.org/)
- [Keep a Changelog](https://keepachangelog.com/)

---

**Questions fréquentes**

**Q : Combien de temps pour une mise à jour simple ?**
R : 2-5 minutes (build + déploiement)

**Q : Les utilisateurs doivent-ils faire quelque chose ?**
R : Non, refresh automatique de l'app PWA

**Q : Puis-je revenir en arrière facilement ?**
R : Oui pour le code (1 clic sur Vercel/Netlify). Plus complexe pour la DB.

**Q : Faut-il prévenir avant chaque mise à jour ?**
R : Non pour corrections mineures. Oui pour nouvelles fonctionnalités majeures.

**Q : Comment tester avant de déployer ?**
R : `npm run dev` pour tester localement. Créer un environnement de staging si besoin.
