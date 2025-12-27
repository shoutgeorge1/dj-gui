# Create Release - Quick Steps

## Option 1: Using GitHub CLI (If Authenticated)

```bash
./create_release_mac.sh
```

If it asks to authenticate:
```bash
gh auth login
```

## Option 2: Manual Creation (Easiest)

1. **Go to**: https://github.com/shoutgeorge1/dj-gui/releases/new

2. **Fill in**:
   - **Tag**: `v1.0.0`
   - **Title**: `DrumSep GUI v1.0.0`
   - **Description**: Copy from below
   - **Check**: "Set as a draft" (since .exe isn't ready yet)

3. **Click**: "Publish release"

4. **Later**: When you build the .exe on Windows, edit the release and upload the file

## Release Description

```markdown
## DrumSep GUI v1.0.0

A simple, user-friendly Windows application for separating drum stems from audio files.

### ⚠️ Note

**This is a draft release - the Windows executable will be added soon.**

Users can build from source in the meantime (see README.md).

### Installation (When .exe is available)

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

## After Creating Release

When you build the `.exe` on Windows:

1. Go to the release page
2. Click "Edit release"
3. Upload `DrumSepGUI-Setup.exe`
4. Uncheck "Set as a draft"
5. Click "Update release"

Done! 🎉

