#!/bin/bash
# Set this up once, then I can run it automatically
# Usage: GITHUB_TOKEN=your_token ./auto_release.sh

set -e

REPO="shoutgeorge1/dj-gui"
RELEASE_TAG="v1.0.0"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "❌ GITHUB_TOKEN not set"
    echo ""
    echo "Get a token: https://github.com/settings/tokens"
    echo "Click 'Generate new token (classic)'"
    echo "Check 'repo' permission"
    echo "Copy the token"
    echo ""
    echo "Then run:"
    echo "  export GITHUB_TOKEN=your_token_here"
    echo "  ./auto_release.sh"
    echo ""
    echo "Or add to your ~/.zshrc:"
    echo "  export GITHUB_TOKEN=your_token_here"
    exit 1
fi

echo "🚀 Auto Release Script"
echo "===================="
echo ""

# Step 1: Trigger build
echo "Step 1: Triggering build..."
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$REPO/actions/workflows/build-on-demand.yml/dispatches" \
  -d '{"ref":"main"}' \
  > /dev/null 2>&1

echo "✅ Build triggered!"
echo "⏳ Waiting for build to complete (this takes 5-10 minutes)..."
echo ""

# Step 2: Wait for workflow to complete
WORKFLOW_RUN_ID=""
for i in {1..60}; do
    sleep 10
    RUNS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
      "https://api.github.com/repos/$REPO/actions/runs?per_page=1")
    
    RUN_ID=$(echo "$RUNS" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d['workflow_runs'][0]['id'] if d['workflow_runs'] else '')" 2>/dev/null)
    STATUS=$(echo "$RUNS" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d['workflow_runs'][0]['status'] if d['workflow_runs'] else '')" 2>/dev/null)
    CONCLUSION=$(echo "$RUNS" | python3 -c "import sys, json; d=json.load(sys.stdin); print(d['workflow_runs'][0]['conclusion'] if d['workflow_runs'] else '')" 2>/dev/null)
    
    if [ -n "$RUN_ID" ]; then
        WORKFLOW_RUN_ID=$RUN_ID
        echo -n "."
        
        if [ "$STATUS" = "completed" ]; then
            echo ""
            if [ "$CONCLUSION" = "success" ]; then
                echo "✅ Build completed successfully!"
                break
            else
                echo "❌ Build failed. Check: https://github.com/$REPO/actions/runs/$RUN_ID"
                exit 1
            fi
        fi
    fi
done

if [ -z "$WORKFLOW_RUN_ID" ] || [ "$CONCLUSION" != "success" ]; then
    echo "❌ Build didn't complete successfully"
    exit 1
fi

# Step 3: Download artifact
echo ""
echo "Step 2: Downloading .exe..."
mkdir -p dist
ARTIFACT_URL=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/$REPO/actions/runs/$WORKFLOW_RUN_ID/artifacts" | \
  python3 -c "import sys, json; d=json.load(sys.stdin); a=[x for x in d['artifacts'] if x['name']=='DrumSepGUI-Windows']; print(a[0]['archive_download_url'] if a else '')" 2>/dev/null)

if [ -z "$ARTIFACT_URL" ]; then
    echo "❌ Couldn't find artifact"
    exit 1
fi

curl -L -H "Authorization: token $GITHUB_TOKEN" \
  "$ARTIFACT_URL" -o dist/artifact.zip

unzip -q -o dist/artifact.zip -d dist/
rm dist/artifact.zip

if [ ! -f "dist/DrumSepGUI.exe" ]; then
    echo "❌ .exe not found in artifact"
    exit 1
fi

echo "✅ Downloaded: dist/DrumSepGUI.exe"

# Step 4: Upload to release
echo ""
echo "Step 3: Uploading to release..."
UPLOAD_URL=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
  "https://api.github.com/repos/$REPO/releases/tags/$RELEASE_TAG" | \
  python3 -c "import sys, json; d=json.load(sys.stdin); print(d.get('upload_url', '').split('{')[0])" 2>/dev/null)

if [ -z "$UPLOAD_URL" ]; then
    echo "❌ Couldn't get release upload URL"
    exit 1
fi

curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/octet-stream" \
  --data-binary "@dist/DrumSepGUI.exe" \
  "$UPLOAD_URL?name=DrumSepGUI.exe" \
  > /dev/null 2>&1

echo "✅ Uploaded to release!"

# Step 5: Update release (remove draft, update description)
echo ""
echo "Step 4: Updating release..."
if [ -f "RELEASE_DESCRIPTION_v1.0.0.md" ]; then
    NOTES=$(cat RELEASE_DESCRIPTION_v1.0.0.md)
    curl -X PATCH \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/repos/$REPO/releases/tags/$RELEASE_TAG" \
      -d "{\"draft\":false,\"body\":$(python3 -c "import json, sys; print(json.dumps(sys.stdin.read()))" <<< "$NOTES")}" \
      > /dev/null 2>&1
else
    curl -X PATCH \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Accept: application/vnd.github.v3+json" \
      "https://api.github.com/repos/$REPO/releases/tags/$RELEASE_TAG" \
      -d '{"draft":false}' \
      > /dev/null 2>&1
fi

echo "✅ Release published!"
echo ""
echo "🎉 DONE! Release is live:"
echo "   https://github.com/$REPO/releases/tag/$RELEASE_TAG"
echo ""
echo "Windows users can now download DrumSepGUI.exe!"

