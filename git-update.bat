@echo off
echo ========================================
echo   Git Quick Update
echo ========================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git tidak terinstall!
    pause
    exit /b 1
)

REM Check if git repository exists
if not exist ".git" (
    echo ERROR: Bukan git repository!
    echo Jalankan upload-to-github.bat terlebih dahulu.
    pause
    exit /b 1
)

echo Current status:
git status
echo.

set /p COMMIT_MSG="Commit message (contoh: Add new feature): "

if "%COMMIT_MSG%"=="" (
    set COMMIT_MSG=Update project
)

echo.
echo [1/3] Adding files...
git add .

echo.
echo [2/3] Creating commit...
git commit -m "%COMMIT_MSG%"

echo.
echo [3/3] Pushing to GitHub...
git push

if errorlevel 1 (
    echo.
    echo ERROR: Push gagal!
    echo Coba: git pull origin main
    pause
    exit /b 1
)

echo.
echo ========================================
echo   SUCCESS! Changes pushed to GitHub
echo ========================================
echo.

pause
