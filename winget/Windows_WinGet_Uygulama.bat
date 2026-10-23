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

winget install -e --id Google.Chrome --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Zen-Team.Zen-Browser --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id 7zip.7zip --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Notepad++.Notepad++ --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id VideoLAN.VLC --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id VovSoft.PDFReader --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ONLYOFFICE.DesktopEditors --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Bandisoft.Honeyview --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id IObit.IObitUnlocker --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id HiBitSoftware.HiBitUninstaller --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Klocman.BulkCrapUninstaller --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OO-Software.AppBuster --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OO-Software.ShutUp10 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ChuyuTeam.DISM++ --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id WiseCleaner.WiseMemoryOptimizer --scope machine --silent --accept-package-agreements --accept-source-agreements

echo ----------------------------------------
echo Herhangi bir tusla cikis yapabilirsiniz.
pause
