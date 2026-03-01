# Guide de Déploiement PWA - Evasion Logistique

## Qu'est-ce qu'une PWA ?

Une Progressive Web App (PWA) est une application web qui se comporte comme une application native :
- **Installable** : Les utilisateurs peuvent l'ajouter à leur écran d'accueil
- **Hors ligne** : Fonctionne même sans connexion internet (cache)
- **Rapide** : Chargement instantané
- **Sécurisée** : Requiert HTTPS
- **Responsive** : S'adapte à tous les écrans (mobile, tablette, desktop)

## Configuration PWA

Votre application est maintenant configurée comme PWA avec :

### Paramètres PWA (app.json)
- **Name** : "Evasion Logistique"
- **Short Name** : "Evasion"
- **Display Mode** : "standalone" (se comporte comme une app native)
- **Theme Color** : #2563eb (bleu de votre brand)
- **Background Color** : #ffffff (blanc)
- **Start URL** : "/" (page de connexion)

## Build de Production

Pour créer votre PWA, exécutez :

```bash
npm run build:web
```

Cette commande génère le dossier `dist/` qui contient :
- `index.html` : Point d'entrée
- `manifest.json` : Configuration PWA
- `_expo/static/js/` : Code JavaScript optimisé
- `_expo/static/css/` : Styles CSS
- Assets (images, fonts, etc.)

## Options de Déploiement

### Option 1 : Vercel (Recommandé - Gratuit)

**Avantages** :
- Gratuit pour usage commercial
- HTTPS automatique
- CDN global ultra-rapide
- Déploiement en 2 minutes
- Domaine personnalisé inclus

**Étapes** :
1. Créer un compte sur [vercel.com](https://vercel.com)
2. Installer Vercel CLI : `npm i -g vercel`
3. Dans le dossier du projet : `vercel`
4. Suivre les instructions
5. URL générée automatiquement (ex: evasion-logistique.vercel.app)

**Configuration Vercel** :
Créer un fichier `vercel.json` :
```json
{
  "buildCommand": "npm run build:web",
  "outputDirectory": "dist",
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

### Option 2 : Netlify (Alternative gratuite)

**Avantages** :
- Gratuit
- HTTPS automatique
- Formulaires intégrés
- Facile à utiliser

**Étapes** :
1. Créer un compte sur [netlify.com](https://netlify.com)
2. Connecter votre repo Git ou drag & drop le dossier `dist/`
3. Build settings :
   - Build command : `npm run build:web`
   - Publish directory : `dist`
4. Deploy

**Configuration Netlify** :
Créer un fichier `netlify.toml` :
```toml
[build]
  command = "npm run build:web"
  publish = "dist"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### Option 3 : Serveur propre (VPS, Cloud)

Si vous avez votre propre serveur :

1. **Nginx** :
```nginx
server {
    listen 80;
    server_name votre-domaine.com;

    # Redirection HTTPS obligatoire pour PWA
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name votre-domaine.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    root /var/www/evasion-logistique/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache des assets
    location /_expo/static/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

2. **Apache** :
```apache
<VirtualHost *:443>
    ServerName votre-domaine.com
    DocumentRoot /var/www/evasion-logistique/dist

    SSLEngine on
    SSLCertificateFile /path/to/cert.pem
    SSLCertificateKeyFile /path/to/key.pem

    <Directory /var/www/evasion-logistique/dist>
        Options -MultiViews
        AllowOverride All
        Require all granted

        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>

    # Cache des assets
    <LocationMatch "/_expo/static/">
        Header set Cache-Control "max-age=31536000, public, immutable"
    </LocationMatch>
</VirtualHost>
```

### Option 4 : Firebase Hosting

**Avantages** :
- Gratuit jusqu'à 10 GB
- CDN Google
- HTTPS automatique

**Étapes** :
1. Installer Firebase CLI : `npm i -g firebase-tools`
2. `firebase login`
3. `firebase init hosting`
   - Public directory : `dist`
   - Configure as single-page app : Yes
4. `firebase deploy`

## Variables d'environnement

**IMPORTANT** : Les variables sont déjà dans `.env`, mais pour la production :

1. **Vercel/Netlify** : Ajouter dans les settings du projet :
   - `EXPO_PUBLIC_SUPABASE_URL`
   - `EXPO_PUBLIC_SUPABASE_ANON_KEY`

2. **Serveur propre** : Créer `.env.production` :
```env
EXPO_PUBLIC_SUPABASE_URL=https://fsyzgtbnntkqeftgyukr.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=votre_cle_anon
```

## Installation PWA par les Utilisateurs

### Sur Desktop (Chrome, Edge, Brave)
1. Visiter l'URL de l'app
2. Icône "Installer" dans la barre d'adresse
3. Cliquer sur "Installer"
4. L'app s'ouvre dans sa propre fenêtre

### Sur Mobile (iOS Safari)
1. Ouvrir l'URL dans Safari
2. Taper l'icône "Partager" (carré avec flèche)
3. "Sur l'écran d'accueil"
4. L'icône apparaît comme une vraie app

### Sur Mobile (Android Chrome)
1. Ouvrir l'URL dans Chrome
2. Menu (3 points) → "Installer l'application"
3. Ou notification automatique "Ajouter à l'écran d'accueil"

## Avantages de la PWA pour Evasion Logistique

1. **Pas d'App Store** : Pas de validation Apple/Google (économie de temps et frais)
2. **Mises à jour instantanées** : Déployez, c'est live pour tous
3. **Un seul code** : Web + Mobile + Desktop
4. **Toujours à jour** : Pas de versions différentes à gérer
5. **Installation optionnelle** : Utilisable directement dans le navigateur
6. **Cross-platform** : Fonctionne sur tous les OS
7. **Accès universel** : Simple URL à partager

## Domaine Personnalisé

Pour utiliser votre propre domaine (ex: app.evasion-logistique.fr) :

### Vercel/Netlify
1. Aller dans les settings du projet
2. Section "Domains"
3. Ajouter votre domaine
4. Configurer les DNS (instructions fournies)

### DNS à configurer
```
Type: CNAME
Name: app (ou www)
Value: votre-app.vercel.app (ou netlify.app)
```

## Performance et Optimisation

Votre PWA est déjà optimisée avec :
- **Code splitting** : Chargement progressif
- **Tree shaking** : Suppression du code inutilisé
- **Compression** : Gzip/Brotli automatique
- **Cache** : Assets mis en cache navigateur
- **Lazy loading** : Chargement à la demande

## Monitoring et Analytics

Pour suivre l'usage :

1. **Google Analytics** : Ajouter dans `app/_layout.tsx`
2. **Sentry** : Suivi des erreurs
3. **Vercel Analytics** : Intégré gratuitement

## Support et Compatibilité

Votre PWA fonctionne sur :
- ✅ Chrome (Desktop & Mobile)
- ✅ Edge (Desktop & Mobile)
- ✅ Safari (Desktop & iOS 11.3+)
- ✅ Firefox (Desktop & Mobile)
- ✅ Samsung Internet
- ✅ Opera

## Checklist avant déploiement

- [ ] Build réussit sans erreur : `npm run build:web`
- [ ] Variables d'environnement configurées
- [ ] HTTPS activé (obligatoire pour PWA)
- [ ] Test sur mobile et desktop
- [ ] Vérifier que l'installation PWA fonctionne
- [ ] Test de toutes les fonctionnalités majeures
- [ ] Configuration CORS Supabase (déjà fait)

## Commandes Utiles

```bash
# Build de production
npm run build:web

# Tester localement le build
npx serve dist

# Vérifier la taille du bundle
npm run build:web && du -sh dist

# Analyser le bundle
npx expo export:web --analyze
```

## URLs de test recommandées

Après déploiement, tester ces URLs :
- `/login` : Page de connexion
- `/dashboard` : Tableau de bord
- `/call-center` : Centre d'appel
- `/logistique` : Vue logistique
- `/affectation` : Affectation chauffeurs
- `/historique-commandes` : Historique

## Support

Pour toute question :
1. Vérifier les logs Vercel/Netlify
2. Console navigateur (F12)
3. Network tab pour voir les requêtes
4. Application tab pour voir le service worker

## Prochaines étapes possibles

1. **Notifications Push** : Alerter les chauffeurs/logistique
2. **Mode hors ligne** : Cache des données avec Workbox
3. **Géolocalisation** : Tracking temps réel des chauffeurs
4. **Scan QR Code** : Validation rapide des livraisons

---

**Votre application est prête pour la production en PWA ! 🚀**
