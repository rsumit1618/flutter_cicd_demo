# 🚀 Flutter PROD CI/CD Guide

This guide explains a **production-ready Flutter CI/CD setup** including flavors, Firebase, secure secrets, and GitHub Actions workflow.

---

## 📦 Project Features

- Flutter 3.32.1 (Stable) and Dart 3.8.1
- Multiple flavors: **dev** / **prod**
- Firebase integration per flavor
- Environment-specific `.env` files in project root
- Secure API keys, Google Maps keys, and keystore credentials
- GitHub Actions workflow to automatically generate release AAB
- Dynamic version naming: `app_v<version>.aab`
- Artifacts stored in GitHub Actions workflow
- Node.js 20 → Node.js 24 warning fix for actions
- Handles PROD-only CI/CD safely while keeping `.env.dev` local

---

## 📂 Folder Structure

```
flutter_cicd_demo/
├─ android/
│  ├─ app/
│  │  ├─ src/
│  │  │  ├─ dev/
│  │  │  │  └─ google-services.json
│  │  │  └─ prod/
│  │  │     └─ google-services.json
│  │  └─ upload-keystore.jks
├─ lib/
│  └─ main.dart
├─ .env.dev       # Local dev environment
├─ .env.prod      # Production environment for CI/CD
├─ pubspec.yaml
└─ .github/
   └─ workflows/
      └─ flutter_ci_cd.yml
```

---

## 🔐 Environment & Secrets Setup

### 1️⃣ Create `.env` files

Root-level environment files for dev and prod:

```
.env.dev   → Local development (API keys, Firebase, Google Maps key)
.env.prod  → Production CI/CD (API keys, Firebase, Google Maps key)
```

Example `.env.prod`:

```env
API_KEY=your_prod_api_key
MAP_KEY=your_prod_google_map_key
FLAVOR=prod
```

---

### 2️⃣ Convert Files to Base64

Windows PowerShell example:

```powershell
# Convert PROD environment file
[Convert]::ToBase64String([IO.File]::ReadAllBytes(".env.prod")) | Set-Content env_prod_base64.txt

# Convert Firebase PROD JSON
[Convert]::ToBase64String([IO.File]::ReadAllBytes("android/app/src/prod/google-services.json")) | Set-Content firebase_prod_base64.txt

# Convert Keystore
[Convert]::ToBase64String([IO.File]::ReadAllBytes("android/app/upload-keystore.jks")) | Set-Content keystore_base64.txt
```

---

### 3️⃣ Add GitHub Secrets

Go to **Settings → Secrets → Actions** and add the following:

| Secret Name | Description |
|---|---|
| `ENV_PROD_BASE64` | Base64 encoded `.env.prod` |
| `ENV_DEV_BASE64` | Base64 encoded `.env.dev` (optional for future DEV workflow) |
| `FIREBASE_PROD_JSON` | Base64 encoded Firebase PROD JSON |
| `KEYSTORE_BASE64` | Base64 encoded keystore |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_ALIAS` | Key alias |
| `KEY_PASSWORD` | Key password |
| `API_KEY_PROD` | Production API key |
| `MAP_KEY_PROD` | Production Google Maps key |

---

## 🛠 Flutter Flavors Setup

```groovy
// android/app/build.gradle
flavorDimensions "flavor"
productFlavors {
    dev {
        dimension "flavor"
        applicationIdSuffix ".dev"
    }
    prod {
        dimension "flavor"
        applicationId "com.example.flutter_cicd_demo"
    }
}
```

In `lib/main.dart`, select environment dynamically:

```dart
const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
```

---

## ⚡ GitHub Actions Workflow (PROD)

Final PROD-only CI/CD workflow YAML with all fixes applied:

```yaml
name: Flutter PROD Build

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      FORCE_JAVASCRIPT_ACTIONS_TO_NODE24: true  # Fix Node.js 20 deprecation warning
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.1'

      - name: Install dependencies
        run: flutter pub get

      - name: Setup ENV PROD
        run: |
          echo "${{ secrets.ENV_PROD_BASE64 }}" | base64 --decode > .env.prod

      - name: Setup Firebase
        run: |
          mkdir -p android/app/src/prod
          echo "${{ secrets.FIREBASE_PROD_JSON }}" | base64 --decode > android/app/src/prod/google-services.json

      - name: Setup Keystore
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/upload-keystore.jks
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" > android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=upload-keystore.jks" >> android/key.properties

      - name: Build AAB
        run: |
          flutter build appbundle \
            --flavor prod \
            --release \
            --dart-define=FLAVOR=prod \
            --dart-define=API_KEY=${{ secrets.API_KEY_PROD }} \
            -PMAP_KEY=${{ secrets.MAP_KEY_PROD }}

      - name: Get Version
        id: version
        run: |
          VERSION=$(grep 'version:' pubspec.yaml | awk '{print $2}' | cut -d '+' -f 1)
          echo "VERSION=$VERSION" >> $GITHUB_ENV

      - name: Rename AAB
        run: |
          mv build/app/outputs/bundle/prodRelease/app-prod-release.aab \
             build/app/outputs/bundle/prodRelease/app_v${VERSION}.aab

      - name: Upload Artifact
        uses: actions/upload-artifact@v4
        with:
          name: prod-build
          path: build/app/outputs/bundle/prodRelease/
```

---

## 🎯 How CI/CD Works

1. Push code to **main** branch
2. GitHub Actions decodes secrets → rebuilds `.env.prod` and Firebase JSON
3. Keystore rebuilt → signing configured
4. Flutter builds PROD flavor AAB
5. Output renamed to `app_v<version>.aab`
6. Artifact uploaded → available in **GitHub Actions → Artifacts** section

---

## ✅ Best Practices

- Never commit `.env` or Firebase JSON with secrets
- Always use GitHub Secrets for sensitive data
- Use flavors to separate DEV and PROD builds
- Keep workflow YAML in `.github/workflows/`
- Handle Node.js 24 migration in workflow to avoid future warnings
- Keep `.env.dev` local for development (optional: create DEV workflow using `ENV_DEV_BASE64`)

---

## 🎉 Next Steps

- Integrate **Fastlane** to auto-upload AAB to Play Store
- Add **Firebase App Distribution** for testers
- Automate iOS CI/CD (if applicable)
- Auto-increment version using workflow
- Prepare future DEV workflow using `ENV_DEV_BASE64`

---

## 🔗 References

- [Flutter Flavors](https://flutter.dev/docs/deployment/flavors)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [Flutter GitHub Actions Example](https://github.com/subosito/flutter-action)

---

> 🎯 Complete production-ready Flutter CI/CD guide with all fixes and workflow steps included.