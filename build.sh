#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_root"

venv_path="$repo_root/.venv"
venv_python="$venv_path/bin/python"
venv_dbt="$venv_path/bin/dbt"
requirements_file="$repo_root/requirements.txt"
python_version="3.13"

if [ ! -f "$requirements_file" ]; then
    echo "requirements.txt was not found at $requirements_file" >&2
    exit 1
fi

export PATH="$HOME/.local/bin:$PATH"

if ! command -v uv >/dev/null 2>&1; then
    echo "uv not found. Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if ! command -v uv >/dev/null 2>&1; then
    echo "Could not find or install uv. Install it manually: https://docs.astral.sh/uv/getting-started/installation/ then re-run ./build.sh" >&2
    exit 1
fi

echo "Using uv: $(uv --version)"

echo "Ensuring Python $python_version is available..."
uv python install "$python_version"

echo "[1/4] Creating virtual environment..."
uv venv --clear --python "$python_version" "$venv_path"

echo "[2/4] Installing packages..."
uv pip install --python "$venv_python" -r "$requirements_file"

echo "[3/4] Validating dbt installation..."
"$venv_dbt" --version

echo "[4/4] Installing dbt Charts..."
uv tool install dbt-charts --with dbt-duckdb
dct --version

echo "Setup completed successfully."
