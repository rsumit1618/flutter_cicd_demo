# 🚨 URGENT: Remove Exposed Google Services Credentials

## ⚠️ Critical Issue

Your `google-services.json` file is exposed in git history with real credentials:
- **Firebase Project ID:** flutter-cicd-demo-d2457
- **Firebase API Key:** AIzaSyAfLbsCe_hucEuKzxxWyETmZDWs2RYQOIE
- **Project Number:** 489097693033

**IMMEDIATE ACTION REQUIRED:**
1. Rotate Firebase API key immediately
2. Remove from git history
3. Update all projects

---

## 📋 Step-by-Step Cleanup

### Step 1: Rotate Your Firebase API Key (DO THIS FIRST!)

```bash
# Go to Google Cloud Console
# URL: https://console.cloud.google.com/apis/credentials

# Steps:
# 1. Find API Key: AIzaSyAfLbsCe_hucEuKzxxWyETmZDWs2RYQOIE
# 2. Click to open
# 3. Click "Edit" → Change name to "old-key-revoked"
# 4. Go back and click the three dots → "Delete"
# 5. Create new key → Name it "prod-key" → Save
# 6. Copy new key and save for later
```

### Step 2: Remove from Git History (Local Machine)

```bash
# 1. Clone or navigate to your repository
cd flutter_cicd_demo

# 2. Install BFG Repo-Cleaner (one-time)
# Option A: Using Homebrew (macOS/Linux)
brew install bfg

# Option B: Manual download
# Visit: https://rtyley.github.io/bfg-repo-cleaner/
# Download and add to PATH

# 3. Create a backup
git clone --mirror https://github.com/rsumit1618/flutter_cicd_demo.git flutter_cicd_demo.git.bak

# 4. Run BFG to remove google-services.json from all history
bfg --delete-files "google-services.json" --no-blob-protection

# Alternative: For specific pattern
bfg --replace-text credentials.txt

# 5. Cleanup and optimize
cd flutter_cicd_demo
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 6. Force push to update GitHub (CAREFUL - this rewrites history)
git push --force --all origin
git push --force --tags origin
```

### Step 3: Update .gitignore

```bash
# Add to .gitignore:
google-services.json
.env
.env.prod
.env.dev
*.jks
*.keystore
key.properties
```

### Step 4: Create Templates

```bash
# Create example files (these are safe to commit)
cp android/app/src/dev/google-services.json android/app/src/dev/google-services.json.example
# Edit to remove real credentials

# Document the process
echo "Follow SECURITY.md for setup instructions"
```

### Step 5: Notify Collaborators

Send message to anyone with repo access:
```
🚨 SECURITY UPDATE: Credentials were exposed

Affected: flutter_cicd_demo repository
Action: Git history has been rewritten

Please:
1. Back up any local changes
2. Delete local clone: rm -rf flutter_cicd_demo
3. Re-clone fresh: git clone https://github.com/rsumit1618/flutter_cicd_demo.git
4. Do NOT pull (pull will try to merge old history)
```

---

## 🔒 Update GitHub Secrets

```bash
# Go to: Settings → Secrets and variables → Actions

# Add/Update these secrets:
FIREBASE_PROD_JSON = (base64 of new google-services.json)
API_KEY_PROD = (your new API key)
KEYSTORE_PASSWORD = (if you have one)
KEY_ALIAS = (if you have one)
```

To base64 encode:

**Windows PowerShell:**
```powershell
$content = [System.IO.File]::ReadAllBytes("android/app/src/prod/google-services.json")
$encoded = [System.Convert]::ToBase64String($content)
$encoded | Set-Content encoded.txt
```

**macOS/Linux:**
```bash
base64 -i android/app/src/prod/google-services.json -o encoded.txt
cat encoded.txt  # Copy to GitHub Secret
```

---

## ✅ Verification Checklist

After cleanup:

```
☐ Firebase API key rotated (old key deleted)
☐ BFG removed credentials from git history
☐ git push --force completed
☐ .gitignore updated
☐ google-services.json.example created (no real creds)
☐ .env.example created (no real creds)
☐ GitHub Secrets updated with new values
☐ SECURITY.md documentation added
☐ Team notified to re-clone
☐ Commit: "Security: Rotate credentials and add templates"
```

---

## 🚨 If You Can't Use BFG

Alternative using git filter-branch (slower, manual):

```bash
# Remove file from history
git filter-branch --tree-filter 'rm -f android/app/src/dev/google-services.json' HEAD

# Remove all branches
git filter-branch -f --tree-filter 'rm -f android/app/src/dev/google-services.json' -- --all

# Force push
git push --force --all
```

---

## 📞 Emergency Contacts

If credentials are actively being abused:

1. **Google Cloud Console:**
   - Disable API key immediately
   - Check usage logs: APIs & Services → Credentials → API key

2. **GitHub:**
   - Check recent activity in repository
   - Review Actions logs for unauthorized access
   - Review deploy history

3. **Rotate immediately:**
   - Firebase project settings
   - Any connected services
   - Update all dependencies

---

## 🎯 Going Forward

Apply these to ALL 12 repositories:

1. Add `.gitignore` (template provided)
2. Add `SECURITY.md` (template provided)
3. Create `.example` templates for credentials
4. Enable branch protection on `main`
5. Enable secret scanning: Settings → Code security
6. Setup pre-commit hooks: `docs/GIT_SECURITY.md`

