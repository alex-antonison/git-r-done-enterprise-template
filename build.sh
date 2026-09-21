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

if ! command -v uv >/dev/null 2>&1; then
    echo "uv not found. Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

if ! command -v uv >/dev/null 2>&1; then
    echo "Could not find or install uv. Install it manually: https://docs.astral.sh/uv/getting-started/installation/ then re-run ./build.sh" >&2
    exit 1
fi

echo "Using uv: $(uv --version)"

echo "Ensuring Python $python_version is available..."
uv python install "$python_version"

echo "[1/3] Creating virtual environment..."
needs_new_venv=1
if [ -x "$venv_python" ]; then
    venv_version=$("$venv_python" -c 'import sys; print(f"{sys.version_info[0]}.{sys.version_info[1]}")')
    if [ "$venv_version" = "$python_version" ]; then
        needs_new_venv=0
    else
        echo "Existing .venv uses Python $venv_version, recreating with Python $python_version..."
    fi
fi

if [ "$needs_new_venv" -eq 1 ]; then
    uv venv --clear --python "$python_version" "$venv_path"
fi

echo "[2/3] Installing packages..."
uv pip install --python "$venv_python" -r "$requirements_file"

echo "[3/3] Validating dbt installation..."
"$venv_dbt" --version

echo "Setup completed successfully."
