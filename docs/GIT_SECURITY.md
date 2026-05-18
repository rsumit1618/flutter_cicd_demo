# Git Security Guide - Pre-commit Hooks & Secret Detection

## 🔒 Setup Pre-commit Hook Locally

The pre-commit hook automatically scans commits for secrets before they're pushed.

### Installation

#### macOS / Linux:

```bash
# Navigate to your project
cd flutter_cicd_demo

# Copy the pre-commit hook
cp docs/hooks/pre-commit .git/hooks/pre-commit

# Make it executable
chmod +x .git/hooks/pre-commit

# Test it
git commit -m "Test" --allow-empty
```

#### Windows (PowerShell):

```powershell
# Navigate to your project
cd flutter_cicd_demo

# Copy the pre-commit hook
Copy-Item docs/hooks/pre-commit -Destination .git/hooks/pre-commit

# Note: Git will execute it as a shell script
```

### How It Works

When you try to commit:

```bash
git add .
git commit -m "My changes"
```

The hook:
1. ✅ Scans all staged files
2. ✅ Searches for patterns like "password", "api_key", "secret"
3. ✅ Blocks commit if secrets are found
4. ❌ Shows which file and line contains the secret
5. ✅ Allows commit only if no secrets detected

### Example: Hook Blocks Your Commit

```bash
$ git commit -m "Add API integration"
🔍 Running security pre-commit hook...
❌ SECURITY WARNING: Potential secret found in lib/config.dart
   Pattern: api_key
   Line:
     const String apiKey = "AIzaSyAfLbsCe_hucEuKzxxWyETmZDWs2RYQOIE";

🚨 COMMIT BLOCKED: Found 1 potential secret(s)

What to do:
1. Review the files above
2. Move secrets to .env.example or GitHub Secrets
3. Use 'git reset' to unstage and try again

To bypass (NOT RECOMMENDED):
  git commit --no-verify
```

### Fix Your Commit

```bash
# Reset the changes
git reset

# Move API key to .env.example
# Edit your code to use environment variable

# Stage only the safe changes
git add lib/config.dart

# Commit again (should pass this time)
git commit -m "Add API integration with env vars"
```

---

## 🔍 Manual Secret Scanning

### Search for Secrets in Your Repository

```bash
# Search current branch for API keys
git log -p -S "api_key" | head -100

# Search for password patterns
git log -p --all -S "password:" | head -100

# Search for AWS secrets
git log -p --all -S "AKIA" | head -50

# Search all history for Firebase API keys
git log -p --all | grep -i "AIza" | head -20
```

### Using grep to find secrets:

```bash
# Search working directory
grep -r "password" --include="*.dart" --include="*.java" --include="*.kt"
grep -r "api_key" --include="*.env"
grep -r "secret" --include="*.json"
```

### Using specialized tools:

```bash
# Install git-secrets (macOS)
brew install git-secrets

# Install git-secrets (Linux)
git clone https://github.com/awslabs/git-secrets.git
cd git-secrets && make install

# Configure git-secrets
git secrets --install
git secrets --register-aws

# Scan repository
git secrets --scan
```

---

## 🚨 If You Accidentally Committed a Secret

### Quick Fix (Not yet pushed):

```bash
# Remove file from last commit
git reset HEAD~1 lib/config.dart

# Edit to remove secret
# Then recommit
git add lib/config.dart
git commit -m "Fix: Remove hardcoded API key"
```

### Already Pushed to GitHub:

```bash
# Use BFG Repo-Cleaner to remove from history
brew install bfg

# Remove the file from all history
bfg --delete-files "config.dart"

# Clean up
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force push
git push --force --all origin
```

---

## 🔑 Secure Pattern: Use Environment Variables

### ❌ DON'T DO THIS:

```dart
// lib/config/api_config.dart
const String API_KEY = "AIzaSyAfLbsCe_hucEuKzxxWyETmZDWs2RYQOIE";  // ❌ EXPOSED!
```

### ✅ DO THIS INSTEAD:

**Step 1: Create .env.local (never commit)**
```
API_KEY=AIzaSyAfLbsCe_hucEuKzxxWyETmZDWs2RYQOIE
```

**Step 2: Load in code**
```dart
// lib/core/config/env_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}
```

**Step 3: Use in your app**
```dart
// lib/config/api_config.dart
const String API_KEY = EnvConfig.apiKey;  // ✅ SAFE!
```

**Step 4: For CI/CD, use GitHub Secrets**
```yaml
# .github/workflows/build.yml
- name: Build
  env:
    API_KEY: ${{ secrets.API_KEY_PROD }}
  run: flutter build apk --dart-define=API_KEY=${{ secrets.API_KEY_PROD }}
```

---

## ✅ Best Practices

### DO:
- ✅ Use `.env.example` for templates
- ✅ Store secrets in GitHub Secrets
- ✅ Use environment variables in code
- ✅ Run pre-commit hook before pushing
- ✅ Review git history before sharing
- ✅ Rotate credentials regularly
- ✅ Use different credentials per environment (dev/prod)

### DON'T:
- ❌ Commit `.env` with real values
- ❌ Hardcode API keys in code
- ❌ Share credentials via email/Slack
- ❌ Use same key for dev and production
- ❌ Log or print secrets
- ❌ Share private keys
- ❌ Commit Firebase keys

---

## 🔗 References

- [git-secrets](https://github.com/awslabs/git-secrets)
- [OWASP: Secrets Management](https://owasp.org/www-project-secure-coding-practices/)
- [GitHub Secret Scanning](https://docs.github.com/en/code-security/secret-scanning/)
- [12-Factor App: Store config in environment](https://12factor.net/config)
