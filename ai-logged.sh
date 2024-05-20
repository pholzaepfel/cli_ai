#!/bin/sh

#prereqs
#- env variable OPENAI_API_KEY
#- NOTESPATH, a location for notes; JFHCI for now
#- mdcat, to display output with md formatting

NOTESPATH="$HOME/whereveryournotesgo"

# generate datestamped filename and notes path
FILENAME="file_$(date -u +'%Y%m%dT%H%M%S').md"
FILENAME="$NOTESPATH/$FILENAME"

# Check if there's something piped in on STDIN
if [ -p /dev/stdin ]; then
    # Read from STDIN into CONTENT
    CONTENT=$(cat)
else
    # Use the first argument as CONTENT
    CONTENT=$1
fi

# Escape newlines
CONTENT_CLEAN=$(echo "$CONTENT" | sed -e 's/\"/\\"/g')

# Create the timestamped file, starting with the prompt
echo "$1" >>"$FILENAME"
echo "" >>"$FILENAME"

cat <<EOF > /tmp/ai-payload.js
{
  "model": "gpt-4o",
  "messages": [{"role": "user", "content": "$CONTENT_CLEAN"}],
  "temperature": 0
}
EOF

curl -s -d@/tmp/ai-payload.js -q https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
| jq -r ".choices[0].message.content // \"ERROR: \" + .error.message" | tee -a "$FILENAME" | mdcat
