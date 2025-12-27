# Quick Start Guide

## For End Users

1. **Download** `DrumSepGUI-Setup.exe`
2. **Install** by double-clicking
3. **Launch** "DrumSep GUI" from Start menu
4. **Select** an audio file
5. **Click** "Separate"
6. **Done!** Your drum stems are ready.

## For Developers

### First Time Setup

```powershell
# 1. Create virtual environment
python -m venv venv

# 2. Activate it
.\venv\Scripts\Activate.ps1

# 3. Install dependencies
pip install -r requirements.txt

# 4. Install drumsep (if not already)
git clone https://github.com/inagoy/drumsep
cd drumsep
bash drumsepInstall
cd ..
```

### Run in Development

```powershell
.\scripts\dev_run.ps1
```

### Build Executable

```powershell
.\scripts\build_exe.ps1
```

### Build Installer

```powershell
.\scripts\build_installer.ps1
```

## Important: Verify CLI Mapping

**Before packaging**, verify that the GUI correctly calls drumsep:

1. Run the GUI: `.\scripts\dev_run.ps1`
2. Select a test file and click "Separate"
3. Check the log window - it shows the exact command being run
4. Compare with manual CLI: `drumsep --help`
5. If flags differ, update `app/workers/separation_worker.py` → `_build_command()`

See `docs/CLI_MAPPING.md` for details.

## Project Status

✅ GUI framework complete  
✅ Background worker implemented  
✅ Packaging scripts ready  
⚠️ **CLI command mapping needs verification** (see above)

The GUI assumes standard Demucs-style CLI flags. You may need to adjust based on the actual drumsep CLI interface.

