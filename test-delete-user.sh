#!/bin/bash

# Test de suppression d'utilisateur
SUPABASE_URL="https://fsyzgtbnntkqeftgyukr.supabase.co"
ANON_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZzeXpndGJubnRrcWVmdGd5dWtyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIyNzAwMzAsImV4cCI6MjA4Nzg0NjAzMH0.uL6pVbjBItsJDtpCyWbDXShm868eSCUZTMMweeVtEWE"

# Remplacez ces valeurs par vos identifiants super-admin
ADMIN_EMAIL="admin@evasion-logistique.fr"
ADMIN_PASSWORD="AdminPassword123!"

echo "1. Connexion en tant que super-admin..."
LOGIN_RESPONSE=$(curl -s -X POST "${SUPABASE_URL}/auth/v1/token?grant_type=password" \
  -H "apikey: ${ANON_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"${ADMIN_EMAIL}\",\"password\":\"${ADMIN_PASSWORD}\"}")

ACCESS_TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$ACCESS_TOKEN" ]; then
  echo "Erreur de connexion: $LOGIN_RESPONSE"
  exit 1
fi

echo "✓ Connexion réussie"
echo ""

# Récupérer l'ID d'un utilisateur à supprimer (utilisez l'interface pour créer un utilisateur de test d'abord)
echo "2. Listage des utilisateurs existants..."
echo "Veuillez créer un utilisateur via l'interface web et noter son ID"
echo ""

# Pour tester, remplacez USER_ID_TO_DELETE par l'ID de l'utilisateur à supprimer
USER_ID_TO_DELETE="REMPLACER_PAR_ID_UTILISATEUR"

if [ "$USER_ID_TO_DELETE" = "REMPLACER_PAR_ID_UTILISATEUR" ]; then
  echo "⚠️  Veuillez d'abord modifier ce script avec l'ID de l'utilisateur à supprimer"
  exit 0
fi

echo "3. Suppression de l'utilisateur $USER_ID_TO_DELETE..."
DELETE_RESPONSE=$(curl -s -X POST "${SUPABASE_URL}/functions/v1/delete-user" \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "apikey: ${ANON_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"user_id\":\"${USER_ID_TO_DELETE}\"}")

echo "Réponse: $DELETE_RESPONSE"
echo ""

if echo "$DELETE_RESPONSE" | grep -q '"success":true'; then
  echo "✓ Suppression réussie!"
else
  echo "✗ Échec de la suppression"
fi
