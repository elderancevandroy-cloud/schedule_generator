@echo off
echo ========================================
echo   AI Schedule Generator - GitHub Upload
echo ========================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git tidak terinstall!
    echo Download dari: https://git-scm.com/downloads
    pause
    exit /b 1
)

echo [1/6] Checking git status...
git status

echo.
echo [2/6] Initializing git repository...
git init

echo.
echo [3/6] Adding files to git...
git add .

echo.
echo [4/6] Creating first commit...
git commit -m "Initial commit: AI Schedule Generator Flutter App - Support Android, iOS, Web with OpenAI integration and demo mode"

echo.
echo ========================================
echo   Setup GitHub Repository
echo ========================================
echo.
echo Langkah selanjutnya:
echo 1. Buka https://github.com/new
echo 2. Repository name: ai-schedule-generator
echo 3. Description: AI-powered schedule generator built with Flutter
echo 4. Pilih Public atau Private
echo 5. JANGAN centang "Initialize with README"
echo 6. Klik "Create repository"
echo.
echo Setelah repository dibuat, GitHub akan menampilkan URL.
echo.

set /p REPO_URL="Paste GitHub repository URL (contoh: https://github.com/username/ai-schedule-generator.git): "

if "%REPO_URL%"=="" (
    echo ERROR: URL tidak boleh kosong!
    pause
    exit /b 1
)

echo.
echo [5/6] Connecting to GitHub repository...
git remote add origin %REPO_URL%
git branch -M main

echo.
echo [6/6] Pushing to GitHub...
echo.
echo CATATAN: Anda akan diminta username dan password
echo - Username: GitHub username Anda
echo - Password: Gunakan Personal Access Token (bukan password biasa)
echo.
echo Cara buat token: GitHub Settings -^> Developer settings -^> Personal access tokens
echo.

git push -u origin main

if errorlevel 1 (
    echo.
    echo ERROR: Push gagal!
    echo.
    echo Kemungkinan penyebab:
    echo 1. Token/password salah
    echo 2. Repository URL salah
    echo 3. Tidak ada koneksi internet
    echo.
    echo Coba manual dengan:
    echo git push -u origin main
    pause
    exit /b 1
)

echo.
echo ========================================
echo   SUCCESS! Project uploaded to GitHub
echo ========================================
echo.
echo Repository URL: %REPO_URL%
echo.
echo Langkah selanjutnya:
echo 1. Buka repository di GitHub
echo 2. Tambahkan description dan topics
echo 3. Invite collaborators (jika ada)
echo 4. Setup GitHub Pages untuk web demo
echo.
echo Untuk update di masa depan:
echo   git add .
echo   git commit -m "Your message"
echo   git push
echo.

pause
