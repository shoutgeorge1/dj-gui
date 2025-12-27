# How to Show Your Friend 🎵

## Quick Demo (5 minutes)

### Step 1: Set Up (First Time Only)

Open PowerShell in this folder and run:

```powershell
# Create virtual environment
python -m venv venv

# Activate it
.\venv\Scripts\Activate.ps1

# Install what you need
pip install -r requirements.txt
```

**Note**: You also need `drumsep` installed. If you don't have it:
```powershell
git clone https://github.com/inagoy/drumsep
cd drumsep
bash drumsepInstall
cd ..
```

### Step 2: Launch the GUI

```powershell
.\scripts\dev_run.ps1
```

A window will pop up that looks like this:

```
┌─────────────────────────────────────────┐
│  DrumSep – Drum Stem Separator         │
├─────────────────────────────────────────┤
│  Input Audio File                       │
│  [No file selected]  [Select Audio...]  │
├─────────────────────────────────────────┤
│  Output Folder                          │
│  (Same as input file)  [Choose...]      │
├─────────────────────────────────────────┤
│  Options                                │
│  Device: [Auto ▼]                       │
│  Format: [WAV ▼]                        │
├─────────────────────────────────────────┤
│  [Separate]  [Cancel]  [Open Output]    │
├─────────────────────────────────────────┤
│  Status                                 │
│  [Progress bar]                         │
│  [Log output here...]                   │
└─────────────────────────────────────────┘
```

### Step 3: Show It Off!

1. **Click "Select Audio File"** → Pick any MP3/WAV/FLAC
2. **Click "Separate"** → Watch the magic happen!
3. **Show the log** → Real-time output streaming
4. **Click "Open Output Folder"** → Show the separated drums!

## What Your Friend Will See

✅ **Clean, professional interface** - No terminal, no command line  
✅ **Drag and drop** - Just drag an audio file onto the window  
✅ **Live progress** - See what's happening in real-time  
✅ **One-click separation** - That's it!

## Make It Even Better

### Build a Standalone .exe (What Your Friend Wants!)

**Option 1: Just the .exe**
```powershell
.\scripts\build_exe.ps1
```
Creates `dist\DrumSepGUI.exe` - a single file you can double-click!

**Option 2: Portable Package (Recommended)**
```powershell
.\scripts\create_portable.ps1
```
Creates `DrumSepGUI-Portable.zip` with:
- `DrumSepGUI.exe` (the GUI)
- `drumsep.exe` (bundled, if found)
- `README.txt` (instructions)

Just extract and double-click - everything included!

**Option 3: Professional Installer**
```powershell
.\scripts\build_installer.ps1
```
Creates `dist\DrumSepGUI-Setup.exe` - a proper Windows installer with Start menu shortcuts!

## Troubleshooting

**"drumsep not found" error?**
- Make sure drumsep is installed and in your PATH
- Or update the path in `app/workers/separation_worker.py`

**GUI doesn't open?**
- Make sure you activated the virtual environment
- Check that PySide6 installed correctly: `pip install PySide6`

**Want to see what command it's running?**
- Check the log window - it shows the exact CLI command
- Compare with `drumsep --help` to verify flags

## The Pitch

> "This is a GUI wrapper for drumsep - it takes the command-line tool and makes it point-and-click. No terminal, no Python knowledge needed. Just pick a file and click Separate. The actual audio processing is done by the existing drumsep tool - we just put a nice interface on it."

That's the whole philosophy - **thin wrapper, zero reinvention**.

