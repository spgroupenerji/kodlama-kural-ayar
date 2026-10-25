# Windows'ta Kodlama

> Kaynak: `linkler.md` 7–8. bölümlerden ayrıldı (2026-10-23); bağlantı listesi `01-ajan-arac-katalogu.md` dosyasındadır.

## 1. Kurulum Komutları

```powershell
winget install --id Google.AntigravityCLI
winget install --id Google.AntigravityIDE
winget install --id ZhipuAI.ZCode
winget install --id SST.OpenCodeDesktop
winget install --id SST.opencode

npm list -g --depth=0

npm install -g @deepseek-ai/dsh
npm i -g cline
npm i -g opencode-ai
irm https://antigravity.google/cli/install.ps1 | iex
```

## 2. Windows Sorun Giderme

**npm global binary'leri PATH'te yok** (`%APPDATA%\npm` eksik):

```powershell
$k=[Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\Environment",$true);$p=$k.GetValue("Path","",[Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames);if($p -notlike "*%APPDATA%\npm*"){$k.SetValue("Path","$p;%APPDATA%\npm",[Microsoft.Win32.RegistryValueKind]::ExpandString);Write-Host "Basariyla eklendi!" -ForegroundColor Green}else{Write-Host "Zaten ekli." -ForegroundColor Yellow};$k.Close()
```

**PowerShell script çalıştırma politikası engeli:**

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
```
