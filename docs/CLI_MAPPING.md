# CLI Command Mapping Guide

This document explains how the GUI options map to drumsep CLI commands and how to verify/adjust them.

## Current Assumptions

The GUI currently assumes the following CLI structure (based on typical Demucs-based tools):

```bash
drumsep <input_file> --out <output_dir> [options]
```

### Option Mappings

| GUI Option | CLI Flag | Current Implementation |
|------------|----------|----------------------|
| Device: Auto | (none) | No flag added |
| Device: CPU | `--device cpu` | Added |
| Device: GPU (CUDA) | `--device cuda` | Added |
| Output Format: WAV | `--format wav` | Added |
| Output Format: Original | (none) | No flag added |
| Model: Default | (none) | No flag added |
| Model: Large | `--model large` | Added (may need adjustment) |
| Model: Small | `--model small` | Added (may need adjustment) |

## How to Verify the Actual CLI

1. **Install drumsep** (if not already installed):
   ```bash
   git clone https://github.com/inagoy/drumsep
   cd drumsep
   bash drumsepInstall
   ```

2. **Check the help output**:
   ```bash
   drumsep --help
   # or
   drumsep -h
   ```

3. **Test a simple command**:
   ```bash
   drumsep input.wav --out output_folder
   ```

4. **Check for entry point**:
   ```bash
   which drumsep
   # or on Windows:
   where drumsep
   ```

## Adjusting the Command Builder

The command building logic is in `app/workers/separation_worker.py`, specifically the `_build_command()` method.

### Common CLI Patterns to Check

- **Output directory**: Could be `--out`, `--output`, `-o`, or positional
- **Device**: Could be `--device`, `--gpu`, `--cpu`, or `-d`
- **Format**: Could be `--format`, `--fmt`, `-f`, or `--wav`
- **Model**: Could be `--model`, `--preset`, `-m`, or `--size`

### Example Adjustments

If drumsep uses different flags, update `_build_command()`:

```python
def _build_command(self) -> list:
    cmd = ["drumsep", str(self.input_file)]
    
    # If drumsep uses -o instead of --out:
    cmd.extend(["-o", str(self.output_dir)])
    
    # If device is --gpu/--cpu instead of --device:
    if self.device == "CPU":
        cmd.append("--cpu")
    elif self.device == "GPU (CUDA)":
        cmd.append("--gpu")
    
    # etc.
    return cmd
```

## Finding the drumsep Executable

The `_find_drumsep()` method tries to locate the drumsep command. You may need to adjust the search paths based on how drumsep is installed:

- **pip install**: Usually in `~/.local/bin/drumsep` or system PATH
- **conda install**: Usually in conda environment's bin directory
- **system install**: Usually in `/usr/local/bin/drumsep` or system PATH
- **Windows**: Could be in `C:\Program Files\drumsep\` or user's AppData

## Testing the Integration

1. Run the GUI in development mode:
   ```powershell
   .\scripts\dev_run.ps1
   ```

2. Select a test audio file
3. Click "Separate"
4. Check the log window for the actual command being run
5. Verify the command matches what you'd run manually
6. Adjust `_build_command()` if needed

## Packaging Considerations

When packaging, you may need to:

1. **Bundle drumsep** if it's not a system-wide install
2. **Include models** if they're not auto-downloaded
3. **Set PATH** in the packaged executable to find drumsep
4. **Bundle dependencies** like FFmpeg if required

Update the PyInstaller spec file (`packaging/drumsep_gui.spec`) to include any additional binaries or data files.

