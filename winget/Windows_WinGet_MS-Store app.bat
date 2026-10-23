@echo off
setlocal EnableExtensions
title SP GROUP Uygulama Kurulum Scripti
where winget >nul 2>&1
if errorlevel 1 (
    echo winget bulunamadi. Once Microsoft Store'dan "Uygulama Yukleyici" guncellemesini kurun.
    pause
    exit /b 1
)
echo Lutfen bekleyin...
echo.

echo Microsoft PCManager
winget install -e --id 9PM860492SZD --accept-package-agreements --accept-source-agreements
echo Wintoys
winget install -e --id 9P8LTPGCBZXD --accept-package-agreements --accept-source-agreements
echo Whatsapp
winget install -e --id 9NKSQGP7F2NH --accept-package-agreements --accept-source-agreements
echo PDF Extra
winget install -e --id 9ND1DGRWV3CH --accept-package-agreements --accept-source-agreements

echo ----------------------------------------
echo Herhangi bir tusla cikis yapabilirsiniz.
pause
