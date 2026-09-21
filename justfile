venv := ".venv"
venv_python := ".venv/bin/python"
venv_dbt := ".venv/bin/dbt"
requirements := "requirements.txt"

# List available recipes
default:
    @just --list

# Create the venv, install dependencies, and validate dbt (mirrors build.ps1)
build:
    #!/usr/bin/env bash
    set -euo pipefail

    if [ ! -f "{{requirements}}" ]; then
        echo "requirements.txt was not found at {{requirements}}" >&2
        exit 1
    fi

    python_cmd=""
    for candidate in python3.14 python3.13 python3.12 python3; do
        if command -v "$candidate" >/dev/null 2>&1; then
            version=$("$candidate" -c 'import sys; print(f"{sys.version_info[0]}.{sys.version_info[1]}")' 2>/dev/null || true)
            case "$version" in
                3.14|3.13|3.12)
                    python_cmd="$candidate"
                    break
                    ;;
            esac
        fi
    done

    if [ -z "$python_cmd" ]; then
        echo "Could not find a compatible Python interpreter. Install Python 3.12, 3.13, or 3.14 (e.g. 'brew install python@3.13'), then re-run 'just build'." >&2
        exit 1
    fi

    echo "Using Python interpreter: $python_cmd"

    echo "[1/3] Creating virtual environment..."
    needs_new_venv=1
    if [ -x "{{venv_python}}" ]; then
        venv_version=$("{{venv_python}}" -c 'import sys; print(f"{sys.version_info[0]}.{sys.version_info[1]}")')
        case "$venv_version" in
            3.14|3.13|3.12)
                needs_new_venv=0
                ;;
            *)
                echo "Existing {{venv}} uses Python $venv_version, recreating with Python 3.14/3.13/3.12..."
                rm -rf "{{venv}}"
                ;;
        esac
    fi

    if [ "$needs_new_venv" -eq 1 ]; then
        "$python_cmd" -m venv "{{venv}}"
    fi

    echo "[2/3] Installing packages..."
    "{{venv_python}}" -m pip install --upgrade pip
    "{{venv_python}}" -m pip install -r "{{requirements}}"

    echo "[3/3] Validating dbt installation..."
    "{{venv_dbt}}" --version

    echo "Build completed successfully."
