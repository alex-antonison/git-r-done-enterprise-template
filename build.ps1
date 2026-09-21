$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $repoRoot

$venvPath = Join-Path $repoRoot ".venv"
$venvPython = Join-Path $venvPath "Scripts\python.exe"
$dbtExe = Join-Path $venvPath "Scripts\dbt.exe"
$requirementsFile = Join-Path $repoRoot "requirements.txt"
$pythonVersion = "3.13"

if (-not (Test-Path $requirementsFile)) {
    throw "requirements.txt was not found at $requirementsFile"
}

$env:Path = "$env:USERPROFILE\.local\bin;$env:Path"

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "uv not found. Installing uv..."
    irm https://astral.sh/uv/install.ps1 | iex
}

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    throw "Could not find or install uv. Install it manually: https://docs.astral.sh/uv/getting-started/installation/ then re-run .\build.ps1"
}

Write-Host "Using uv: $(uv --version)"

Write-Host "Ensuring Python $pythonVersion is available..."
uv python install $pythonVersion

Write-Host "[1/4] Creating virtual environment..."
uv venv --clear --python $pythonVersion $venvPath

Write-Host "[2/4] Installing packages..."
uv pip install --python $venvPython -r $requirementsFile

Write-Host "[3/4] Validating dbt installation..."
& $dbtExe --version

Write-Host "[4/4] Installing dbt Charts..."
uv tool install dbt-charts --with dbt-duckdb
dct --version

Write-Host "Setup completed successfully."
