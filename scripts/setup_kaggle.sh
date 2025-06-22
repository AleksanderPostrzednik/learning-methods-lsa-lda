#!/bin/bash

# Function to print messages
print_msg() {
    echo "[INFO] $1"
}

DATA_FILE="data/student_performance_large_dataset.csv"

# Check if data file already exists
if [ -f "$DATA_FILE" ]; then
    print_msg "Dataset '$DATA_FILE' already exists. Skipping download."
    exit 0
fi

# Check for kaggle.json
if [ ! -f "kaggle.json" ]; then
    echo "[ERROR] kaggle.json not found in the root directory."
    echo "Please download it from your Kaggle account (Account -> Create New API Token) and place it here."
    exit 1
fi

# Setup Kaggle API token
print_msg "Setting up Kaggle API token..."
mkdir -p ~/.kaggle/
cp kaggle.json ~/.kaggle/
chmod 600 ~/.kaggle/kaggle.json

# Download the dataset
print_msg "Downloading dataset from Kaggle..."
# Dataset: https://www.kaggle.com/datasets/adilshamim8/student-performance-and-learning-style
kaggle datasets download -d adilshamim8/student-performance-and-learning-style -p data/ --unzip

# Clean up the downloaded zip file if it exists
if [ -f "data/student-performance-and-learning-style.zip" ]; then
    print_msg "Cleaning up..."
    rm data/student-performance-and-learning-style.zip
fi

print_msg "Setup complete. The dataset is in the 'data/' directory."
