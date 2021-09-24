#!/bin/bash

#shellcheck disable=SC2046,SC2196

# Unload previous .env values
unset $(egrep '^[^# ]\S+=\S+' .env | sed -E 's/(.*)=.*/\1/' | xargs -0)

# Load your .env values
export $(egrep '^[^# ]\S+=\S+' .env | xargs -0)

# Constants
PRODUCTION_URL="https://buy.itunes.apple.com/verifyReceipt"
SANDBOX_URL="https://sandbox.itunes.apple.com/verifyReceipt"
VERB=POST
CONTENT_TYPE="application/json"
DATA_COMMAND="--data"

# Define URL based on iTunes environment
if [ -z "$ItunesEnvironment" ]; then
  echo "Set an itunes environment value"
  echo "Set in .env"
  exit 1
fi
if [ "$ItunesEnvironment" == "production" ]; then
  URL="$PRODUCTION_URL"
elif [ "$ItunesEnvironment" == "sandbox" ]; then
  URL="$SANDBOX_URL"
else
  echo "Unknown itunes environment"
  exit 1
fi

# iTunes Connect Password
if [ -z "$SECRET" ]; then
  echo "Missing app secret value"
  echo "Set in .env"
  exit 1
fi

# Read in the receipt
RECEIPT=$(<receipt)
if [ -z "$RECEIPT" ]; then
  echo "Missing receipt"
  echo "Add a new file to this directory named 'receipt' with a base64 encoded receipt."
  exit 1
fi

# Form POST JSON body
JSON_BODY=$( jq -n \
                  --arg apiKey "$SECRET" \
                  --arg receipt "$RECEIPT" \
                  '{password: $apiKey, "receipt-data": $receipt}' )

# Validate receipt
curl -v \
  -H "Content-Type: $CONTENT_TYPE" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $SESSION_TOKEN" \
  -X "$VERB" "$DATA_COMMAND" "$JSON_BODY" \
  "$URL" | jq .
