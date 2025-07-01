#!/bin/bash

set -e

DATA_DIR="data"
ZIP_FILE="$DATA_DIR/sentiment140.zip"
CSV_FILE="$DATA_DIR/sentiment140.csv"
URL="https://cs.stanford.edu/people/alecmgo/trainingandtestdata.zip"

mkdir -p "$DATA_DIR"

if [ -f "$CSV_FILE" ]; then
  echo "[INFO] Dataset '$CSV_FILE' already exists. Skipping download."
  exit 0
fi

echo "[INFO] Downloading Sentiment140 dataset..."
curl -L "$URL" -o "$ZIP_FILE"

if [ $? -eq 0 ]; then
  echo "[INFO] Extracting CSV..."
  unzip -p "$ZIP_FILE" training.1600000.processed.noemoticon.csv > "$CSV_FILE"
  rm "$ZIP_FILE"
  echo "[INFO] Dataset ready at '$CSV_FILE'."
else
  echo "[ERROR] Download failed." >&2
  exit 1
fi
