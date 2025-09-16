#!/bin/bash

# ===== CONFIG =====
PORT=3000
ENV_FILE=".env"
MPESA_CONSUMER_KEY="VGGQnmrPivJ4uzQvhTfgr7DLYlAurlPD3M9gHjL0IgUU9zaz"
MPESA_CONSUMER_SECRET="VJCMpHXcC2A4GCAXgU2kMAND1ewQitshNMBUspjcaO5bSf32JijZkKbjpPFHBGoH"
MPESA_SHORTCODE="174379"

# Sandbox-friendly paths (avoid /mpesa/ in URL)
CONFIRMATION_PATH="/payment/confirmation"
VALIDATION_PATH="/payment/validation"

# ===== PRE-CHECKS =====
# Kill any old ngrok sessions
pkill -f ngrok >/dev/null 2>&1

# Install jq if missing
if ! command -v jq &> /dev/null; then
  echo "📦 Installing jq..."
  sudo apt update && sudo apt install jq -y
fi

# ===== START NGROK =====
echo "🚀 Starting ngrok on port $PORT..."
ngrok http $PORT > /dev/null &

# Wait for ngrok to start
sleep 5

# Get the public URL from ngrok's local API
NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels \
  | grep -o 'https://[a-z0-9.-]*\.ngrok-free\.app' | head -n 1)

if [ -z "$NGROK_URL" ]; then
  echo "❌ Could not get ngrok URL. Is ngrok running?"
  exit 1
fi

echo "✅ ngrok public URL: $NGROK_URL"

# ===== UPDATE .env =====
if [ -f "$ENV_FILE" ]; then
  sed -i "s|^APP_URL=.*|APP_URL=$NGROK_URL|" "$ENV_FILE"
else
  echo "APP_URL=$NGROK_URL" > "$ENV_FILE"
fi
echo "✅ Updated $ENV_FILE with APP_URL=$NGROK_URL"

# ===== GET MPESA ACCESS TOKEN =====
ACCESS_TOKEN=$(curl -s -u "$MPESA_CONSUMER_KEY:$MPESA_CONSUMER_SECRET" \
  "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials" \
  | jq -r .access_token)

if [ -z "$ACCESS_TOKEN" ] || [ "$ACCESS_TOKEN" == "null" ]; then
  echo "❌ Failed to get M-Pesa access token"
  exit 1
fi
echo "✅ Got M-Pesa access token"

# ===== REGISTER CALLBACK URLS =====
CONFIRMATION_URL="$NGROK_URL$CONFIRMATION_PATH"
VALIDATION_URL="$NGROK_URL$VALIDATION_PATH"

REGISTER_RESPONSE=$(curl -s -X POST \
  "https://sandbox.safaricom.co.ke/mpesa/c2b/v1/registerurl" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"ShortCode\": \"$MPESA_SHORTCODE\",
    \"ResponseType\": \"Completed\",
    \"ConfirmationURL\": \"$CONFIRMATION_URL\",
    \"ValidationURL\": \"$VALIDATION_URL\"
  }")

echo "✅ Registered M-Pesa sandbox callback URLs:"
echo "   Confirmation: $CONFIRMATION_URL"
echo "   Validation:   $VALIDATION_URL"
echo "   API Response: $REGISTER_RESPONSE"

# ===== START RAILS =====
echo "🚀 Starting Rails server..."
pkill -f puma >/dev/null 2>&1
bin/rails server -b 0.0.0.0
