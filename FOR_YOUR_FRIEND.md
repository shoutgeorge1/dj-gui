# For Your Friend: Standalone Executable 🎯

Your friend wants a **single .exe file** they can double-click. Here's exactly how to build it.

## Quick Answer

Run this one command:

```powershell
.\scripts\create_portable.ps1
```

This creates `DrumSepGUI-Portable.zip` - extract it, double-click `DrumSepGUI.exe`, done!

## What This Does

1. ✅ Builds the GUI into a single `.exe` file
2. ✅ Automatically finds and bundles `drumsep.exe` (if installed)
3. ✅ Creates a portable folder with everything needed
4. ✅ Zips it up for easy sharing

## If drumsep Isn't Found

The script will warn you. Then you have two options:

### Option A: Manual Bundle
1. Find where `drumsep` is installed
2. Copy `drumsep.exe` into the `DrumSepGUI-Portable` folder
3. Re-zip it

### Option B: User Installs Separately
The user can install `drumsep` separately, and the GUI will find it automatically.

## What Your Friend Gets

After you run the script, share `DrumSepGUI-Portable.zip`. They:

1. **Extract** the ZIP
2. **Double-click** `DrumSepGUI.exe`
3. **Use it** - no setup, no Python, no terminal!

## File Structure

```
DrumSepGUI-Portable/
├── DrumSepGUI.exe    ← Double-click this!
├── drumsep.exe       ← Bundled automatically
└── README.txt        ← Instructions
```

## Alternative: Just the .exe

If you want just the GUI .exe (user installs drumsep separately):

```powershell
.\scripts\build_exe.ps1
```

Then share `dist\DrumSepGUI.exe` - but they'll need drumsep installed.

## Best Option for Your Friend

**Use `create_portable.ps1`** - it bundles everything into one package they can just extract and use.

No Python needed. No terminal needed. Just double-click and go! 🚀

