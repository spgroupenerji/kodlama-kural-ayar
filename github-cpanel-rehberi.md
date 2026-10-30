# GitHub + cPanel Komut Şablonları

Her blok olduğu gibi yapıştırılır; değerler çalışırken sorulur.

## 1) Sıfırdan kurulum

GitHub'da boş depo açılmış olmalı. Windows PowerShell (cmd.exe değil):

```powershell
$u=(Read-Host 'Tokenli link').Trim("'"" "); if(-not(Test-Path .git)){git init -q}; git add -A; git diff --cached --quiet; if($LASTEXITCODE -ne 0){git -c user.name=spgroupenerji -c user.email=spgroup.enerji@gmail.com commit -m 'ilk commit'}; git branch -M main; git remote remove origin 2>&1 | Out-Null; git remote add origin $u; git push -u origin main
```

macOS/Linux/cPanel:

```bash
printf 'Tokenli link: '; read -r u; u=$(printf '%s' "$u" | tr -d " '\""); [ -d .git ] || git init -q; git add -A; git diff --cached --quiet || git -c user.name=spgroupenerji -c user.email=spgroup.enerji@gmail.com commit -m 'ilk commit'; git branch -M main; git remote remove origin 2>/dev/null; git remote add origin "$u"; git push -u origin main
```

## 2) Push

Windows PowerShell:

```powershell
git add -A; git diff --cached --quiet; if($LASTEXITCODE -ne 0){$m=Read-Host 'Mesaj'; if(-not $m){$m='guncelleme'}; git -c user.name=spgroupenerji -c user.email=spgroup.enerji@gmail.com commit -m $m}; git push origin main
```

macOS/Linux/cPanel:

```bash
git add -A; git diff --cached --quiet || { printf 'Mesaj: '; read -r m; git -c user.name=spgroupenerji -c user.email=spgroup.enerji@gmail.com commit -m "${m:-guncelleme}"; }; git push origin main
```

## 3) Pull

```bash
git pull --ff-only origin main
```

cPanel'de `dubious ownership` hatası alırsan:

```bash
git config --global --add safe.directory "$PWD"
```

## 4) Webhook (cPanel)

`deploy.php`'nin yanında çalıştır; sırrı `.env`'e yazar ve yazdırır (`.env` `.gitignore`'da olmalı):

```bash
grep -q '^DEPLOY_WEBHOOK_SECRET=' .env 2>/dev/null && sed -i "s|^DEPLOY_WEBHOOK_SECRET=.*|DEPLOY_WEBHOOK_SECRET=$(php -r 'echo bin2hex(random_bytes(32));')|" .env || printf '\nDEPLOY_WEBHOOK_SECRET=%s\n' "$(php -r 'echo bin2hex(random_bytes(32));')" >> .env; sed -n 's/^DEPLOY_WEBHOOK_SECRET=//p' .env | tail -1; php deploy.php durum
```

Payload URL için alan adını yaz:

```bash
printf 'Alan adı: '; read -r a; a=$(printf '%s' "$a" | tr -d " '\""); a=${a#http://}; a=${a#https://}; a=${a%%/*}; printf 'https://%s/deploy/deploy.php?kanca=github\n' "$a"
```

GitHub → depo → Settings → Webhooks → Add webhook: Payload URL = ikinci komutun çıktısı · Content type `application/json` · Secret = birinci komutun çıktısı · SSL: Enable · Events: push.

## 5) Cron (cPanel, opsiyonel)

Proje kökünde çalıştır; çıktıyı Cron Jobs → Add Cron Job → Command alanına yapıştır, aralığı seç:

```bash
sed "s|@D@|$PWD|g; s|@L@|$HOME/deploy.log|g" <<'EOS'
command -v git >/dev/null || export PATH="/usr/local/cpanel/3rdparty/bin:$PATH"; cd @D@ || { echo "$(date) CD BASARISIZ" >> @L@; exit 1; }; O=$(git rev-parse --short HEAD); E=$(git pull -q --ff-only origin main 2>&1); C=$?; N=$(git rev-parse --short HEAD); if [ $C -ne 0 ]; then echo "$(date) HATA: $E" >> @L@; elif [ "$O" != "$N" ]; then echo "$(date) GUNCELLENDI $O -> $N" >> @L@; fi
EOS
```
