#!/bin/bash
# One-time setup: Authenticate GitHub CLI, then trigger build

echo "🔐 Authenticating GitHub CLI..."
gh auth login --git-protocol ssh --hostname github.com

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Authenticated! Now triggering build..."
    gh workflow run "Build Windows EXE on Demand"
    echo ""
    echo "✅ Build triggered! Check progress at:"
    echo "   https://github.com/shoutgeorge1/dj-gui/actions"
    echo ""
    echo "The .exe will be ready in ~5-10 minutes!"
else
    echo "❌ Authentication failed"
    exit 1
fi

