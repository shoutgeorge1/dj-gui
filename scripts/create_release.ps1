# Helper script to prepare files for GitHub Release
# Usage: .\scripts\create_release.ps1 [version]

param(
    [string]$Version = "1.0.0"
)

Write-Host "Preparing release v$Version..." -ForegroundColor Green

# Check if dist folder exists
if (-not (Test-Path "dist")) {
    Write-Host "Error: dist folder not found. Build the executable first:" -ForegroundColor Red
    Write-Host "  .\scripts\build_exe.ps1" -ForegroundColor Yellow
    exit 1
}

# Create release folder
$releaseDir = "release-v$Version"
if (Test-Path $releaseDir) {
    Remove-Item -Recurse -Force $releaseDir
}
New-Item -ItemType Directory -Path $releaseDir | Out-Null

# Copy executables
Write-Host "`nCopying executables..." -ForegroundColor Yellow

if (Test-Path "dist\DrumSepGUI-Setup.exe") {
    Copy-Item "dist\DrumSepGUI-Setup.exe" -Destination "$releaseDir\DrumSepGUI-Setup-v$Version.exe"
    Write-Host "  ✓ Installer copied" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Installer not found" -ForegroundColor Yellow
}

if (Test-Path "dist\DrumSepGUI.exe") {
    Copy-Item "dist\DrumSepGUI.exe" -Destination "$releaseDir\DrumSepGUI-v$Version.exe"
    Write-Host "  ✓ Portable executable copied" -ForegroundColor Green
} else {
    Write-Host "  ⚠ Portable executable not found" -ForegroundColor Yellow
}

# Create release notes template
$releaseNotes = @"
## DrumSep GUI v$Version

A simple, user-friendly Windows application for separating drum stems from audio files.

### Installation

1. Download `DrumSepGUI-Setup-v$Version.exe` below
2. Run the installer
3. Launch "DrumSep GUI" from Start menu

### Requirements

- Windows 10 or later
- 4 GB RAM minimum
- 2 GB free disk space (for models on first run)

### Usage

1. Launch DrumSep GUI
2. Select an audio file (or drag and drop)
3. Click "Separate"
4. Wait for processing
5. Find your drum stems in the output folder!

### First Run

The first time you run it, it will download AI models (~1-2 GB). This is automatic and only happens once.

### Support

- Issues: https://github.com/shoutgeorge1/dj-gui/issues
- Source: https://github.com/shoutgeorge1/dj-gui
"@

$releaseNotes | Out-File -FilePath "$releaseDir\RELEASE_NOTES.md" -Encoding UTF8

Write-Host "`n✓ Release package ready in: $releaseDir\" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. Go to: https://github.com/shoutgeorge1/dj-gui/releases/new" -ForegroundColor Yellow
Write-Host "2. Tag: v$Version" -ForegroundColor Yellow
Write-Host "3. Title: DrumSep GUI v$Version" -ForegroundColor Yellow
Write-Host "4. Copy release notes from: $releaseDir\RELEASE_NOTES.md" -ForegroundColor Yellow
Write-Host "5. Upload files from: $releaseDir\" -ForegroundColor Yellow
Write-Host "6. Publish!" -ForegroundColor Yellow

