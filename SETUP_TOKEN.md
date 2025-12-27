# Setup GitHub Token (One Time)

## Get a Token

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Name it: "dj-gui-automation"
4. Check the **"repo"** permission
5. Click "Generate token"
6. **COPY THE TOKEN** (you won't see it again!)

## Set It Up

**Option 1: Temporary (this terminal session)**
```bash
export GITHUB_TOKEN=your_token_here
```

**Option 2: Permanent (add to ~/.zshrc)**
```bash
echo 'export GITHUB_TOKEN=your_token_here' >> ~/.zshrc
source ~/.zshrc
```

## Then I Can Run

```bash
./auto_release.sh
```

And it will:
- ✅ Trigger the build
- ✅ Wait for it to finish
- ✅ Download the .exe
- ✅ Upload to release
- ✅ Publish everything

**All automatically!**

## Security Note

The token gives full repo access. Keep it secret. If you share your computer, use Option 1 (temporary) instead of Option 2.

