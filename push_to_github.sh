#!/bin/bash
# Push to GitHub - run this script

echo "🚀 Pushing to GitHub..."

# Check if remote exists
if ! git remote get-url origin &>/dev/null; then
    git remote add origin https://github.com/shoutgeorge1/dj-gui.git
fi

# Push to main branch
echo "Pushing to main branch..."
git push -u origin main

echo "✅ Done! Check https://github.com/shoutgeorge1/dj-gui"

