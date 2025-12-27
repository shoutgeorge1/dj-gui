#!/bin/bash
# Create GitHub Release from Mac
# Requires: GitHub CLI (gh) or manual creation

VERSION="1.0.0"
REPO="shoutgeorge1/dj-gui"

echo "🚀 Creating GitHub Release v$VERSION..."

# Check if GitHub CLI is installed
if command -v gh &> /dev/null; then
    echo "Using GitHub CLI..."
    
    # Create tag if it doesn't exist
    if ! git tag -l | grep -q "v$VERSION"; then
        git tag "v$VERSION"
        git push origin "v$VERSION"
    fi
    
    # Create release (draft, since we don't have the .exe yet)
    gh release create "v$VERSION" \
        --title "DrumSep GUI v$VERSION" \
        --notes "$(cat <<EOF
## DrumSep GUI v$VERSION

A simple, user-friendly Windows application for separating drum stems from audio files.

### ⚠️ Note for Users

**This release is a draft - the Windows executable will be added soon.**

To use DrumSep GUI:
1. Build from source (see README.md)
2. Or wait for the Windows .exe to be uploaded

### Building from Source

\`\`\`powershell
# On Windows
.\scripts\build_exe.ps1
.\scripts\build_installer.ps1
\`\`\`

### Requirements

- Windows 10 or later
- 4 GB RAM minimum
- 2 GB free disk space (for models on first run)

### Support

- Issues: https://github.com/$REPO/issues
- Source: https://github.com/$REPO
EOF
)" \
        --draft \
        --repo "$REPO"
    
    echo "✅ Draft release created!"
    echo "📝 Next: Build the .exe on Windows and upload it to the release"
    echo "🔗 Release: https://github.com/$REPO/releases/tag/v$VERSION"
    
else
    echo "GitHub CLI not found. Creating release manually..."
    echo ""
    echo "Go to: https://github.com/$REPO/releases/new"
    echo ""
    echo "Fill in:"
    echo "  Tag: v$VERSION"
    echo "  Title: DrumSep GUI v$VERSION"
    echo "  Description: (see RELEASE_GUIDE.md)"
    echo "  Check 'Set as a draft'"
    echo "  Click 'Publish release'"
    echo ""
    echo "Then build the .exe on Windows and upload it to the release."
fi

