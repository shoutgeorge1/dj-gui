# DrumSep GUI v1.0.0

A simple, user-friendly Windows application for separating drum stems from audio files. No command line required!

## 🎯 What It Does

DrumSep GUI wraps the powerful [drumsep](https://github.com/inagoy/drumsep) tool in a clean, point-and-click interface. Extract clean drum tracks from any audio file with just a few clicks.

**Perfect for:**
- 🎵 DJs and producers
- 🎸 Musicians working with mixed audio
- 🎹 Anyone who wants drum separation without technical setup

## 📥 Installation

### Option 1: Windows Installer (Coming Soon)

1. Download `DrumSepGUI-Setup.exe` below
2. Run the installer
3. Launch "DrumSep GUI" from Start menu

### Option 2: Build from Source (Available Now)

**Requirements:**
- Python 3.8+
- PySide6
- drumsep installed

**Quick Start:**
```bash
# Clone the repo
git clone https://github.com/shoutgeorge1/dj-gui.git
cd dj-gui

# Install dependencies
pip install -r requirements.txt

# Install drumsep (if not already installed)
git clone https://github.com/inagoy/drumsep
cd drumsep
bash drumsepInstall
cd ..

# Run the GUI
python -m app.main
```

See [README.md](https://github.com/shoutgeorge1/dj-gui/blob/main/README.md) for detailed instructions.

## ✨ Features

- 🖱️ **Point-and-click interface** - No terminal needed
- 📁 **Drag and drop support** - Just drag your audio file
- 📊 **Real-time progress** - Watch the separation happen
- 🎛️ **Simple options** - Device selection, output format
- 📂 **Smart output** - Automatically organizes your drum stems

## 🚀 Usage

1. **Launch DrumSep GUI**
2. **Select your audio file** (WAV, MP3, FLAC, AAC, M4A)
3. **Choose output location** (optional - defaults to input folder)
4. **Click "Separate"**
5. **Wait for processing** (watch the progress log)
6. **Click "Open Output Folder"** when done

Your separated drum stems will be in the `_drums` folder!

## 📋 System Requirements

- **Windows 10 or later** (for the .exe)
- **4 GB RAM minimum** (8 GB recommended)
- **2 GB free disk space** (for models on first run)
- **GPU optional** (CUDA-compatible GPU speeds up processing)

## ⚠️ First Run

The first time you run DrumSep GUI, it will download AI models (~1-2 GB). This happens automatically and only needs to be done once. You'll see "Downloading models..." in the log window.

**Please be patient** - this can take a few minutes depending on your internet connection.

## 🐛 Troubleshooting

### "GPU not available" or "CUDA error"
- Switch to "CPU" mode in the Device dropdown
- CPU mode works fine, just slower (about 2-3x longer)

### Processing is slow
- Normal: Drum separation is computationally intensive
- A 3-minute song typically takes 1-3 minutes on CPU, 30-60 seconds on GPU
- Close other applications to speed things up

### "drumsep not found" error
- Make sure drumsep is installed (see Installation above)
- Or wait for the Windows .exe which will bundle everything

### Output folder is empty
- Check the log window for error messages
- Make sure you have write permissions to the output folder
- Try a different output location

## 📝 What's Included

- ✅ Complete PySide6 GUI application
- ✅ Background processing (UI stays responsive)
- ✅ Real-time log streaming
- ✅ PyTorch 2.6+ compatibility fixes
- ✅ Automatic file organization
- ✅ Full documentation

## 🔗 Links

- **Source Code**: https://github.com/shoutgeorge1/dj-gui
- **Issues**: https://github.com/shoutgeorge1/dj-gui/issues
- **drumsep (Backend)**: https://github.com/inagoy/drumsep

## 📄 License

This GUI wrapper is provided as-is. Please refer to the [drumsep repository](https://github.com/inagoy/drumsep) for its license terms.

## 🙏 Credits

- Built with [PySide6](https://www.qt.io/qt-for-python)
- Powered by [drumsep](https://github.com/inagoy/drumsep) and [Demucs](https://github.com/facebookresearch/demucs)

---

**Note**: The Windows executable will be available soon. In the meantime, you can build from source or wait for the next release update.

