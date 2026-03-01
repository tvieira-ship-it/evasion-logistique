#!/bin/bash

# Script pour préparer le projet pour GitHub
# Exécutez ce script avec: bash export-to-github.sh

echo "Préparation du projet pour GitHub..."

# Créer un dossier temporaire
EXPORT_DIR="evasion-logistique-export"
rm -rf "$EXPORT_DIR"
mkdir -p "$EXPORT_DIR"

# Copier tous les fichiers nécessaires
echo "Copie des fichiers..."

# Fichiers de configuration racine
cp .gitignore "$EXPORT_DIR/" 2>/dev/null || echo "Note: .gitignore non trouvé"
cp .prettierrc "$EXPORT_DIR/" 2>/dev/null
cp .firebaserc "$EXPORT_DIR/" 2>/dev/null
cp package.json "$EXPORT_DIR/"
cp package-lock.json "$EXPORT_DIR/"
cp tsconfig.json "$EXPORT_DIR/"
cp expo-env.d.ts "$EXPORT_DIR/"
cp app.json "$EXPORT_DIR/"
cp firebase.json "$EXPORT_DIR/" 2>/dev/null
cp netlify.toml "$EXPORT_DIR/" 2>/dev/null
cp vercel.json "$EXPORT_DIR/" 2>/dev/null

# Documentation
cp *.md "$EXPORT_DIR/" 2>/dev/null
cp *.txt "$EXPORT_DIR/" 2>/dev/null
cp *.sh "$EXPORT_DIR/" 2>/dev/null

# Copier les dossiers
echo "Copie des dossiers..."
cp -r app "$EXPORT_DIR/"
cp -r components "$EXPORT_DIR/"
cp -r contexts "$EXPORT_DIR/"
cp -r hooks "$EXPORT_DIR/"
cp -r lib "$EXPORT_DIR/"
cp -r types "$EXPORT_DIR/"
cp -r assets "$EXPORT_DIR/"
cp -r supabase "$EXPORT_DIR/"
cp -r scripts "$EXPORT_DIR/"
cp -r docs "$EXPORT_DIR/" 2>/dev/null
cp -r .bolt "$EXPORT_DIR/" 2>/dev/null
cp -r .github "$EXPORT_DIR/" 2>/dev/null

# Créer un .env.example (sans les vraies valeurs)
echo "Création de .env.example..."
cat > "$EXPORT_DIR/.env.example" << 'EOF'
# Supabase Configuration
EXPO_PUBLIC_SUPABASE_URL=your_supabase_url
EXPO_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key

# Stripe Configuration (optionnel)
STRIPE_SECRET_KEY=your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=your_stripe_webhook_secret
EOF

# Créer un README pour l'installation
cat > "$EXPORT_DIR/INSTALLATION.md" << 'EOF'
# Installation

## 1. Cloner le repository

```bash
git clone https://github.com/tvieira-ship-it/evasion-logistique.git
cd evasion-logistique
```

## 2. Installer les dépendances

```bash
npm install
```

## 3. Configurer les variables d'environnement

Copiez `.env.example` vers `.env` et remplissez les valeurs:

```bash
cp .env.example .env
```

## 4. Lancer l'application

```bash
npm run dev
```

## 5. Déploiement

Voir `DEPLOIEMENT_PWA.md` pour les instructions de déploiement.
EOF

echo ""
echo "✅ Export terminé!"
echo ""
echo "Le dossier '$EXPORT_DIR' contient tous les fichiers du projet."
echo ""
echo "Prochaines étapes:"
echo "1. Compressez le dossier '$EXPORT_DIR' en ZIP"
echo "2. Allez sur https://github.com/tvieira-ship-it/evasion-logistique"
echo "3. Cliquez sur 'Add file' → 'Upload files'"
echo "4. Glissez-déposez tous les fichiers du dossier (pas le ZIP)"
echo "5. Ajoutez un message de commit et validez"
echo ""
