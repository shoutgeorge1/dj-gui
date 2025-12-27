# Final Simple Process

## Step 1: Trigger Build (Manual - 2 Clicks)

1. Go to: https://github.com/shoutgeorge1/dj-gui/actions
2. Click "Build Windows EXE on Demand"
3. Click "Run workflow" → "Run workflow"
4. **Wait 5-10 minutes**

## Step 2: When Build Succeeds

Once you see a **green checkmark**:

1. Click the completed workflow run
2. Scroll to "Artifacts"
3. Download `DrumSepGUI-Windows` (contains the .exe)

## Step 3: Upload to Release

1. Go to: https://github.com/shoutgeorge1/dj-gui/releases/edit/v1.0.0
2. Drag the downloaded `DrumSepGUI.exe` into the release
3. Uncheck "Set as a draft"
4. Click "Update release"

**DONE!** Windows users can download it.

---

**Note**: The workflow is fixed and should work now. The token automation is having permission issues, but manual trigger works fine and is just as fast.

