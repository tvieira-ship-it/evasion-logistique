# ✅ Checklist de Déploiement PWA

## Avant le déploiement

### 1. Vérifications locales

- [ ] Le build fonctionne : `npm run build`
  ```bash
  npm run build
  # Doit afficher : "Exported: dist"
  ```

- [ ] Prévisualisation locale fonctionne : `npm run preview`
  ```bash
  npm run preview
  # Ouvrir http://localhost:3000
  ```

- [ ] Test de connexion fonctionne
  - [ ] Page de login s'affiche correctement
  - [ ] Connexion avec un utilisateur test réussit
  - [ ] Dashboard s'affiche après connexion

### 2. Configuration Supabase

- [ ] Variables d'environnement vérifiées dans `.env`
  ```bash
  cat .env
  # Doit contenir EXPO_PUBLIC_SUPABASE_URL et EXPO_PUBLIC_SUPABASE_ANON_KEY
  ```

- [ ] RLS activée sur toutes les tables
  - [ ] Aller sur Supabase Dashboard → Database → Tables
  - [ ] Vérifier que "RLS enabled" est coché pour chaque table

- [ ] Au moins un utilisateur de test existe
  - [ ] Aller sur Supabase Dashboard → Authentication → Users
  - [ ] Créer un utilisateur si nécessaire

### 3. Fichiers de configuration

- [x] `app.json` - Configuration PWA (déjà fait ✅)
- [x] `vercel.json` - Configuration Vercel (déjà fait ✅)
- [x] `netlify.toml` - Configuration Netlify (déjà fait ✅)
- [x] `firebase.json` - Configuration Firebase (déjà fait ✅)

## Déploiement sur Vercel (Recommandé)

### Étape 1 : Installation

```bash
npm i -g vercel
```

### Étape 2 : Connexion

```bash
vercel login
# Suivre les instructions
```

### Étape 3 : Déploiement

```bash
npm run build
vercel
```

**Questions attendues** :
- Setup and deploy? → `Y`
- Which scope? → Choisir votre compte
- Link to existing project? → `N` (première fois)
- Project name? → `evasion-logistique` (ou autre)
- In which directory? → `.` (appuyer sur Entrée)
- Want to override settings? → `N`

### Étape 4 : Déploiement en production

```bash
vercel --prod
```

✅ **URL générée** : `https://evasion-logistique-xxx.vercel.app`

### Étape 5 : Configuration CORS sur Supabase

1. Aller sur Supabase Dashboard
2. Settings → API
3. Section "CORS Allowed Origins"
4. Ajouter votre URL Vercel : `https://evasion-logistique-xxx.vercel.app`
5. Sauvegarder

## Après le déploiement

### 1. Tests essentiels

- [ ] **Page de connexion** : Ouvrir l'URL
  - [ ] La page se charge correctement
  - [ ] Pas d'erreur dans la console (F12)

- [ ] **Connexion utilisateur**
  - [ ] Se connecter avec un compte test
  - [ ] Redirection vers dashboard fonctionne
  - [ ] Données s'affichent correctement

- [ ] **Navigation**
  - [ ] Tester chaque onglet du menu
  - [ ] Vérifier qu'il n'y a pas d'erreurs 404

- [ ] **Responsive**
  - [ ] Tester sur mobile (ou mode mobile navigateur)
  - [ ] Tester sur tablette
  - [ ] Tester sur desktop

### 2. Test d'installation PWA

#### Sur Desktop (Chrome/Edge)

- [ ] Ouvrir l'URL dans Chrome/Edge
- [ ] Vérifier l'icône d'installation dans la barre d'adresse
- [ ] Cliquer et installer
- [ ] Ouvrir l'app installée
- [ ] Vérifier qu'elle s'ouvre en fenêtre standalone (pas de barre d'adresse)

#### Sur Mobile (iOS Safari)

- [ ] Ouvrir l'URL dans Safari
- [ ] Taper sur "Partager" (icône carré avec flèche)
- [ ] Sélectionner "Sur l'écran d'accueil"
- [ ] Vérifier que l'icône apparaît
- [ ] Ouvrir l'app depuis l'icône
- [ ] Vérifier qu'elle s'ouvre en plein écran

#### Sur Mobile (Android Chrome)

- [ ] Ouvrir l'URL dans Chrome
- [ ] Vérifier la notification "Ajouter à l'écran d'accueil"
- [ ] Installer
- [ ] Ouvrir depuis l'icône
- [ ] Vérifier le mode plein écran

### 3. Performance

- [ ] **Lighthouse** : Tester les performances
  ```
  1. Ouvrir DevTools (F12)
  2. Onglet "Lighthouse"
  3. Sélectionner "Progressive Web App"
  4. Cliquer "Generate report"
  5. Score PWA devrait être > 90
  ```

- [ ] **Temps de chargement** < 3 secondes

### 4. Monitoring

- [ ] **Vercel Analytics** (optionnel)
  ```bash
  vercel analytics enable
  ```

- [ ] **Console logs** : Vérifier qu'il n'y a pas d'erreurs
  - Ouvrir F12 → Console
  - Naviguer dans l'app
  - Vérifier qu'il n'y a pas d'erreurs rouges

## Configuration du domaine personnalisé (Optionnel)

### Sur Vercel

1. Dans le dashboard Vercel, aller sur votre projet
2. Settings → Domains
3. Cliquer "Add"
4. Entrer votre domaine (ex: app.evasion-logistique.fr)
5. Suivre les instructions DNS

### Configuration DNS

Ajouter un enregistrement CNAME :
```
Type: CNAME
Name: app (ou www)
Value: caa.vercel-dns.com
TTL: Auto
```

Attendre 5-30 minutes pour la propagation DNS.

### Mettre à jour CORS Supabase

Ajouter votre nouveau domaine dans les CORS allowed origins.

## Formation des utilisateurs

### 1. Préparer les instructions

Créer un document simple :

```
EVASION LOGISTIQUE - Accès à l'application

🌐 URL : https://votre-app.vercel.app

📱 Sur mobile :
1. Ouvrir le lien dans Safari (iOS) ou Chrome (Android)
2. Ajouter à l'écran d'accueil (optionnel mais recommandé)
3. Se connecter avec vos identifiants

💻 Sur ordinateur :
1. Ouvrir le lien dans Chrome ou Edge
2. Installer l'application (icône dans la barre d'adresse)
3. Se connecter avec vos identifiants

🔐 Identifiants :
Email : votre.email@entreprise.com
Mot de passe : (fourni séparément)

❓ Support : contact@votre-entreprise.com
```

### 2. Créer les comptes utilisateurs

Pour chaque utilisateur :

1. Aller sur Supabase Dashboard → Authentication → Users
2. Cliquer "Invite user"
3. Entrer l'email
4. L'utilisateur recevra un email pour définir son mot de passe

Ou utiliser la fonction Edge : `create-user`

### 3. Test avec 2-3 utilisateurs pilotes

- [ ] Identifier 2-3 utilisateurs pilotes
- [ ] Leur envoyer les instructions
- [ ] Faire un appel de 10 min pour les accompagner
- [ ] Recueillir leurs feedbacks
- [ ] Ajuster si nécessaire

## Maintenance et Mises à jour

### Pour déployer une mise à jour

```bash
# 1. Faire vos modifications dans le code

# 2. Build
npm run build

# 3. Deploy
vercel --prod

# ✅ Tous les utilisateurs ont la nouvelle version instantanément !
```

### Rollback en cas de problème

```bash
# Voir les déploiements
vercel ls

# Promouvoir un ancien déploiement
vercel promote <deployment-url>
```

## Checklist de sécurité

- [ ] HTTPS activé (automatique avec Vercel ✅)
- [ ] CORS configuré sur Supabase
- [ ] RLS activée sur toutes les tables Supabase
- [ ] Pas de secrets dans le code (vérifier `.gitignore`)
- [ ] Variables d'environnement sécurisées
- [ ] Politique de mots de passe forte pour les utilisateurs

## Support et Dépannage

### Problèmes courants

**Page blanche** :
1. Ouvrir la console (F12)
2. Vérifier les erreurs
3. Vérifier CORS Supabase
4. Vérifier les variables d'environnement

**404 sur les routes** :
1. Vérifier `vercel.json` (rewrites)
2. Redéployer si nécessaire

**Données ne se chargent pas** :
1. Vérifier RLS sur Supabase
2. Vérifier les policies
3. Vérifier la connexion réseau
4. Consulter les logs Supabase

### Logs et Debugging

```bash
# Voir les logs Vercel en temps réel
vercel logs

# Voir les déploiements
vercel ls
```

## 🎉 Félicitations !

Si tous les points sont cochés, votre PWA est en production ! 🚀

**Prochaines étapes** :
1. Former tous les utilisateurs
2. Monitorer l'usage pendant 1 semaine
3. Recueillir les feedbacks
4. Planifier les améliorations

---

**Besoin d'aide ?**
- Documentation complète : `DEPLOIEMENT_PWA.md`
- Démarrage rapide : `DEMARRAGE_RAPIDE_PWA.md`
- Résumé : `PWA_RESUME.md`
