#!/bin/bash
# This does EVERYTHING - just authenticate once, then it handles the rest

set -e

REPO="shoutgeorge1/dj-gui"
RELEASE_TAG="v1.0.0"

echo "🚀 DrumSep GUI - Automated Build & Release"
echo "=========================================="
echo ""

# Step 1: Authenticate (one-time only)
echo "Step 1: Checking GitHub authentication..."
if ! gh auth status &>/dev/null; then
    echo "⚠️  Need to authenticate (one-time only)..."
    gh auth login --git-protocol ssh --hostname github.com
else
    echo "✅ Already authenticated!"
fi

# Step 2: Trigger the build
echo ""
echo "Step 2: Triggering Windows build..."
gh workflow run "Build Windows EXE on Demand" --ref main

# Get the workflow run ID
echo "⏳ Waiting for workflow to start..."
sleep 5

# Find the workflow run
RUN_ID=$(gh run list --workflow="Build Windows EXE on Demand" --limit 1 --json databaseId --jq '.[0].databaseId')

if [ -z "$RUN_ID" ] || [ "$RUN_ID" = "null" ]; then
    echo "❌ Couldn't find workflow run. Check manually:"
    echo "   https://github.com/$REPO/actions"
    exit 1
fi

echo "✅ Build started! Run ID: $RUN_ID"
echo "📊 Watch progress: https://github.com/$REPO/actions/runs/$RUN_ID"
echo ""

# Step 3: Wait for build to complete
echo "Step 3: Waiting for build to complete (this takes 5-10 minutes)..."
echo "   (You can close this terminal - the build will continue)"
echo ""

gh run watch $RUN_ID

# Step 4: Download the artifact
echo ""
echo "Step 4: Downloading the .exe file..."
mkdir -p dist
gh run download $RUN_ID --name "DrumSepGUI-Windows" --dir dist

if [ ! -f "dist/DrumSepGUI.exe" ]; then
    echo "❌ .exe not found. Build may have failed."
    echo "   Check: https://github.com/$REPO/actions/runs/$RUN_ID"
    exit 1
fi

echo "✅ Downloaded: dist/DrumSepGUI.exe"

# Step 5: Upload to release
echo ""
echo "Step 5: Uploading to GitHub release..."
gh release upload $RELEASE_TAG dist/DrumSepGUI.exe --clobber

# Step 6: Update release (remove draft, update description)
echo ""
echo "Step 6: Updating release..."
if [ -f "RELEASE_DESCRIPTION_v1.0.0.md" ]; then
    gh release edit $RELEASE_TAG \
        --draft=false \
        --notes-file RELEASE_DESCRIPTION_v1.0.0.md
else
    gh release edit $RELEASE_TAG --draft=false
fi

echo ""
echo "✅✅✅ DONE! ✅✅✅"
echo ""
echo "Your release is live:"
echo "   https://github.com/$REPO/releases/tag/$RELEASE_TAG"
echo ""
echo "Windows users can now download DrumSepGUI.exe!"
echo ""

