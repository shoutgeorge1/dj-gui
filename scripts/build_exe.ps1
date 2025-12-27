# Build executable script for DrumSep GUI
# Usage: .\scripts\build_exe.ps1

param(
    [switch]$Clean = $false
)

Write-Host "Building DrumSep GUI executable..." -ForegroundColor Green

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

# Clean previous builds
if ($Clean -or (Test-Path "build") -or (Test-Path "dist")) {
    Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
    if (Test-Path "build") { Remove-Item -Recurse -Force "build" }
    if (Test-Path "dist") { Remove-Item -Recurse -Force "dist" }
}

# Build with PyInstaller
Write-Host "Running PyInstaller..." -ForegroundColor Yellow
pyinstaller packaging/drumsep_gui.spec --clean

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nBuild successful!" -ForegroundColor Green
    Write-Host "Executable location: dist\DrumSepGUI.exe" -ForegroundColor Cyan
    Write-Host "`nNOTE: The .exe needs 'drumsep' to work." -ForegroundColor Yellow
    Write-Host "Either:" -ForegroundColor Yellow
    Write-Host "  1. Copy drumsep.exe to the same folder as DrumSepGUI.exe" -ForegroundColor Yellow
    Write-Host "  2. Or ensure drumsep is installed and in your PATH" -ForegroundColor Yellow
    Write-Host "`nSee BUILD_STANDALONE.md for details." -ForegroundColor Cyan
} else {
    Write-Host "`nBuild failed!" -ForegroundColor Red
    exit 1
}

