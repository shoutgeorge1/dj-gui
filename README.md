# DrumSep GUI

A simple, user-friendly Windows application for separating drum stems from audio files.

## What is DrumSep GUI?

DrumSep GUI is a graphical interface for the [drumsep](https://github.com/inagoy/drumsep) tool. It lets you extract drum tracks from any audio file without using the command line.

**Perfect for:**
- DJs and producers who want clean drum stems
- Musicians working with mixed audio
- Anyone who wants drum separation without technical setup

## Installation

### 📥 Download the Executable

**Get the latest release:**
- **👉 [Download from GitHub Releases](https://github.com/shoutgeorge1/dj-gui/releases/latest)**
- Download `DrumSepGUI-Setup.exe` (Windows installer - recommended)
- Or `DrumSepGUI.exe` (portable version)

> **For developers**: See [RELEASE_GUIDE.md](RELEASE_GUIDE.md) to create new releases

### Option 1: Installer (Recommended)

1. Download `DrumSepGUI-Setup.exe` from [Releases](https://github.com/shoutgeorge1/dj-gui/releases)
2. Double-click to run the installer
3. Follow the installation wizard
4. Launch "DrumSep GUI" from your Start menu

### Option 2: Portable Version

1. Download `DrumSepGUI.exe` from [Releases](https://github.com/shoutgeorge1/dj-gui/releases)
2. Double-click to run (no installation needed)

**No Python installation required!** Everything is bundled.

> **Note**: If you don't see a release yet, you'll need to build it yourself (see [BUILD_AND_RELEASE.md](BUILD_AND_RELEASE.md))

## How to Use

1. **Launch DrumSep GUI**
2. **Select your audio file**
   - Click "Select Audio File" or drag and drop
   - Supports: WAV, MP3, FLAC, AAC, M4A
3. **Choose output location** (optional)
   - Defaults to the same folder as your input file
4. **Adjust settings** (optional)
   - **Device**: Auto (recommended), CPU, or GPU
   - **Output Format**: WAV or Original format
5. **Click "Separate"**
6. **Wait for processing** (watch the progress log)
7. **Click "Open Output Folder"** when done

Your separated drum stems will be in the output folder!

## First Run

The first time you run DrumSep GUI, it will download the AI models (about 1-2 GB). This happens automatically and only needs to be done once. You'll see "Downloading models..." in the log window.

**Please be patient** - this can take a few minutes depending on your internet connection.

## Common Issues

### "GPU not available" or "CUDA error"

- **Solution**: Switch to "CPU" mode in the Device dropdown
- CPU mode works fine, just slower (about 2-3x longer)

### Processing is slow

- **Normal**: Drum separation is computationally intensive
- A 3-minute song typically takes 1-3 minutes on CPU, 30-60 seconds on GPU
- Close other applications to speed things up

### "Model not found" error

- This usually means the first-run download was interrupted
- Delete the models folder and restart DrumSep GUI
- Models are typically stored in: `%USERPROFILE%\.drumsep\models`

### Output folder is empty

- Check the log window for error messages
- Make sure you have write permissions to the output folder
- Try a different output location

## System Requirements

- **Windows 10 or later**
- **4 GB RAM minimum** (8 GB recommended)
- **2 GB free disk space** (for models and output)
- **GPU optional** (CUDA-compatible GPU speeds up processing)

## Technical Details

DrumSep GUI is a thin wrapper around the [drumsep](https://github.com/inagoy/drumsep) CLI tool. It doesn't modify any audio processing logic - it just makes it easier to use.

## Building from Source

If you want to build the executable yourself:

**Windows:**
```powershell
.\scripts\build_exe.ps1
.\scripts\build_installer.ps1
```

**macOS:**
```bash
pyinstaller packaging/drumsep_gui.spec
```

See [BUILD_AND_RELEASE.md](BUILD_AND_RELEASE.md) for detailed instructions.

## Support

For issues related to:
- **DrumSep GUI**: Check this repository or open an issue
- **Audio separation quality**: See the [drumsep repository](https://github.com/inagoy/drumsep)

## Downloads

- **Latest Release**: https://github.com/shoutgeorge1/dj-gui/releases
- **Source Code**: Clone this repository

## License

This GUI wrapper is provided as-is. Please refer to the drumsep repository for its license terms.



