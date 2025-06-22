#!/usr/bin/env bash
set -euo pipefail

# Directory for data files
DATA_DIR="$(dirname "$0")/../data"
mkdir -p "$DATA_DIR"

# Configure Kaggle credentials if kaggle.json provided in repo root
if [ ! -f ~/.kaggle/kaggle.json ]; then
  if [ -f kaggle.json ]; then
    mkdir -p ~/.kaggle
    cp kaggle.json ~/.kaggle/
    chmod 600 ~/.kaggle/kaggle.json
  else
    echo "Error: Kaggle API token not found. Place kaggle.json in repo root or ~/.kaggle/" >&2
    exit 1
  fi
fi

# Download dataset
kaggle datasets download -d adilshamim8/student-performance-and-learning-style -p "$DATA_DIR"

# Unzip and clean up
ZIP_FILE="$DATA_DIR/student-performance-and-learning-style.zip"
if [ -f "$ZIP_FILE" ]; then
  unzip -o "$ZIP_FILE" -d "$DATA_DIR"
  rm "$ZIP_FILE"
fi

# Optionally rename main csv to expected name
MAIN_CSV=$(ls "$DATA_DIR"/*.csv 2>/dev/null | head -n 1)
if [ -n "$MAIN_CSV" ] && [ ! -f "$DATA_DIR/student_performance_large_dataset.csv" ]; then
  mv "$MAIN_CSV" "$DATA_DIR/student_performance_large_dataset.csv"
fi

echo "Data downloaded to $DATA_DIR"
