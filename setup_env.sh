#!/bin/bash
# Setup script for UV + Conda hybrid environment

set -e  # Exit on error

echo "=== UV + Conda Environment Setup ==="
echo ""

# Check if conda is installed
if ! command -v conda &> /dev/null; then
    echo "ERROR: Conda is not installed"
    echo "Please install Miniconda or Anaconda first"
    echo "https://docs.conda.io/en/latest/miniconda.html"
    exit 1
fi

# Check if UV is installed
if ! command -v uv &> /dev/null; then
    echo "WARNING: UV is not installed"
    echo "Installing UV..."
    pip install uv
fi

echo "Step 1: Creating Conda environment from environment.yml"
echo "-------------------------------------------------------"
conda env create -f environment.yml -y || conda env update -f environment.yml -y

echo ""
echo "Step 2: Activating Conda environment"
echo "-------------------------------------"
echo "Run: conda activate uv-conda-project"
echo ""
echo "Step 3: After activation, install packages with UV"
echo "---------------------------------------------------"
echo "Run: uv sync"
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. conda activate uv-conda-project"
echo "  2. uv sync"
echo "  3. python -c 'import numpy, pandas; print(\"Success!\")'"