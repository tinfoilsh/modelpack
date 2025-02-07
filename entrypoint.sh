#!/bin/bash

MODEL=qwen:0.5b

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

ollama pull $MODEL

echo "Stopping ollama..."
kill "$serverpid" && wait "$serverpid"

echo "Generating erofs image..."
mkfs.erofs /output/model.erofs /opt/ollama

echo "Computing alignment..."
SIZE=$(stat -c %s /output/model.erofs)
HASH_OFFSET=$(( (($SIZE + 4095) / 4096) * 4096 ))

echo "Running veritysetup..."
veritysetup \
  --hash-offset="$HASH_OFFSET" \
  --root-hash-file=/output/model.info \
  format /output/model.erofs /output/model.erofs

echo "-$HASH_OFFSET" >> /output/model.info
