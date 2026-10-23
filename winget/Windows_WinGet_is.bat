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

winget install -e --id PDFgear.PDFgear --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id geeksoftwareGmbH.PDF24Creator --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Google.EarthPro --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Inkscape.Inkscape --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id KDE.Krita --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Google.Antigravity --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OpenShot.OpenShot --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OSGeo.QGIS_LTR --scope machine --silent --accept-package-agreements --accept-source-agreements

echo ----------------------------------------
echo Herhangi bir tusla cikis yapabilirsiniz.
pause
