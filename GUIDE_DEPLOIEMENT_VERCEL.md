# Guide de Déploiement sur Vercel

## Vue d'ensemble

Ce guide vous accompagne étape par étape pour déployer Evasion Logistique sur Vercel.

## Prérequis

- [ ] Compte GitHub avec le code du projet
- [ ] Compte Vercel (gratuit)
- [ ] Base de données Supabase configurée
- [ ] Variables d'environnement Supabase prêtes

## Étape 1 : Préparer le Projet

### 1.1 Vérifier que le Build Fonctionne

```bash
npm run build
```

Si le build réussit, vous êtes prêt à déployer.

### 1.2 Vérifier le fichier vercel.json

Le fichier `vercel.json` est déjà configuré dans votre projet :

```json
{
  "buildCommand": "expo export --platform web",
  "outputDirectory": "dist",
  "devCommand": "expo start --web",
  "cleanUrls": true,
  "framework": null,
  "installCommand": "npm install"
}
```

## Étape 2 : Pousser le Code sur GitHub

Si ce n'est pas déjà fait :

```bash
# Initialiser git (si nécessaire)
git init

# Ajouter tous les fichiers
git add .

# Créer le premier commit
git commit -m "Initial commit - Evasion Logistique v1.0.0"

# Créer un repo sur GitHub puis :
git remote add origin https://github.com/votre-username/evasion-logistique.git
git branch -M main
git push -u origin main
```

## Étape 3 : Créer un Compte Vercel

1. Aller sur [vercel.com](https://vercel.com)
2. Cliquer sur **Sign Up**
3. Choisir **Continue with GitHub**
4. Autoriser Vercel à accéder à votre GitHub

## Étape 4 : Importer le Projet sur Vercel

### 4.1 Via l'Interface Web (Recommandé)

1. **Dashboard Vercel** → Cliquer sur **Add New...** → **Project**

2. **Import Git Repository**
   - Chercher votre repo : `evasion-logistique`
   - Cliquer sur **Import**

3. **Configure Project**

   **Framework Preset** : Sélectionner `Other`

   **Root Directory** : `.` (laisser par défaut)

   **Build and Output Settings** :
   - Build Command : `expo export --platform web`
   - Output Directory : `dist`
   - Install Command : `npm install`
   - Development Command : `expo start --web`

4. **Environment Variables** (Très Important!)

   Ajouter vos variables Supabase :

   ```
   EXPO_PUBLIC_SUPABASE_URL = https://xxxxx.supabase.co
   EXPO_PUBLIC_SUPABASE_ANON_KEY = eyJxxxxxxxxxxxx
   ```

   Pour les récupérer :
   - Aller sur [supabase.com](https://supabase.com)
   - Ouvrir votre projet
   - Settings → API
   - Copier **Project URL** et **anon/public key**

5. **Deploy**
   - Cliquer sur **Deploy**
   - Attendre 2-3 minutes

### 4.2 Via la CLI Vercel (Alternative)

```bash
# Installer Vercel CLI
npm install -g vercel

# Se connecter
vercel login

# Déployer (première fois)
vercel

# Suivre les questions :
# - Set up and deploy? Yes
# - Which scope? (choisir votre compte)
# - Link to existing project? No
# - What's your project's name? evasion-logistique
# - In which directory is your code located? ./
# - Want to override the settings? No

# Ajouter les variables d'environnement
vercel env add EXPO_PUBLIC_SUPABASE_URL
# Coller la valeur : https://xxxxx.supabase.co

vercel env add EXPO_PUBLIC_SUPABASE_ANON_KEY
# Coller la valeur : eyJxxxxxxxxxxxx

# Déployer en production
vercel --prod
```

## Étape 5 : Vérifier le Déploiement

### 5.1 Ouvrir l'Application

Vercel vous donne une URL : `https://evasion-logistique.vercel.app`

Ouvrir cette URL dans votre navigateur.

### 5.2 Tester les Fonctionnalités

**Checklist de Test :**

- [ ] Page de login s'affiche correctement
- [ ] Connexion avec super-admin@test.com fonctionne
- [ ] Dashboard s'affiche avec les données
- [ ] Navigation entre les pages fonctionne
- [ ] Pas d'erreurs dans la console (F12)

### 5.3 Vérifier les Variables d'Environnement

Si l'application ne charge pas les données :

1. Aller dans **Vercel Dashboard** → votre projet → **Settings** → **Environment Variables**
2. Vérifier que les variables sont bien présentes
3. Si modifiées, redéployer : **Deployments** → **Redeploy**

## Étape 6 : Configuration Domaine Personnalisé (Optionnel)

Si vous avez un nom de domaine (ex: `evasion-logistique.com`) :

1. **Vercel Dashboard** → votre projet → **Settings** → **Domains**

2. Cliquer sur **Add Domain**

3. Entrer votre domaine : `evasion-logistique.com`

4. Suivre les instructions pour configurer les DNS :

   **Si domaine chez un registrar (OVH, Namecheap, etc.) :**

   Ajouter ces enregistrements DNS :

   ```
   Type: A
   Name: @
   Value: 76.76.21.21

   Type: CNAME
   Name: www
   Value: cname.vercel-dns.com
   ```

5. Attendre la propagation DNS (5-30 minutes)

6. Vercel génère automatiquement un certificat SSL

## Étape 7 : Configurer les Déploiements Automatiques

### 7.1 Configuration Automatique

Vercel configure automatiquement :

- ✅ **Déploiement auto** à chaque `git push` sur `main`
- ✅ **Preview deployments** pour chaque Pull Request
- ✅ **HTTPS** automatique
- ✅ **CDN global** pour performance

### 7.2 Environnements Multiples

Pour avoir staging + production :

**Créer une branche `staging` :**

```bash
git checkout -b staging
git push -u origin staging
```

**Dans Vercel :**

1. **Settings** → **Git** → **Production Branch** : `main`
2. Vercel crée automatiquement des previews pour `staging`

**URLs résultantes :**

- Production : `https://evasion-logistique.vercel.app` (branche `main`)
- Staging : `https://evasion-logistique-git-staging.vercel.app` (branche `staging`)
- Preview : `https://evasion-logistique-git-feature.vercel.app` (branches feature)

## Étape 8 : Monitoring et Logs

### 8.1 Voir les Logs de Déploiement

1. **Vercel Dashboard** → votre projet
2. **Deployments** → cliquer sur un déploiement
3. **Building** → voir les logs en temps réel

### 8.2 Analytics (Optionnel - Payant)

Vercel propose des analytics :
- Nombre de visiteurs
- Performance (Core Web Vitals)
- Pages les plus visitées

Activation : **Settings** → **Analytics** → **Enable**

## Étape 9 : Configurer Supabase pour Vercel

### 9.1 Autoriser le Domaine Vercel

**Dans Supabase :**

1. **Dashboard Supabase** → votre projet
2. **Authentication** → **URL Configuration**
3. **Site URL** : `https://evasion-logistique.vercel.app`
4. **Redirect URLs** : Ajouter :
   ```
   https://evasion-logistique.vercel.app/**
   https://*.vercel.app/**
   ```

### 9.2 Tester l'Authentification

- Se déconnecter de l'app
- Se reconnecter
- Vérifier que ça fonctionne

## Étape 10 : Edge Functions Supabase

Vos Edge Functions Supabase sont déjà déployées et fonctionnent automatiquement.

**Pour appeler depuis Vercel :**

L'URL reste la même :
```typescript
const apiUrl = `${import.meta.env.VITE_SUPABASE_URL}/functions/v1/create-user`;
```

Aucune modification nécessaire.

## Problèmes Courants et Solutions

### Problème 1 : Build Fail

**Erreur :** `Build failed with exit code 1`

**Solutions :**
```bash
# Tester en local
npm run build

# Si erreur TypeScript
npm run typecheck

# Si manque de dépendances
npm install
```

### Problème 2 : Page Blanche

**Erreur :** Application affiche une page blanche

**Solutions :**
1. Ouvrir la console (F12)
2. Chercher les erreurs
3. Vérifier les variables d'environnement dans Vercel
4. Redéployer après modification des variables

### Problème 3 : 404 sur Refresh

**Erreur :** Rafraîchir une page donne 404

**Solution :**

Vérifier que `vercel.json` contient :
```json
{
  "cleanUrls": true
}
```

Si le problème persiste, ajouter :
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

### Problème 4 : Variables d'Environnement Manquantes

**Erreur :** `Cannot read property of undefined`

**Solution :**

1. Vérifier que les variables commencent par `EXPO_PUBLIC_`
2. Dans Vercel, les ajouter pour **Production**, **Preview**, et **Development**
3. Redéployer

### Problème 5 : Authentification Ne Fonctionne Pas

**Erreur :** Ne peut pas se connecter

**Solutions :**
1. Vérifier Supabase URL Configuration (Redirect URLs)
2. Vérifier les variables d'environnement
3. Vérifier que l'URL Vercel est autorisée

## Commandes Utiles

### Déploiement CLI

```bash
# Déployer en production
vercel --prod

# Déployer preview (test)
vercel

# Voir les logs
vercel logs

# Lister les déploiements
vercel ls

# Voir les variables d'env
vercel env ls

# Supprimer un déploiement
vercel rm deployment-url
```

### Gestion des Variables

```bash
# Ajouter variable pour production
vercel env add VARIABLE_NAME production

# Ajouter variable pour preview
vercel env add VARIABLE_NAME preview

# Ajouter variable pour development
vercel env add VARIABLE_NAME development

# Supprimer variable
vercel env rm VARIABLE_NAME production
```

## Configuration Avancée

### 1. Headers de Sécurité

Ajouter dans `vercel.json` :

```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        },
        {
          "key": "Referrer-Policy",
          "value": "strict-origin-when-cross-origin"
        }
      ]
    }
  ]
}
```

### 2. Redirections

```json
{
  "redirects": [
    {
      "source": "/old-path",
      "destination": "/new-path",
      "permanent": true
    }
  ]
}
```

### 3. Performance

Vercel active automatiquement :
- ✅ Compression Gzip/Brotli
- ✅ CDN global (Edge Network)
- ✅ Cache intelligent
- ✅ HTTP/2 et HTTP/3

## Coûts Vercel

### Plan Hobby (Gratuit)

**Inclus :**
- Déploiements illimités
- HTTPS automatique
- 100 GB bandwidth/mois
- Domaines personnalisés

**Limites :**
- 1 membre d'équipe
- Pas de protection par mot de passe
- Support communautaire

**Parfait pour :** Petits projets, demos, MVPs

### Plan Pro ($20/mois)

**Inclus :**
- Tout du plan Hobby
- 1 TB bandwidth/mois
- Protection par mot de passe
- Analytics
- Support email prioritaire

**Parfait pour :** Applications production

### Estimation pour Evasion Logistique

**Utilisateurs :** 10-20 personnes

**Bandwidth estimé :**
- 20 utilisateurs × 50 requêtes/jour × 100 KB = ~100 MB/jour
- ~3 GB/mois

**Plan recommandé :** **Hobby (Gratuit)** largement suffisant

Upgrade vers Pro seulement si :
- Besoin protection par mot de passe
- Besoin analytics avancées
- Besoin support prioritaire

## Checklist de Déploiement Final

Avant de partager l'URL avec les utilisateurs :

### Technique
- [ ] Build réussit sans erreurs
- [ ] Pas d'erreurs TypeScript
- [ ] Variables d'environnement configurées
- [ ] Supabase redirect URLs configurées
- [ ] Domaine personnalisé configuré (si applicable)

### Fonctionnel
- [ ] Login fonctionne
- [ ] Dashboard charge les données
- [ ] Toutes les pages accessibles
- [ ] Pas d'erreurs console
- [ ] Navigation fluide

### Performance
- [ ] Page charge en < 3 secondes
- [ ] Images optimisées
- [ ] Pas de latence excessive

### Sécurité
- [ ] HTTPS actif
- [ ] Pas de clés API exposées dans le code
- [ ] RLS Supabase activé
- [ ] Headers de sécurité configurés

### Mobile
- [ ] Responsive sur mobile
- [ ] PWA installable
- [ ] Navigation mobile fluide

## Support et Aide

### Documentation Vercel
- [Guide Vercel](https://vercel.com/docs)
- [Expo + Vercel](https://docs.expo.dev/distribution/publishing-websites/#vercel)

### Problèmes
- [Vercel Support](https://vercel.com/support)
- [Expo Forums](https://forums.expo.dev/)
- [Supabase Discord](https://discord.supabase.com/)

## Prochaines Étapes

Après déploiement réussi :

1. **Créer les utilisateurs** avec le script SQL
2. **Tester avec utilisateurs réels**
3. **Collecter feedback**
4. **Itérer et améliorer**
5. **Monitorer les erreurs** (Vercel logs)

## Workflow de Mise en Production

```bash
# 1. Développer une fonctionnalité
git checkout -b feature/nouvelle-fonctionnalite

# 2. Commiter les changements
git add .
git commit -m "feat: ajout nouvelle fonctionnalité"

# 3. Pousser et créer PR
git push -u origin feature/nouvelle-fonctionnalite
# Créer Pull Request sur GitHub

# 4. Vercel crée automatiquement un preview deployment
# Tester sur l'URL preview : https://evasion-logistique-git-feature.vercel.app

# 5. Merger la PR
# GitHub → Merge Pull Request

# 6. Vercel déploie automatiquement en production
# URL production mise à jour : https://evasion-logistique.vercel.app
```

---

**Vous êtes prêt à déployer!** 🚀

Suivez les étapes dans l'ordre et votre application sera en ligne en 15 minutes.
