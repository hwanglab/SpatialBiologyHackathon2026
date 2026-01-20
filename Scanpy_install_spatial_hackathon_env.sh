#!/usr/bin/env bash
set -euo pipefail

ENV_NAME="${1:-scanpy_env}"
PY_VER="${2:-3.11}"

echo "== Spatial Hackathon: Scanpy/Squidpy environment setup =="
echo "Environment: ${ENV_NAME}"
echo "Python: ${PY_VER}"
echo

# --- 1) Ensure conda exists ---
if ! command -v conda >/dev/null 2>&1; then
  echo "ERROR: conda not found. Install Miniconda/Anaconda first."
  echo "PPT reference: install Anaconda/Miniconda, then create env with Python 3.11."
  exit 1
fi

# --- 2) Create env if it doesn't exist ---
if conda env list | awk '{print $1}' | grep -qx "${ENV_NAME}"; then
  echo "Conda env '${ENV_NAME}' already exists. Skipping creation."
else
  echo "Creating conda env '${ENV_NAME}' with python=${PY_VER}..."
  conda create -y -n "${ENV_NAME}" "python=${PY_VER}"
fi

# --- 3) Activate env ---
# shellcheck disable=SC1091
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "${ENV_NAME}"

# --- 4) Install packages (conda-forge) ---
echo "Installing core packages from conda-forge..."
conda install -y -c conda-forge \
  scanpy anndata \
  numpy pandas scipy \
  matplotlib seaborn \
  scikit-learn umap-learn numba \
  python-igraph leidenalg \
  squidpy \
  scikit-image \
  h5py pytables pyarrow zarr tifffile \
  jupyterlab ipykernel \
  tqdm

# --- 5) Minimal pip-only additions (optional but useful) ---
echo "Installing a few pip-only spatial add-ons (optional)..."
python -m pip install --upgrade pip
python -m pip install decoupler liana

# --- 6) Register kernel for Jupyter ---
echo "Registering Jupyter kernel..."
python -m ipykernel install --user --name "${ENV_NAME}" --display-name "${ENV_NAME} (py${PY_VER})"

# --- 7) Verification ---
echo
echo "Running quick verification..."
python - <<'PY'
import scanpy as sc
import squidpy as sq
import anndata as ad
import numpy as np
import pandas as pd
import igraph as ig
import leidenalg
print("OK: scanpy", sc.__version__)
print("OK: squidpy", sq.__version__)
print("OK: anndata", ad.__version__)
print("OK: numpy", np.__version__)
print("OK: pandas", pd.__version__)
print("OK: igraph", ig.__version__)
print("OK: leidenalg imported")
PY

echo
echo "✅ Done. Activate with: conda activate ${ENV_NAME}"
echo "✅ Start JupyterLab with: jupyter lab"
