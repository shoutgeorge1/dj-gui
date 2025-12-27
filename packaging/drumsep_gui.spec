# -*- mode: python ; coding: utf-8 -*-
"""
PyInstaller spec file for DrumSep GUI
"""
import sys
import os
from pathlib import Path

block_cipher = None

# Get the project root (handle both SPECPATH and manual execution)
try:
    project_root = Path(SPECPATH).parent.parent
except NameError:
    # Fallback if SPECPATH not available
    project_root = Path(__file__).parent.parent

a = Analysis(
    ['app/main.py'],
    pathex=[str(project_root)],
    binaries=[],
    datas=[],
    hiddenimports=[
        'PySide6.QtCore',
        'PySide6.QtGui',
        'PySide6.QtWidgets',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

# Collect PySide6 plugins (especially platforms plugin for Windows)
try:
    import PySide6
    pyside6_path = Path(PySide6.__file__).parent
    plugins_path = pyside6_path / 'plugins'
    if plugins_path.exists():
        # Add Qt plugins to datas
        a.datas += [
            (str(plugins_path / 'platforms'), 'PySide6/plugins/platforms'),
        ]
except ImportError:
    pass

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='DrumSepGUI',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,  # No console window
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=None,  # Add icon path here if you have one
)

