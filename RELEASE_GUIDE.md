# GitHub Releases Guide

## Quick Release Process

### Step 1: Build the Executable (On Windows)

```powershell
# Navigate to the repo
cd dj-gui

# Build the executable
.\scripts\build_exe.ps1

# Build the installer
.\scripts\build_installer.ps1
```

This creates:
- `dist/DrumSepGUI.exe` - Standalone executable
- `dist/DrumSepGUI-Setup.exe` - Windows installer (recommended)

### Step 2: Create GitHub Release

1. **Go to GitHub**: https://github.com/shoutgeorge1/dj-gui/releases
2. **Click "Draft a new release"**
3. **Fill in the form**:
   - **Tag**: `v1.0.0` (or next version)
   - **Title**: `DrumSep GUI v1.0.0`
   - **Description**: Copy from template below
4. **Upload files**:
   - Drag and drop `dist/DrumSepGUI-Setup.exe`
   - (Optional) Also upload `dist/DrumSepGUI.exe` as portable version
5. **Click "Publish release"**

### Step 3: Share the Link

The release will be available at:
```
https://github.com/shoutgeorge1/dj-gui/releases/tag/v1.0.0
```

Or the latest release:
```
https://github.com/shoutgeorge1/dj-gui/releases/latest
```

## Release Description Template

```markdown
## DrumSep GUI v1.0.0

A simple, user-friendly Windows application for separating drum stems from audio files.

### What's New
- Initial release
- Full GUI interface
- Drag and drop support
- Real-time progress logging

### Installation

1. Download `DrumSepGUI-Setup.exe` below
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
```

## Automated Release (Optional)

If you want to automate this, I can set up GitHub Actions to:
- Build on Windows automatically
- Create releases when you tag a version
- Upload executables automatically

Want me to set that up?

## Version Numbering

Use semantic versioning:
- `v1.0.0` - Initial release
- `v1.0.1` - Bug fixes
- `v1.1.0` - New features
- `v2.0.0` - Major changes

## Tips

- **Test the installer** on a clean Windows VM before releasing
- **Include release notes** explaining what's new
- **Tag the commit** you're releasing: `git tag v1.0.0 && git push --tags`
- **Keep old releases** for users who need previous versions

