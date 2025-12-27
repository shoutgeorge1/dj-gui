# Create a portable package with GUI + drumsep bundled
# Usage: .\scripts\create_portable.ps1 [path-to-drumsep]

param(
    [string]$DrumsepPath = ""
)

Write-Host "Creating portable DrumSep GUI package..." -ForegroundColor Green

# Build the executable first
Write-Host "`nStep 1: Building executable..." -ForegroundColor Yellow
& .\scripts\build_exe.ps1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed. Aborting." -ForegroundColor Red
    exit 1
}

# Create portable folder
$portableDir = "DrumSepGUI-Portable"
if (Test-Path $portableDir) {
    Write-Host "`nCleaning existing portable folder..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $portableDir
}

New-Item -ItemType Directory -Path $portableDir | Out-Null

# Copy the executable
Write-Host "`nStep 2: Copying executable..." -ForegroundColor Yellow
Copy-Item "dist\DrumSepGUI.exe" -Destination "$portableDir\DrumSepGUI.exe"

# Try to find and copy drumsep
Write-Host "`nStep 3: Looking for drumsep..." -ForegroundColor Yellow

$drumsepFound = $false

# If path provided, use it
if ($DrumsepPath -and (Test-Path $DrumsepPath)) {
    $drumsepExe = Get-Item $DrumsepPath
    Copy-Item $drumsepExe.FullName -Destination "$portableDir\drumsep.exe"
    $drumsepFound = $true
    Write-Host "  Found drumsep at: $($drumsepExe.FullName)" -ForegroundColor Green
} else {
    # Try to find drumsep in common locations
    $searchPaths = @(
        "$env:USERPROFILE\.local\bin\drumsep.exe",
        "$env:USERPROFILE\.drumsep\drumsep.exe",
        "C:\Program Files\drumsep\drumsep.exe",
        "C:\Program Files (x86)\drumsep\drumsep.exe"
    )
    
    foreach ($path in $searchPaths) {
        if (Test-Path $path) {
            Copy-Item $path -Destination "$portableDir\drumsep.exe"
            $drumsepFound = $true
            Write-Host "  Found drumsep at: $path" -ForegroundColor Green
            break
        }
    }
    
    # Try which/where command
    if (-not $drumsepFound) {
        $whereResult = where.exe drumsep 2>$null
        if ($whereResult) {
            Copy-Item $whereResult -Destination "$portableDir\drumsep.exe"
            $drumsepFound = $true
            Write-Host "  Found drumsep in PATH: $whereResult" -ForegroundColor Green
        }
    }
}

if (-not $drumsepFound) {
    Write-Host "  WARNING: drumsep not found!" -ForegroundColor Yellow
    Write-Host "  You'll need to manually copy drumsep.exe to the portable folder." -ForegroundColor Yellow
    Write-Host "  Or the user will need to install drumsep separately." -ForegroundColor Yellow
}

# Create README
Write-Host "`nStep 4: Creating README..." -ForegroundColor Yellow
$readme = @"
DrumSep GUI - Portable Version

INSTRUCTIONS:
1. Double-click DrumSepGUI.exe
2. Select an audio file
3. Click "Separate"
4. Done!

REQUIREMENTS:
- Windows 10 or later
- 4 GB RAM minimum
- 2 GB free disk space (for models on first run)

FIRST RUN:
The first time you run this, it will download AI models (1-2 GB).
This only happens once and is automatic.

TROUBLESHOOTING:
If you get "drumsep not found":
- Make sure drumsep.exe is in this folder
- Or install drumsep separately: https://github.com/inagoy/drumsep

For more help, see the main README.md
"@
$readme | Out-File -FilePath "$portableDir\README.txt" -Encoding UTF8

# Create zip file
Write-Host "`nStep 5: Creating ZIP archive..." -ForegroundColor Yellow
$zipFile = "DrumSepGUI-Portable.zip"
if (Test-Path $zipFile) {
    Remove-Item -Force $zipFile
}

Compress-Archive -Path "$portableDir\*" -DestinationPath $zipFile -Force

Write-Host "`n✓ Portable package created!" -ForegroundColor Green
Write-Host "  Folder: $portableDir\" -ForegroundColor Cyan
Write-Host "  ZIP: $zipFile" -ForegroundColor Cyan
Write-Host "`nShare the ZIP file - users extract and double-click!" -ForegroundColor Green

