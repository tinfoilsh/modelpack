#!/bin/bash

echo "Starting ollama..."

export OLLAMA_ORIGINS=*
export OLLAMA_HOST=0.0.0.0:11434
export OLLAMA_MODELS=/opt/ollama

( ollama serve ) & serverpid="$!"

echo "Waiting for ollama to start..."
while ! $(ollama ls > /dev/null 2>&1); do
    echo -n .
    sleep 1
done
echo
echo "OLLAMA ready"

echo "Pulling model $MODEL..."
ollama pull "$MODEL"

echo "Stopping ollama..."
kill "$serverpid" && wait "$serverpid"

model_name="$(echo "$MODEL" | tr ':' '-')"
mpk_file="/output/$model_name.mpk"
info_file="/output/$model_name.info"

echo "Generating erofs image..."
mkfs.erofs "$mpk_file" /opt/ollama

echo "Computing alignment..."
SIZE=$(stat -c %s "$mpk_file")
HASH_OFFSET=$(( (($SIZE + 4095) / 4096) * 4096 ))

echo "Running veritysetup..."
veritysetup \
  --hash-offset="$HASH_OFFSET" \
  --root-hash-file="$info_file" \
  format "$mpk_file" "$mpk_file"

echo "-$HASH_OFFSET" >> "$info_file"
