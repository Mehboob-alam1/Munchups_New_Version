#!/bin/bash

# Script per testare se l'endpoint Stripe esiste sul server

echo "🔍 Testing Stripe Connect Endpoint..."
echo ""

BASE_URL="https://munchups.com/webservice/"
ENDPOINTS=(
  "connect_stripe_account.php"
  "stripe_connect_account.php"
  "stripe_connect.php"
  "connect_stripe.php"
  "create_stripe_account.php"
  "stripe_account_connect.php"
)

echo "Testing endpoints on: $BASE_URL"
echo ""

for endpoint in "${ENDPOINTS[@]}"; do
  URL="${BASE_URL}${endpoint}"
  echo "Testing: $URL"
  
  # Test with POST request
  RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$URL" \
    -d "user_id=123&user_type=chef&email=test@example.com" \
    -H "Content-Type: application/x-www-form-urlencoded" 2>&1)
  
  HTTP_CODE=$(echo "$RESPONSE" | tail -1)
  
  if [ "$HTTP_CODE" == "200" ]; then
    echo "✅ Found working endpoint: $endpoint (HTTP $HTTP_CODE)"
    echo ""
    echo "Full response:"
    curl -X POST "$URL" \
      -d "user_id=123&user_type=chef&email=test@example.com" \
      -H "Content-Type: application/x-www-form-urlencoded"
    echo ""
    break
  elif [ "$HTTP_CODE" == "404" ]; then
    echo "❌ Not found: $endpoint (HTTP $HTTP_CODE)"
  else
    echo "⚠️  Status: $endpoint (HTTP $HTTP_CODE)"
  fi
  echo ""
done

echo ""
echo "📝 If all endpoints return 404, the backend endpoint needs to be created."
echo "See STRIPE_BACKEND_SETUP.md for implementation details."

