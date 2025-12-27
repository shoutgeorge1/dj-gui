# Building and Releasing Executables

## Build the Executable

### Windows
```powershell
.\scripts\build_exe.ps1
.\scripts\build_installer.ps1
```

This creates:
- `dist/DrumSepGUI.exe` - Standalone executable
- `dist/DrumSepGUI-Setup.exe` - Windows installer

### Copy to Releases Folder

After building, copy the files:
```powershell
Copy-Item dist\DrumSepGUI.exe releases\
Copy-Item dist\DrumSepGUI-Setup.exe releases\
```

### Commit and Push

```bash
git add releases/
git commit -m "Add v1.0.0 executables"
git push
```

## GitHub Releases (Recommended)

Instead of committing executables, use GitHub Releases:

1. **Build the executable** (see above)
2. **Go to GitHub**: https://github.com/shoutgeorge1/dj-gui/releases
3. **Click "Draft a new release"**
4. **Tag**: `v1.0.0`
5. **Title**: `DrumSep GUI v1.0.0`
6. **Upload files**:
   - `DrumSepGUI.exe`
   - `DrumSepGUI-Setup.exe`
7. **Publish**

Users can then download from the Releases page!

## Why GitHub Releases?

- ✅ Keeps repo clean (no large binary files)
- ✅ Version tracking
- ✅ Release notes
- ✅ Easy downloads for users
- ✅ Better than committing 50MB+ executables

## Current Status

The `releases/` folder is set up to accept executables if you want them in the repo, but **GitHub Releases is the recommended approach**.

