# Development run script for DrumSep GUI
# Usage: .\scripts\dev_run.ps1

Write-Host "Starting DrumSep GUI in development mode..." -ForegroundColor Green

# Check if virtual environment exists
if (-not (Test-Path "venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
}

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& .\venv\Scripts\Activate.ps1

# Install/upgrade dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt

# Run the application
Write-Host "Launching DrumSep GUI..." -ForegroundColor Green
python -m app.main

