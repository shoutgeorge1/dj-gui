#!/bin/bash
# Update GitHub Release description
# Usage: GITHUB_TOKEN=your_token ./update_release.sh

REPO="shoutgeorge1/dj-gui"
TAG="v1.0.0"
NOTES_FILE="RELEASE_DESCRIPTION_v1.0.0.md"

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN environment variable not set"
    echo ""
    echo "Get a token from: https://github.com/settings/tokens"
    echo "Then run:"
    echo "  GITHUB_TOKEN=your_token ./update_release.sh"
    exit 1
fi

if [ ! -f "$NOTES_FILE" ]; then
    echo "Error: $NOTES_FILE not found"
    exit 1
fi

echo "Updating release $TAG..."

# Read the notes file
NOTES=$(cat "$NOTES_FILE")

# Update the release using GitHub API
curl -X PATCH \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  "https://api.github.com/repos/$REPO/releases/tags/$TAG" \
  -d "{\"body\": $(echo "$NOTES" | jq -Rs .)}" \
  > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Release updated successfully!"
    echo "🔗 View at: https://github.com/$REPO/releases/tag/$TAG"
else
    echo "❌ Failed to update release"
    echo "Check your token permissions"
    exit 1
fi

