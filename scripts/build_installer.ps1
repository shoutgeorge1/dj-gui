# Build installer script for DrumSep GUI
# Usage: .\scripts\build_installer.ps1
# Requires: Inno Setup Compiler installed

param(
    [switch]$SkipExe = $false
)

Write-Host "Building DrumSep GUI installer..." -ForegroundColor Green

# Build executable first if not skipped
if (-not $SkipExe) {
    Write-Host "Building executable first..." -ForegroundColor Yellow
    & .\scripts\build_exe.ps1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Executable build failed. Aborting installer build." -ForegroundColor Red
        exit 1
    }
}

# Check if Inno Setup is installed
$innoSetupPath = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if (-not (Test-Path $innoSetupPath)) {
    $innoSetupPath = "C:\Program Files\Inno Setup 6\ISCC.exe"
}

if (-not (Test-Path $innoSetupPath)) {
    Write-Host "Error: Inno Setup Compiler not found!" -ForegroundColor Red
    Write-Host "Please install Inno Setup from: https://jrsoftware.org/isinfo.php" -ForegroundColor Yellow
    exit 1
}

# Check if executable exists
if (-not (Test-Path "dist\DrumSepGUI.exe")) {
    Write-Host "Error: dist\DrumSepGUI.exe not found!" -ForegroundColor Red
    Write-Host "Run build_exe.ps1 first or use -SkipExe if executable already exists." -ForegroundColor Yellow
    exit 1
}

# Build installer
Write-Host "Compiling installer with Inno Setup..." -ForegroundColor Yellow
& $innoSetupPath "packaging\drumsep_gui.iss"

if ($LASTEXITCODE -eq 0) {
    Write-Host "`nInstaller build successful!" -ForegroundColor Green
    Write-Host "Installer location: dist\DrumSepGUI-Setup.exe" -ForegroundColor Cyan
} else {
    Write-Host "`nInstaller build failed!" -ForegroundColor Red
    exit 1
}

