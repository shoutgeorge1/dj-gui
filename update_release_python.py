#!/usr/bin/env python3
"""Update GitHub Release description using API"""
import os
import sys
import json
import requests

REPO = "shoutgeorge1/dj-gui"
TAG = "v1.0.0"
NOTES_FILE = "RELEASE_DESCRIPTION_v1.0.0.md"

def main():
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        print("Error: GITHUB_TOKEN environment variable not set")
        print("\nGet a token from: https://github.com/settings/tokens")
        print("Then run:")
        print("  GITHUB_TOKEN=your_token python3 update_release_python.py")
        sys.exit(1)
    
    if not os.path.exists(NOTES_FILE):
        print(f"Error: {NOTES_FILE} not found")
        sys.exit(1)
    
    # Read the notes
    with open(NOTES_FILE, 'r', encoding='utf-8') as f:
        notes = f.read()
    
    # Update the release
    url = f"https://api.github.com/repos/{REPO}/releases/tags/{TAG}"
    headers = {
        "Authorization": f"token {token}",
        "Accept": "application/vnd.github.v3+json"
    }
    data = {
        "body": notes
    }
    
    print(f"Updating release {TAG}...")
    response = requests.patch(url, headers=headers, json=data)
    
    if response.status_code == 200:
        print("✅ Release updated successfully!")
        print(f"🔗 View at: https://github.com/{REPO}/releases/tag/{TAG}")
    else:
        print(f"❌ Failed to update release: {response.status_code}")
        print(response.text)
        sys.exit(1)

if __name__ == "__main__":
    main()

