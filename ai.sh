#!/bin/sh

#prereqs
#- env variable OPENAI_API_KEY
#- NOTESPATH, a location for notes; JFHCI for now
#- mdcat, to display output with md formatting

NOTESPATH="$HOME/whereveryournotesgo"

# generate datestamped filename and notes path
FILENAME="file_$(date -u +'%Y%m%dT%H%M%S').md"
FILENAME="$NOTESPATH/$FILENAME"

# clean up newlines so text insertion doesn't cause errors
# FIXME: this is a kludge 

# Check if there's something piped in on STDIN
if [ -p /dev/stdin ]; then
    # Read from STDIN into CONTENT
    CONTENT=$(cat)
else
    # Use the first argument as CONTENT
    CONTENT=$1
fi

CONTENT_CLEAN=$(echo "$CONTENT" | tr -d '\n\\\"')

# Create the timestamped file, starting with the prompt
echo "$1" >>"$FILENAME"
echo "" >>"$FILENAME"

curl -s -q https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "{
  \"model\": \"gpt-4\",
  \"messages\": [{\"role\": \"user\", \"content\": \"$CONTENT_CLEAN\"}],
  \"temperature\": 0
}" | jq -r ".choices[0].message.content // \"ERROR: \" + .error.message" | tee -a "$FILENAME" | mdcat
