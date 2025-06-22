#!/usr/bin/env bash
set -e

# Download directory
mkdir -p data
FILE="data/student_performance.csv"

# Skip if file already present
if [[ -f "$FILE" ]]; then
    echo "[INFO] $FILE already exists – skip download."
    exit 0
fi

# Verify Kaggle credentials
if [[ ! -f ~/.kaggle/kaggle.json ]]; then
    echo "[ERROR] ~/.kaggle/kaggle.json not found. Please configure Kaggle API token." >&2
    exit 1
fi

echo "[INFO] Downloading dataset from Kaggle..."
kaggle datasets download -d adilshamim8/student-performance-and-learning-style -f student_performance.csv -p data/

# Unzip if necessary
if ls data/*.zip 1>/dev/null 2>&1; then
    unzip -o data/*.zip -d data/
    rm data/*.zip
fi

mv -f data/*student*performance*.csv "$FILE"
echo "[INFO] Saved to $FILE"
