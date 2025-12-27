# Building a Standalone Executable

Your friend wants a **single .exe file** they can double-click. Here's how to build it.

## Quick Build

```powershell
.\scripts\build_exe.ps1
```

This creates `dist\DrumSepGUI.exe` - a **single file** you can double-click!

## Important: The drumsep Dependency

The GUI needs the `drumsep` CLI tool to work. You have two options:

### Option 1: Bundle drumsep with the .exe (Recommended)

1. **Install drumsep** somewhere accessible:
   ```powershell
   git clone https://github.com/inagoy/drumsep
   cd drumsep
   bash drumsepInstall
   cd ..
   ```

2. **Copy drumsep next to the .exe**:
   - After building, copy the `drumsep` executable to the same folder as `DrumSepGUI.exe`
   - Or create a `drumsep` subfolder and put it there
   - The GUI will automatically find it

3. **Or update the spec file** to bundle it automatically (see below)

### Option 2: User installs drumsep separately

The user needs to have `drumsep` installed and in their PATH. The GUI will find it automatically.

## Making it Truly Standalone

To bundle everything into one folder that works anywhere:

### Step 1: Build the .exe
```powershell
.\scripts\build_exe.ps1
```

### Step 2: Create a portable package

Create a folder structure like this:

```
DrumSepGUI-Portable/
├── DrumSepGUI.exe          (the GUI)
├── drumsep.exe             (the CLI tool - copy from installation)
└── README.txt              (instructions)
```

Then zip it up and share!

## Auto-Bundling drumsep (Advanced)

To automatically bundle drumsep with the build, update `packaging/drumsep_gui.spec`:

```python
# In the Analysis section, add:
binaries=[
    ('path/to/drumsep.exe', '.'),  # Bundles drumsep.exe in root
],
```

Or add it to datas if it's a folder:
```python
datas=[
    ('path/to/drumsep', 'drumsep'),  # Bundles entire drumsep folder
],
```

## Testing the Standalone .exe

1. **Build it**: `.\scripts\build_exe.ps1`
2. **Copy to a clean folder** (no Python, no dependencies)
3. **Double-click** `DrumSepGUI.exe`
4. **Test** with a sample audio file

If you get "drumsep not found":
- Copy `drumsep.exe` to the same folder
- Or install drumsep system-wide

## Distribution Options

### Single .exe (Current)
- ✅ One file
- ⚠️ Needs drumsep installed separately or in same folder

### Folder Distribution
- ✅ Can bundle drumsep
- ✅ Easier to include dependencies
- ⚠️ Multiple files

### Installer (Best for end users)
```powershell
.\scripts\build_installer.ps1
```
- ✅ Professional installation
- ✅ Can bundle everything
- ✅ Creates Start menu shortcuts
- ✅ Handles uninstallation

## Recommended Approach

For your friend who wants "just double-click":

1. **Build the .exe**: `.\scripts\build_exe.ps1`
2. **Find drumsep** (wherever it installed)
3. **Create a folder**:
   ```
   DrumSepGUI/
   ├── DrumSepGUI.exe
   └── drumsep.exe  (copy here)
   ```
4. **Zip it up** → `DrumSepGUI-Portable.zip`
5. **Share it** - they extract and double-click!

The GUI will automatically find `drumsep.exe` in the same folder.

