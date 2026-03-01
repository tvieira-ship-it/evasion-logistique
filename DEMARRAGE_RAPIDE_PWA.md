# Démarrage Rapide - Déploiement PWA en 5 minutes

## Option 1 : Vercel (Le plus simple - Recommandé)

### Étapes :

1. **Build de l'application**
```bash
npm run build
```

2. **Installer Vercel CLI**
```bash
npm i -g vercel
```

3. **Déployer**
```bash
vercel
```

4. **Suivre les instructions interactives** :
   - Setup and deploy? → `Y`
   - Which scope? → Votre compte
   - Link to existing project? → `N`
   - Project name? → `evasion-logistique` (ou appuyez sur Entrée)
   - In which directory? → `.` (ou appuyez sur Entrée)
   - Want to override settings? → `N`

5. **✅ C'est fait !**

Votre URL sera affichée : `https://evasion-logistique-xxx.vercel.app`

### Pour les déploiements suivants :

```bash
npm run build
vercel --prod
```

---

## Option 2 : Netlify (Via interface web - Encore plus simple)

### Étapes :

1. **Build de l'application**
```bash
npm run build
```

2. **Aller sur [netlify.com](https://netlify.com)**

3. **Créer un compte gratuit**

4. **Drag & Drop**
   - Glisser le dossier `dist/` sur l'interface Netlify
   - Attendre 30 secondes

5. **✅ C'est déployé !**

URL générée automatiquement : `https://random-name.netlify.app`

### Pour changer le nom :
- Site settings → Change site name → `evasion-logistique`

---

## Option 3 : Firebase Hosting

### Étapes :

1. **Build**
```bash
npm run build
```

2. **Installer Firebase CLI**
```bash
npm i -g firebase-tools
```

3. **Se connecter**
```bash
firebase login
```

4. **Déployer**
```bash
firebase deploy
```

5. **✅ Live !**

URL : `https://evasion-logistique.web.app`

---

## Tester localement avant déploiement

```bash
npm run build
npm run preview
```

Ouvrir : `http://localhost:3000`

---

## Variables d'environnement

**Les plateformes lisent automatiquement le `.env` lors du build.**

Si vous voulez les configurer manuellement :

### Vercel
```bash
vercel env add EXPO_PUBLIC_SUPABASE_URL
vercel env add EXPO_PUBLIC_SUPABASE_ANON_KEY
```

### Netlify
Dans l'interface : Site settings → Environment variables

### Firebase
Les variables sont lues depuis `.env` automatiquement

---

## Après déploiement

### Tester l'installation PWA

**Desktop (Chrome/Edge)** :
1. Ouvrir l'URL
2. Cliquer sur l'icône d'installation dans la barre d'adresse
3. Installer

**Mobile (Safari iOS)** :
1. Ouvrir l'URL dans Safari
2. Partager → Sur l'écran d'accueil

**Mobile (Chrome Android)** :
1. Ouvrir l'URL
2. Menu → Installer l'application

---

## Domaine personnalisé

### Sur Vercel
```bash
vercel domains add votre-domaine.com
```
Suivre les instructions DNS

### Sur Netlify
Interface → Domain settings → Add custom domain

---

## Commandes utiles

```bash
# Build
npm run build

# Preview local
npm run preview

# Deploy Vercel
npm run deploy:vercel

# Deploy Netlify
npm run deploy:netlify

# Deploy Firebase
npm run deploy:firebase
```

---

## Dépannage rapide

### Erreur de build
```bash
# Nettoyer et rebuilder
rm -rf dist node_modules/.cache
npm run build
```

### Variables d'environnement manquantes
Vérifier que `.env` contient :
```env
EXPO_PUBLIC_SUPABASE_URL=https://...
EXPO_PUBLIC_SUPABASE_ANON_KEY=eyJ...
```

### Page blanche après déploiement
- Vérifier la console navigateur (F12)
- Vérifier que les variables d'environnement sont configurées
- Vérifier CORS sur Supabase

---

## Configuration CORS Supabase (Important !)

Dans Supabase Dashboard :
1. Settings → API
2. CORS Allowed Origins
3. Ajouter votre URL de déploiement :
   - `https://evasion-logistique.vercel.app`
   - ou `https://votre-domaine.com`

---

## Monitoring

### Vercel Analytics (gratuit)
```bash
vercel analytics enable
```

### Voir les logs
```bash
vercel logs
```

---

## Support

**Documentation complète** : Voir `DEPLOIEMENT_PWA.md`

**Problèmes courants** :
- ❌ Page blanche → Console navigateur (F12)
- ❌ 404 sur les routes → Vérifier les rewrites (voir config)
- ❌ Variables env → Vérifier `.env` et config plateforme

---

## Checklist avant déploiement

- [x] Build réussit : `npm run build`
- [x] Test local : `npm run preview`
- [x] Variables `.env` configurées
- [x] CORS Supabase configuré
- [ ] Test sur mobile et desktop
- [ ] Test installation PWA

---

**Votre application est prête ! Le déploiement prend littéralement 2-3 minutes. 🚀**
