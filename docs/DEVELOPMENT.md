# Development Guide

## Setup

1. **Clone the repository** (if not already):
   ```bash
   git clone <repository-url>
   cd dj-dais-drum-gui
   ```

2. **Create a virtual environment**:
   ```bash
   python -m venv venv
   ```

3. **Activate the virtual environment**:
   - Windows (PowerShell):
     ```powershell
     .\venv\Scripts\Activate.ps1
     ```
   - Windows (CMD):
     ```cmd
     venv\Scripts\activate.bat
     ```
   - macOS/Linux:
     ```bash
     source venv/bin/activate
     ```

4. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

5. **Install drumsep** (if not already installed):
   ```bash
   git clone https://github.com/inagoy/drumsep
   cd drumsep
   bash drumsepInstall
   cd ..
   ```

## Running in Development

Use the provided script:

```powershell
.\scripts\dev_run.ps1
```

Or manually:

```bash
python -m app.main
```

## Project Structure

```
dj-dais-drum-gui/
├── app/
│   ├── __init__.py
│   ├── main.py              # Entry point
│   ├── ui/
│   │   ├── __init__.py
│   │   └── main_window.py   # Main GUI window
│   └── workers/
│       ├── __init__.py
│       └── separation_worker.py  # Background worker for CLI execution
├── packaging/
│   ├── drumsep_gui.spec     # PyInstaller spec
│   └── drumsep_gui.iss      # Inno Setup script
├── scripts/
│   ├── dev_run.ps1          # Development run script
│   ├── build_exe.ps1        # Build executable
│   └── build_installer.ps1  # Build installer
├── docs/
│   ├── CLI_MAPPING.md       # CLI command mapping guide
│   └── DEVELOPMENT.md       # This file
├── requirements.txt
├── README.md
└── .gitignore
```

## Building the Executable

1. **Build standalone executable**:
   ```powershell
   .\scripts\build_exe.ps1
   ```

   Output: `dist\DrumSepGUI.exe`

2. **Build installer** (requires Inno Setup):
   ```powershell
   .\scripts\build_installer.ps1
   ```

   Output: `dist\DrumSepGUI-Setup.exe`

## Verifying CLI Integration

Before packaging, verify that the GUI correctly calls drumsep:

1. See `docs/CLI_MAPPING.md` for details
2. Run the GUI and check the log window for the command
3. Compare with manual CLI usage
4. Adjust `app/workers/separation_worker.py` if needed

## Troubleshooting

### "drumsep not found" error

- Ensure drumsep is installed and in your PATH
- Or update `_find_drumsep()` in `separation_worker.py` with the correct path

### PyInstaller build fails

- Check that all dependencies are installed
- Verify the spec file paths are correct
- Try building with `--debug=all` for more information

### GUI freezes during separation

- Ensure the worker thread is properly set up (should be fine as-is)
- Check that `subprocess.Popen` is not blocking the UI thread

### Missing Qt plugins in packaged executable

- PyInstaller may miss some Qt plugins
- Add them manually to the spec file's `datas` section
- Or copy `platforms` folder from PySide6 installation

## Code Style

- Follow PEP 8
- Use type hints where helpful
- Keep functions focused and small
- Document complex logic

## Testing

Manual testing checklist:

- [ ] File selection works (button and drag-drop)
- [ ] Output folder selection works
- [ ] Options are correctly mapped to CLI flags
- [ ] Separation runs without freezing UI
- [ ] Cancel button works
- [ ] Log output is readable
- [ ] Output folder opens correctly
- [ ] Error messages are user-friendly

