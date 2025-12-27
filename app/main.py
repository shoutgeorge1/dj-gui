"""
DrumSep GUI - Main entry point
"""
import sys
from pathlib import Path

from PySide6.QtWidgets import QApplication

from app.ui.main_window import MainWindow


def main():
    """Launch the DrumSep GUI application."""
    app = QApplication(sys.argv)
    app.setApplicationName("DrumSep GUI")
    app.setOrganizationName("DrumSep")
    
    window = MainWindow()
    window.show()
    
    sys.exit(app.exec())


if __name__ == "__main__":
    main()

