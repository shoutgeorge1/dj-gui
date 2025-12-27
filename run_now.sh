#!/bin/bash
# Quick launch script for DrumSep GUI (macOS/Linux)

echo "🚀 Launching DrumSep GUI..."

# Check if venv exists, create if not
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate venv
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install dependencies if needed
if ! python -c "import PySide6" 2>/dev/null; then
    echo "📥 Installing dependencies..."
    pip install -r requirements.txt
fi

# Run the app
echo "✨ Starting GUI..."
python -m app.main

