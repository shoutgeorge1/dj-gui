"""
Main window for DrumSep GUI
"""
import os
import sys
import shutil
from pathlib import Path
from typing import Optional

from PySide6.QtCore import Qt, QThread, Signal, QTimer
from PySide6.QtWidgets import (
    QMainWindow,
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QPushButton,
    QLabel,
    QFileDialog,
    QComboBox,
    QGroupBox,
    QTextEdit,
    QProgressBar,
    QCheckBox,
    QMessageBox,
    QLineEdit,
)

from app.workers.separation_worker import SeparationWorker


class MainWindow(QMainWindow):
    """Main application window."""
    
    def __init__(self):
        super().__init__()
        self.input_file: Optional[Path] = None
        self.output_dir: Optional[Path] = None
        self.worker: Optional[SeparationWorker] = None
        self.worker_thread: Optional[QThread] = None
        
        self.setWindowTitle("DrumSep – Drum Stem Separator")
        self.setMinimumSize(700, 600)
        self.resize(800, 700)
        
        self._setup_ui()
        self._connect_signals()
        
    def _setup_ui(self):
        """Build the user interface."""
        central_widget = QWidget()
        self.setCentralWidget(central_widget)
        layout = QVBoxLayout(central_widget)
        layout.setSpacing(15)
        layout.setContentsMargins(20, 20, 20, 20)
        
        # Title
        title = QLabel("DrumSep – Drum Stem Separator")
        title_font = title.font()
        title_font.setPointSize(16)
        title_font.setBold(True)
        title.setFont(title_font)
        layout.addWidget(title)
        
        # Input section
        input_group = QGroupBox("Input Audio File")
        input_layout = QVBoxLayout(input_group)
        
        input_row = QHBoxLayout()
        self.input_path_label = QLabel("No file selected")
        self.input_path_label.setWordWrap(True)
        self.input_path_label.setStyleSheet("color: #666; font-style: italic;")
        input_row.addWidget(self.input_path_label, stretch=1)
        
        self.select_file_btn = QPushButton("Select Audio File...")
        self.select_file_btn.clicked.connect(self._select_input_file)
        input_row.addWidget(self.select_file_btn)
        
        input_layout.addLayout(input_row)
        layout.addWidget(input_group)
        
        # Output section
        output_group = QGroupBox("Output Folder")
        output_layout = QVBoxLayout(output_group)
        
        output_row = QHBoxLayout()
        self.output_path_label = QLabel("(Same as input file)")
        self.output_path_label.setWordWrap(True)
        self.output_path_label.setStyleSheet("color: #666; font-style: italic;")
        output_row.addWidget(self.output_path_label, stretch=1)
        
        self.select_output_btn = QPushButton("Choose Folder...")
        self.select_output_btn.clicked.connect(self._select_output_folder)
        output_row.addWidget(self.select_output_btn)
        
        output_layout.addLayout(output_row)
        layout.addWidget(output_group)
        
        # Options section
        options_group = QGroupBox("Options")
        options_layout = QVBoxLayout(options_group)
        
        # Device selection
        device_row = QHBoxLayout()
        device_row.addWidget(QLabel("Device:"))
        self.device_combo = QComboBox()
        self.device_combo.addItems(["Auto", "CPU", "GPU (CUDA)"])
        self.device_combo.setCurrentText("Auto")
        device_row.addWidget(self.device_combo)
        device_row.addStretch()
        options_layout.addLayout(device_row)
        
        # Output format
        format_row = QHBoxLayout()
        format_row.addWidget(QLabel("Output Format:"))
        self.format_combo = QComboBox()
        self.format_combo.addItems(["WAV", "Original Format"])
        self.format_combo.setCurrentText("WAV")
        format_row.addWidget(self.format_combo)
        format_row.addStretch()
        options_layout.addLayout(format_row)
        
        # Advanced options (collapsed by default)
        self.advanced_checkbox = QCheckBox("Show Advanced Options")
        self.advanced_checkbox.toggled.connect(self._toggle_advanced)
        options_layout.addWidget(self.advanced_checkbox)
        
        self.advanced_widget = QWidget()
        advanced_layout = QVBoxLayout(self.advanced_widget)
        advanced_layout.setContentsMargins(20, 0, 0, 0)
        
        # Model selection (if needed)
        model_row = QHBoxLayout()
        model_row.addWidget(QLabel("Model:"))
        self.model_combo = QComboBox()
        self.model_combo.addItems(["Default", "Large", "Small"])
        self.model_combo.setCurrentText("Default")
        model_row.addWidget(self.model_combo)
        model_row.addStretch()
        advanced_layout.addLayout(model_row)
        
        self.advanced_widget.setVisible(False)
        options_layout.addWidget(self.advanced_widget)
        
        layout.addWidget(options_group)
        
        # Action buttons
        button_row = QHBoxLayout()
        button_row.addStretch()
        
        self.separate_btn = QPushButton("Separate")
        self.separate_btn.setMinimumWidth(120)
        self.separate_btn.setStyleSheet("font-weight: bold; padding: 8px;")
        self.separate_btn.clicked.connect(self._start_separation)
        button_row.addWidget(self.separate_btn)
        
        self.cancel_btn = QPushButton("Cancel")
        self.cancel_btn.setMinimumWidth(120)
        self.cancel_btn.setEnabled(False)
        self.cancel_btn.clicked.connect(self._cancel_separation)
        button_row.addWidget(self.cancel_btn)
        
        self.open_output_btn = QPushButton("Open Output Folder")
        self.open_output_btn.setMinimumWidth(150)
        self.open_output_btn.clicked.connect(self._open_output_folder)
        button_row.addWidget(self.open_output_btn)
        
        layout.addLayout(button_row)
        
        # Status area
        status_group = QGroupBox("Status")
        status_layout = QVBoxLayout(status_group)
        
        self.progress_bar = QProgressBar()
        self.progress_bar.setRange(0, 0)  # Indeterminate
        self.progress_bar.setVisible(False)
        status_layout.addWidget(self.progress_bar)
        
        self.log_text = QTextEdit()
        self.log_text.setReadOnly(True)
        self.log_text.setMaximumHeight(200)
        self.log_text.setFontFamily("Consolas")
        self.log_text.setFontPointSize(9)
        status_layout.addWidget(self.log_text)
        
        layout.addWidget(status_group)
        
        layout.addStretch()
        
    def _connect_signals(self):
        """Connect UI signals."""
        # Enable drag and drop
        self.setAcceptDrops(True)
        
    def dragEnterEvent(self, event):
        """Handle drag enter event."""
        if event.mimeData().hasUrls():
            event.acceptProposedAction()
            
    def dropEvent(self, event):
        """Handle drop event."""
        urls = event.mimeData().urls()
        if urls:
            file_path = Path(urls[0].toLocalFile())
            if self._is_valid_audio_file(file_path):
                self._set_input_file(file_path)
                event.acceptProposedAction()
            else:
                QMessageBox.warning(
                    self,
                    "Invalid File",
                    "Please select a valid audio file (WAV, MP3, FLAC, AAC, M4A)."
                )
                
    def _is_valid_audio_file(self, path: Path) -> bool:
        """Check if file is a valid audio format."""
        valid_extensions = {'.wav', '.mp3', '.flac', '.aac', '.m4a', '.m4p'}
        return path.suffix.lower() in valid_extensions
        
    def _select_input_file(self):
        """Open file dialog to select input audio file."""
        file_path, _ = QFileDialog.getOpenFileName(
            self,
            "Select Audio File",
            "",
            "Audio Files (*.wav *.mp3 *.flac *.aac *.m4a *.m4p);;All Files (*)"
        )
        
        if file_path:
            self._set_input_file(Path(file_path))
            
    def _set_input_file(self, path: Path):
        """Set the input file and update UI."""
        self.input_file = path
        self.input_path_label.setText(str(path))
        self.input_path_label.setStyleSheet("")
        
        # Auto-set output directory to input file's directory
        if self.output_dir is None:
            self.output_dir = path.parent
            self.output_path_label.setText(f"(Same as input: {self.output_dir})")
            
    def _select_output_folder(self):
        """Open folder dialog to select output directory."""
        folder = QFileDialog.getExistingDirectory(
            self,
            "Select Output Folder",
            str(self.output_dir) if self.output_dir else ""
        )
        
        if folder:
            self.output_dir = Path(folder)
            self.output_path_label.setText(str(self.output_dir))
            self.output_path_label.setStyleSheet("")
            
    def _toggle_advanced(self, checked: bool):
        """Show/hide advanced options."""
        self.advanced_widget.setVisible(checked)
        
    def _start_separation(self):
        """Start the drum separation process."""
        if not self.input_file or not self.input_file.exists():
            QMessageBox.warning(
                self,
                "No Input File",
                "Please select an audio file first."
            )
            return
            
        if not self.output_dir:
            self.output_dir = self.input_file.parent
            
        # Prepare output directory
        output_subdir = self.output_dir / f"{self.input_file.stem}_drums"
        output_subdir.mkdir(parents=True, exist_ok=True)
        
        # Build CLI command
        device = self.device_combo.currentText()
        output_format = self.format_combo.currentText()
        model = self.model_combo.currentText() if self.advanced_widget.isVisible() else "Default"
        
        # Create worker
        self.worker = SeparationWorker(
            input_file=self.input_file,
            output_dir=output_subdir,
            device=device,
            output_format=output_format,
            model=model
        )
        
        # Create thread
        self.worker_thread = QThread()
        self.worker.moveToThread(self.worker_thread)
        
        # Connect signals
        self.worker_thread.started.connect(self.worker.run)
        self.worker.finished.connect(self._on_separation_finished)
        self.worker.error.connect(self._on_separation_error)
        self.worker.log_message.connect(self._append_log)
        
        # Update UI
        self.separate_btn.setEnabled(False)
        self.cancel_btn.setEnabled(True)
        self.progress_bar.setVisible(True)
        self.log_text.clear()
        self._append_log("Starting drum separation...")
        self._append_log(f"Input: {self.input_file}")
        self._append_log(f"Output: {output_subdir}")
        
        # Start thread
        self.worker_thread.start()
        
    def _cancel_separation(self):
        """Cancel the running separation process."""
        if self.worker and self.worker.is_running:
            reply = QMessageBox.question(
                self,
                "Cancel Separation",
                "Are you sure you want to cancel the separation?",
                QMessageBox.Yes | QMessageBox.No
            )
            
            if reply == QMessageBox.Yes:
                self.worker.cancel()
                self._append_log("\n[Cancelled by user]")
                
    def _on_separation_finished(self, success: bool, output_dir: Path):
        """Handle separation completion."""
        self.worker_thread.quit()
        self.worker_thread.wait()
        
        self.separate_btn.setEnabled(True)
        self.cancel_btn.setEnabled(False)
        self.progress_bar.setVisible(False)
        
        if success:
            self._append_log("\n✓ Separation completed successfully!")
            QMessageBox.information(
                self,
                "Success",
                f"Drum separation completed!\n\nOutput saved to:\n{output_dir}"
            )
        else:
            self._append_log("\n✗ Separation failed. Check the log above for details.")
            
    def _on_separation_error(self, error: str):
        """Handle separation error."""
        self._append_log(f"\n[ERROR] {error}")
        
    def _append_log(self, message: str):
        """Append message to log window."""
        self.log_text.append(message)
        # Auto-scroll to bottom
        scrollbar = self.log_text.verticalScrollBar()
        scrollbar.setValue(scrollbar.maximum())
        
    def _open_output_folder(self):
        """Open the output folder in file explorer."""
        if self.output_dir and self.output_dir.exists():
            if sys.platform == "win32":
                os.startfile(self.output_dir)
            elif sys.platform == "darwin":
                os.system(f"open '{self.output_dir}'")
            else:
                os.system(f"xdg-open '{self.output_dir}'")
        else:
            QMessageBox.warning(
                self,
                "Output Folder Not Found",
                "Output folder does not exist yet. Run a separation first."
            )


if __name__ == "__main__":
    import sys
    from PySide6.QtWidgets import QApplication
    
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())

