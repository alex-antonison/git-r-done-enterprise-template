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

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "uv not found. Installing uv..."
    irm https://astral.sh/uv/install.ps1 | iex
    $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
}

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    throw "Could not find or install uv. Install it manually: https://docs.astral.sh/uv/getting-started/installation/ then re-run .\build.ps1"
}

Write-Host "Using uv: $(uv --version)"

Write-Host "Ensuring Python $pythonVersion is available..."
uv python install $pythonVersion

Write-Host "[1/3] Creating virtual environment..."
$needsNewVenv = -not (Test-Path $venvPython)

if (-not $needsNewVenv) {
    $venvVersion = & $venvPython -c "import sys; print(f'{sys.version_info[0]}.{sys.version_info[1]}')"
    if ($venvVersion -ne $pythonVersion) {
        Write-Host "Existing .venv uses Python $venvVersion, recreating with Python $pythonVersion..."
        $needsNewVenv = $true
    }
}

if ($needsNewVenv) {
    uv venv --clear --python $pythonVersion $venvPath
}

Write-Host "[2/3] Installing packages..."
uv pip install --python $venvPython -r $requirementsFile

Write-Host "[3/3] Validating dbt installation..."
& $dbtExe --version

Write-Host "Setup completed successfully."
