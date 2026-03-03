# Panduan Upload Project ke GitHub

## Persiapan

### 1. Install Git (jika belum)
Download dan install Git dari [git-scm.com](https://git-scm.com/downloads)

Verify instalasi:
```bash
git --version
```

### 2. Setup Git Configuration
```bash
git config --global user.name "Nama Anda"
git config --global user.email "email@anda.com"
```

### 3. Buat Akun GitHub
Jika belum punya, daftar di [github.com](https://github.com)

## Langkah-Langkah Upload

### Step 1: Inisialisasi Git Repository

Buka terminal di folder project:
```bash
cd C:\laragon\www\flutter\schedule
```

Initialize git:
```bash
git init
```

### Step 2: Tambahkan File ke Git

Tambahkan semua file:
```bash
git add .
```

Atau tambahkan file tertentu:
```bash
git add pubspec.yaml
git add lib/
git add android/
git add ios/
git add web/
```

### Step 3: Buat Commit Pertama

```bash
git commit -m "Initial commit: AI Schedule Generator Flutter App"
```

### Step 4: Buat Repository di GitHub

1. Login ke [GitHub](https://github.com)
2. Klik tombol **"+"** di kanan atas
3. Pilih **"New repository"**
4. Isi form:
   - **Repository name:** `ai-schedule-generator`
   - **Description:** `AI-powered schedule generator built with Flutter and OpenAI`
   - **Visibility:** Public atau Private (pilih sesuai kebutuhan)
   - ❌ **JANGAN** centang "Initialize with README" (karena kita sudah punya)
5. Klik **"Create repository"**

### Step 5: Connect ke GitHub Repository

GitHub akan menampilkan instruksi. Copy dan jalankan:

```bash
git remote add origin https://github.com/USERNAME/ai-schedule-generator.git
git branch -M main
git push -u origin main
```

Ganti `USERNAME` dengan username GitHub Anda.

### Step 6: Masukkan Credentials

Saat diminta username dan password:
- **Username:** Username GitHub Anda
- **Password:** Gunakan **Personal Access Token** (bukan password biasa)

#### Cara Buat Personal Access Token:
1. GitHub → Settings → Developer settings
2. Personal access tokens → Tokens (classic)
3. Generate new token (classic)
4. Pilih scope: `repo` (full control)
5. Generate token
6. Copy token (simpan, tidak bisa dilihat lagi!)
7. Gunakan token sebagai password saat git push

## Alternatif: Menggunakan GitHub Desktop

### Cara Mudah dengan GUI:

1. **Download GitHub Desktop**
   - [desktop.github.com](https://desktop.github.com)

2. **Login ke GitHub**
   - Buka GitHub Desktop
   - File → Options → Accounts → Sign in

3. **Add Repository**
   - File → Add local repository
   - Pilih folder: `C:\laragon\www\flutter\schedule`
   - Klik "Add repository"

4. **Publish Repository**
   - Klik "Publish repository"
   - Isi nama: `ai-schedule-generator`
   - Pilih Public/Private
   - Klik "Publish repository"

✅ **Selesai!** Repository sudah di GitHub.

## Update File .gitignore

Pastikan file `.gitignore` sudah benar untuk Flutter:

```bash
# File sudah ada, tapi pastikan berisi:
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# Flutter/Dart/Pub related
**/doc/api/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/

# Android related
**/android/**/gradle-wrapper.jar
**/android/.gradle
**/android/captures/
**/android/gradlew
**/android/gradlew.bat
**/android/local.properties
**/android/**/GeneratedPluginRegistrant.java

# iOS/XCode related
**/ios/**/*.mode1v3
**/ios/**/*.mode2v3
**/ios/**/*.moved-aside
**/ios/**/*.pbxuser
**/ios/**/*.perspectivev3
**/ios/**/*sync/
**/ios/**/.sconsign.dblite
**/ios/**/.tags*
**/ios/**/.vagrant/
**/ios/**/DerivedData/
**/ios/**/Icon?
**/ios/**/Pods/
**/ios/**/.symlinks/
**/ios/**/profile
**/ios/**/xcuserdata
**/ios/.generated/
**/ios/Flutter/App.framework
**/ios/Flutter/Flutter.framework
**/ios/Flutter/Flutter.podspec
**/ios/Flutter/Generated.xcconfig
**/ios/Flutter/app.flx
**/ios/Flutter/app.zip
**/ios/Flutter/flutter_assets/
**/ios/Flutter/flutter_export_environment.sh
**/ios/ServiceDefinitions.json
**/ios/Runner/GeneratedPluginRegistrant.*

# Web related
lib/generated_plugin_registrant.dart

# Exceptions to above rules.
!**/ios/**/default.mode1v3
!**/ios/**/default.mode2v3
!**/ios/**/default.pbxuser
!**/ios/**/default.perspectivev3
!/packages/flutter_tools/test/data/dart_dependencies_test/**/.packages

# API Keys (PENTING!)
.env
*.env
**/secrets.json
```

## Perintah Git yang Berguna

### Cek Status
```bash
git status
```

### Tambah File Baru
```bash
git add nama_file.dart
# atau semua file
git add .
```

### Commit Changes
```bash
git commit -m "Deskripsi perubahan"
```

### Push ke GitHub
```bash
git push
```

### Pull dari GitHub
```bash
git pull
```

### Lihat History
```bash
git log
```

### Buat Branch Baru
```bash
git checkout -b nama-branch
```

### Pindah Branch
```bash
git checkout main
```

### Merge Branch
```bash
git checkout main
git merge nama-branch
```

## Tips Penting

### 🔒 Jangan Upload API Keys!

**PENTING:** Jangan upload API key ke GitHub!

1. Pastikan `.gitignore` sudah benar
2. Jika sudah terlanjur upload API key:
   ```bash
   # Hapus dari history
   git filter-branch --force --index-filter \
   "git rm --cached --ignore-unmatch path/to/file" \
   --prune-empty --tag-name-filter cat -- --all
   
   # Force push
   git push origin --force --all
   
   # Ganti API key di OpenAI dashboard!
   ```

### 📝 Commit Message yang Baik

```bash
# ✅ Good
git commit -m "Add demo schedule feature"
git commit -m "Fix: API error handling"
git commit -m "Update: Change model to gpt-3.5-turbo"

# ❌ Bad
git commit -m "update"
git commit -m "fix bug"
git commit -m "changes"
```

### 🏷️ Gunakan Tags untuk Releases

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## Struktur Commit yang Disarankan

### Commit Pertama:
```bash
git add .
git commit -m "Initial commit: AI Schedule Generator

- Flutter app with Material Design 3
- Support for Android, iOS, and Web
- AI-powered schedule generation with OpenAI
- Demo mode for testing without API
- Local storage with SQLite/SharedPreferences
- Dark mode support"
```

### Commit Berikutnya:
```bash
# Setiap kali ada perubahan
git add .
git commit -m "Add feature: [nama fitur]"
git push
```

## Membuat README.md yang Menarik

File `README.md` sudah ada, tapi bisa ditambahkan:

### Tambahkan Badges:
```markdown
# AI Schedule Generator

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

[Deskripsi project...]
```

### Tambahkan Screenshots:
1. Ambil screenshot aplikasi
2. Simpan di folder `screenshots/`
3. Tambahkan di README:
```markdown
## Screenshots

![Home Screen](screenshots/home.png)
![Schedule Detail](screenshots/detail.png)
```

## Troubleshooting

### Error: "remote origin already exists"
```bash
git remote remove origin
git remote add origin https://github.com/USERNAME/repo.git
```

### Error: "failed to push"
```bash
git pull origin main --rebase
git push origin main
```

### Error: "Permission denied"
- Pastikan menggunakan Personal Access Token
- Atau setup SSH key

### Undo Last Commit
```bash
# Undo commit tapi keep changes
git reset --soft HEAD~1

# Undo commit dan discard changes
git reset --hard HEAD~1
```

## Setelah Upload

### 1. Tambahkan Description di GitHub
- Buka repository di GitHub
- Klik "About" (gear icon)
- Tambahkan description dan topics

### 2. Tambahkan Topics/Tags
Contoh topics:
- `flutter`
- `dart`
- `openai`
- `ai`
- `schedule-generator`
- `mobile-app`
- `web-app`

### 3. Enable GitHub Pages (untuk Web)
1. Settings → Pages
2. Source: Deploy from branch
3. Branch: main, folder: /build/web
4. Save

### 4. Setup GitHub Actions (Optional)
Untuk CI/CD automation.

## Quick Reference

```bash
# Setup awal
git init
git add .
git commit -m "Initial commit"
git remote add origin URL
git push -u origin main

# Workflow harian
git status                    # Cek perubahan
git add .                     # Tambah semua file
git commit -m "message"       # Commit
git push                      # Upload ke GitHub

# Sinkronisasi
git pull                      # Download dari GitHub
git fetch                     # Cek update tanpa merge

# Branch
git branch                    # Lihat branch
git checkout -b new-branch    # Buat branch baru
git merge branch-name         # Merge branch
```

## Kesimpulan

Setelah upload ke GitHub, repository Anda akan tersedia di:
```
https://github.com/USERNAME/ai-schedule-generator
```

Anda bisa:
- ✅ Share dengan orang lain
- ✅ Collaborate dengan team
- ✅ Track changes dan history
- ✅ Deploy ke hosting
- ✅ Showcase di portfolio

---

**Selamat! Project Anda sekarang di GitHub! 🎉**
