# Main Branch Protection Guide

## 🔒 Protect Your Main Branch

This guide shows how to enable branch protection on the `main` branch so:
- ✅ Only approved pull requests can merge
- ✅ Nobody can force push or delete the branch
- ✅ All status checks must pass
- ✅ Even admins need to follow the rules

---

## 📋 Step-by-Step Setup

### Step 1: Open Branch Settings

1. Go to your repository on GitHub
2. Click **Settings** (gear icon)
3. Click **Branches** (left sidebar)
4. Click **Add rule** under "Branch protection rules"

### Step 2: Configure the Rule

**Branch name pattern:** `main`

### Step 3: Enable Protections

Check these boxes:

#### ✅ Require a pull request before merging
```
☑ Require approvals
  └─ Number of approvals required: 1

☑ Dismiss stale pull request approvals when new commits are pushed

☑ Require review from code owners
```

#### ✅ Require status checks to pass before merging
- Enable if you have GitHub Actions workflows
- Select which checks must pass

#### ✅ Require branches to be up to date before merging
- Prevents merging stale branches

#### ✅ Require signed commits
- Extra security (optional)

#### ✅ Include administrators
- **IMPORTANT:** Forces even you to use pull requests
- Prevents accidental direct pushes

#### ✅ Restrict who can push to matching branches
- Select "Restrict who can push to matching branches"
- Add only: **rsumit1618** (your username)
- This means only you can directly push to main

#### ✅ Allow force pushes
- ☑ No one (recommended)

#### ✅ Allow deletions
- ☑ No one

### Step 4: Save

Click **Create** or **Save changes**

---

## ✅ What You Now Have

After setup:

| Action | Who Can Do It |
|--------|---|
| Direct push to main | ❌ Nobody (not even you) |
| Force push to main | ❌ Nobody |
| Delete main branch | ❌ Nobody |
| Create pull request | ✅ Anyone |
| Approve pull request | ✅ Any collaborator |
| Merge pull request | ✅ Only you (as code owner) |

---

## 🔄 Workflow with Protection Enabled

As a developer:

```bash
# You cannot do this anymore:
git push origin main  # ❌ REJECTED

# You must do this:
git checkout -b feature/my-feature
git push origin feature/my-feature

# Then on GitHub:
# 1. Create Pull Request
# 2. Wait for your approval
# 3. Merge via GitHub UI
```

---

## 📋 Apply to ALL Your Repositories

Go through each repository and repeat Steps 1-4:

```
☐ app_base_kit
☐ app_stream_kit
☐ Bazaaro
☐ easy_localization_flutter
☐ echo-me
☐ flutter_cicd_demo (do this one first)
☐ image_picker_cropper_flutter
☐ kickstart
☐ neosoft-assignment
☐ rsumit1618 (profile repo)
☐ social_backend
☐ todo-by-sumit
```

---

## 🆘 Bypass Protection (Emergency Only)

If you absolutely need to bypass:

1. **Temporarily disable protection:**
   - Settings → Branches → Edit rule
   - Uncheck "Include administrators"
   - Push your changes
   - Re-enable protection

2. **Use admin override:**
   - Settings → Branches → Edit rule
   - Check "Allow specified actors to bypass required pull requests"
   - Add yourself
   - (Not recommended - removes the protection!)

---

## 🎯 Recommended Configuration Summary

```
Main Branch Protection Settings
═══════════════════════════════════════════

✅ Require pull request: YES
   - Require approvals: 1
   - Include administrators: YES

✅ Require status checks: YES (if you have CI/CD)

✅ Require branches up to date: YES

✅ Restrict who can push: YES
   - Only: rsumit1618 (you)

✅ Allow force pushes: NO

✅ Allow deletions: NO

Result: Iron-clad protection against accidental or malicious changes
```

---

## 📞 Need Help?

- Can't merge a PR? Make sure you've approved it.
- Got conflicts? Rebase locally before pushing.
- Need emergency access? Temporarily disable protection.

---

## 🔒 Additional Security: Enable Secret Scanning

While you're in Settings:

1. Click **Code security and analysis**
2. Enable **Dependabot alerts**
3. Enable **Secret scanning**
4. Enable **Push protection** (blocks commits with secrets)

This provides automatic detection of exposed credentials!
