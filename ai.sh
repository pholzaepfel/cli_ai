#!/bin/sh

#prereqs
#- env variable OPENAI_API_KEY
#- mdcat, to display output with md formatting
#- jq



# Check if there's something piped in on STDIN
if [ -p /dev/stdin ]; then
    # Read from STDIN into CONTENT
    CONTENT=$(cat)
else
    # Use the first argument as CONTENT
    CONTENT=$1
fi

jq -Rrs --arg str "$CONTENT" '{ "model": "gpt-4o", "messages": [{"role": "user", "content": $str}], "temperature": 0 }' <<< "" > /tmp/ai-payload.js

curl -s -d@/tmp/ai-payload.js -q https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
| jq -r ".choices[0].message.content // \"ERROR: \" + .error.message" | mdcat
