# Show It to Your Friend RIGHT NOW! 🚀

## Quick Launch (macOS - You're on Mac!)

Just run:

```bash
./run_now.sh
```

Or manually:

```bash
# 1. Create virtual environment (first time only)
python3 -m venv venv

# 2. Activate it
source venv/bin/activate

# 3. Install dependencies (first time only)
pip install -r requirements.txt

# 4. Launch!
python -m app.main
```

## What They'll See

A window opens with:
- **File picker** button
- **Options** (Device, Format)
- **"Separate"** button
- **Live log** window

## Demo It!

1. **Click "Select Audio File"** → Pick any MP3/WAV
2. **Click "Separate"** → Show the live log streaming
3. **Point out the features**:
   - Drag and drop support
   - Real-time progress
   - Clean interface

## Note About drumsep

The GUI will try to find `drumsep` but might show an error if it's not installed. That's okay for a demo - you're showing the **interface**, not the full workflow.

To make it fully work, you'd need:
- `drumsep` installed (from https://github.com/inagoy/drumsep)
- Or build the standalone .exe that bundles it

But for **showing the GUI right now**, just run `./run_now.sh` and the window will pop up!

## If You Get Errors

**"PySide6 not found"**: Run `pip install PySide6`

**"drumsep not found"**: That's expected if drumsep isn't installed. The GUI will still open and you can show the interface!

**"No module named app"**: Make sure you're in the project folder and activated the venv.

