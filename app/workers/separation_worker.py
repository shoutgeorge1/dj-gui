"""
Worker thread for running drumsep CLI in the background
"""
import sys
import subprocess
import shutil
from pathlib import Path
from typing import Optional

from PySide6.QtCore import QObject, Signal, QMutex


class SeparationWorker(QObject):
    """Worker that runs drumsep CLI in a background thread."""
    
    finished = Signal(bool, Path)  # success, output_dir
    error = Signal(str)
    log_message = Signal(str)
    
    def __init__(
        self,
        input_file: Path,
        output_dir: Path,
        device: str = "Auto",
        output_format: str = "WAV",
        model: str = "Default"
    ):
        super().__init__()
        self.input_file = input_file
        self.output_dir = output_dir
        self.device = device
        self.output_format = output_format
        self.model = model
        self.is_running = False
        self.process: Optional[subprocess.Popen] = None
        self.mutex = QMutex()
        self.drumsep_path: Optional[str] = None  # Cache the found drumsep path
        
    def run(self):
        """Execute the drumsep CLI command."""
        self.mutex.lock()
        self.is_running = True
        self.mutex.unlock()
        
        try:
            # Check if drumsep is available first
            self.drumsep_path = self._find_drumsep()
            if not self.drumsep_path:
                self.error.emit(
                    "drumsep not found. Please install drumsep:\n\n"
                    "1. git clone https://github.com/inagoy/drumsep\n"
                    "2. cd drumsep\n"
                    "3. bash drumsepInstall\n\n"
                    "Or ensure drumsep is in your PATH."
                )
                self._finish(False)
                return
            
            # Build command (now that we know drumsep exists)
            cmd = self._build_command()
            
            self.log_message.emit(f"Command: {' '.join(cmd)}")
            self.log_message.emit("")
                
            # Run process
            # drumsep needs to run from its directory to find the "model" folder
            drumsep_dir = Path(self.drumsep_path).parent if self.drumsep_path else None
            
            self.process = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                universal_newlines=True,
                bufsize=1,
                cwd=str(drumsep_dir) if drumsep_dir else None,  # Run from drumsep directory
                creationflags=subprocess.CREATE_NO_WINDOW if self._is_windows() else 0
            )
            
            # Stream output
            for line in iter(self.process.stdout.readline, ''):
                if not self.is_running:
                    break
                    
                line = line.rstrip()
                if line:
                    self.log_message.emit(line)
                    
            # Wait for completion
            return_code = self.process.wait()
            
            if not self.is_running:
                # Was cancelled
                self.log_message.emit("\n[Process terminated]")
                self._finish(False)
                return
                
            if return_code == 0:
                self.log_message.emit("\n[Process completed successfully]")
                self._finish(True)
            else:
                self.error.emit(f"drumsep exited with code {return_code}")
                self._finish(False)
                
        except FileNotFoundError:
            self.error.emit("drumsep command not found. Is it installed?")
            self._finish(False)
        except Exception as e:
            self.error.emit(f"Unexpected error: {str(e)}")
            self._finish(False)
            
    def cancel(self):
        """Cancel the running process."""
        self.mutex.lock()
        self.is_running = False
        self.mutex.unlock()
        
        if self.process:
            try:
                self.process.terminate()
                # Give it a moment to terminate gracefully
                try:
                    self.process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    # Force kill if it doesn't terminate
                    self.process.kill()
                    self.process.wait()
            except Exception as e:
                self.log_message.emit(f"[Error cancelling: {e}]")
                
    def _build_command(self) -> list:
        """
        Build the drumsep CLI command.
        
        drumsep uses a simple interface: drumsep <input> <output>
        It's a bash script that wraps demucs internally.
        
        We use a Python wrapper to fix PyTorch 2.6+ compatibility issues.
        """
        if not self.drumsep_path:
            return []
        
        # Check if fixed Python wrapper exists
        drumsep_dir = Path(self.drumsep_path).parent
        fixed_wrapper = drumsep_dir / "drumsep_fixed.py"
        
        if fixed_wrapper.exists():
            # Use the fixed Python wrapper (handles PyTorch 2.6+ weights_only issue)
            cmd = ["python3", str(fixed_wrapper), str(self.input_file), str(self.output_dir)]
        else:
            # Fall back to original bash script
            cmd = ["bash", self.drumsep_path, str(self.input_file), str(self.output_dir)]
        
        # Note: drumsep doesn't support device/format flags directly
        # It uses demucs internally with fixed settings
        # Device and format options are shown in GUI but not passed to drumsep
        
        return cmd
        
    def _find_drumsep(self) -> Optional[str]:
        """Find the drumsep script."""
        # First, try direct command (if in PATH)
        drumsep_path = shutil.which("drumsep")
        if drumsep_path:
            return drumsep_path
            
        # If running as bundled executable, check relative to .exe location
        if getattr(sys, 'frozen', False):
            # Running as compiled executable
            exe_dir = Path(sys.executable).parent
            # Check for drumsep in same directory as .exe
            bundled_drumsep = exe_dir / "drumsep.exe" if self._is_windows() else exe_dir / "drumsep"
            if bundled_drumsep.exists():
                return str(bundled_drumsep)
            # Check in subdirectory
            bundled_drumsep = exe_dir / "drumsep" / ("drumsep.exe" if self._is_windows() else "drumsep")
            if bundled_drumsep.exists():
                return str(bundled_drumsep)
            
        # Try common installation paths
        common_paths = [
            Path.home() / ".local" / "bin" / ("drumsep.exe" if self._is_windows() else "drumsep"),
            Path.home() / ".drumsep" / ("drumsep.exe" if self._is_windows() else "drumsep"),
            Path.home() / "drumsep" / "drumsep",  # Common clone location
        ]
        
        if self._is_windows():
            common_paths.extend([
                Path("C:\\Program Files\\drumsep\\drumsep.exe"),
                Path("C:\\Program Files (x86)\\drumsep\\drumsep.exe"),
            ])
        else:
            common_paths.extend([
                Path("/usr/local/bin/drumsep"),
                Path("/usr/bin/drumsep"),
                Path("/opt/drumsep/drumsep"),
            ])
        
        for path in common_paths:
            if path and path.exists():
                return str(path)
                
        return None
        
    def _is_windows(self) -> bool:
        """Check if running on Windows."""
        import sys
        return sys.platform == "win32"
        
    def _finish(self, success: bool):
        """Clean up and emit finished signal."""
        self.mutex.lock()
        self.is_running = False
        self.mutex.unlock()
        
        self.finished.emit(success, self.output_dir)

