# Security Guidelines

## 🔒 Protecting Credentials

This project uses sensitive configuration files that should **NEVER** be committed to version control.

### Files to Keep Private

- `.env` (all variants: `.env.dev`, `.env.prod`, `.env.uat`)
- `google-services.json` (Firebase configuration)
- `key.properties` (Android signing keys)
- `*.jks` or `*.keystore` (Keystore files)
- Any file with API keys, tokens, or passwords

### Setup Instructions

1. **Create Local Environment Files**
   ```bash
   # Copy the template
   cp .env.example .env.local
   
   # Edit with your actual values
   # DO NOT commit this file
   ```

2. **Firebase Configuration**
   ```bash
   # Download from Firebase Console
   # Copy to android/app/src/dev/google-services.json
   # DO NOT commit actual credentials
   ```

3. **Android Signing**
   ```bash
   # Create locally
   # Copy key.properties to android/key.properties
   # DO NOT commit to repo
   ```

### GitHub Actions Integration

For CI/CD pipelines, use **GitHub Secrets**:
1. Go to Settings → Secrets and variables → Actions
2. Create new secrets:
   - `ENV_PROD_BASE64` - Base64 encoded .env.prod
   - `FIREBASE_PROD_JSON` - Base64 encoded google-services.json
   - `KEYSTORE_BASE64` - Base64 encoded keystore
   - `KEYSTORE_PASSWORD` - Keystore password
   - `KEY_ALIAS` - Key alias
   - `KEY_PASSWORD` - Key password
   - `API_KEY_PROD` - Production API key

### Checking for Accidental Commits

```bash
# Search git history for passwords
git log -p --all -S "password=" 
git log -p --all -S "api_key="
git log -p --all -S "secret="

# Use BFG Repo-Cleaner to remove from history
# Download: https://rtyley.github.io/bfg-repo-cleaner/
bfg --delete-files "google-services.json"
bfg --replace-text credentials.txt
git reflog expire --expire=now --all && git gc --prune=now --aggressive
git push --force
```

### Rotating Credentials

If credentials are exposed:
1. Immediately rotate the key/token in the service console
2. Remove from git history (see above)
3. Force push to update repository
4. Update GitHub Secrets with new values
5. Redeploy

### Best Practices

✅ **DO:**
- Keep `.env.example` with placeholder values
- Use GitHub Secrets for CI/CD
- Use `.gitignore` to prevent accidental commits
- Rotate credentials regularly
- Review git history before pushing
- Use different credentials per environment (dev/uat/prod)

❌ **DON'T:**
- Commit `.env` files with real values
- Share credentials via email or Slack
- Use same credentials across environments
- Commit Firebase JSON with real API keys
- Store passwords in code comments
- Log or print sensitive values

### Emergency Response

If you accidentally committed credentials:

```bash
# Option 1: Remove from most recent commit (not yet pushed)
git reset HEAD~1
git checkout -- <file>
git add .gitignore
git commit -m "Remove credentials"
git push

# Option 2: Remove from history (already pushed)
# Use BFG Repo-Cleaner (see above)
# Then notify team to re-clone
```

### References

- [GitHub Secret Scanning](https://docs.github.com/en/code-security/secret-scanning/about-secret-scanning)
- [OWASP: Sensitive Data Exposure](https://owasp.org/www-project-top-ten/2017/A3_2017-Sensitive_Data_Exposure)
- [12-Factor App: Config](https://12factor.net/config)
