# Releases

This folder contains built executables for distribution.

## Building Executables

### Windows
```powershell
.\scriptsuild_exe.ps1
.\scriptsuild_installer.ps1
```

Then copy the built files from `dist/` to this folder.

### macOS
```bash
pyinstaller packaging/drumsep_gui.spec
```

## GitHub Releases

For distribution, upload these files to GitHub Releases instead of committing them here.

