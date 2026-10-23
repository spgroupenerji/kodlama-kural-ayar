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

winget install -e --id Chocolatey.Chocolatey --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Oracle.JavaRuntimeEnvironment --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Oracle.JDK.24 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Python.Python.3.14 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id OpenJS.NodeJS.LTS --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Thales.SafeNetAuthenticationClient --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ACS.CCIDPCSCDriver --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ACS.UnifiedPCSCDriver --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id ClockworkMod.UniversalADBDriver --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Google.PlatformTools --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Google.WorkspaceSyncForMicrosoftOutlook --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCLibs.Desktop.14 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2005.x64 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2005.x86 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2008.x64 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2008.x86 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2010.x64 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2010.x86 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2012.x64 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2012.x86 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2013.x64 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2013.x86 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2015+.x64 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.VCRedist.2015+.x86 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.WindowsAppRuntime.1.7 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DotNet.AspNetCore.9 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DotNet.DesktopRuntime.9 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DotNet.RepairTool --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DotNet.Runtime.9 --scope machine --silent --accept-package-agreements --accept-source-agreements
winget install -e --id Microsoft.DotNet.SDK.9 --scope machine --silent --accept-package-agreements --accept-source-agreements

echo ----------------------------------------
echo Herhangi bir tusla cikis yapabilirsiniz.
pause
