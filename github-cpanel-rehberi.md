# GitHub + cPanel Komut Şablonları

```bash
git init -b main
git add -A
git commit -m 'ilk commit'
git remote add origin "https://spgroupenerji:$t@github.com/spgroupenerji/$depo.git"
git push -u origin main
```

## 2) Tek satır — sıfırdan kurulum

Windows PowerShell:

```powershell
$g=(Read-Host 'Token veya link').Trim().Trim("'"" "); if ($g -like 'http*') { $u=$g } else { $u="https://spgroupenerji:$g@github.com/spgroupenerji/$depo.git" }; $m=Read-Host 'Commit mesajı'; if (-not $m) { $m='ilk commit' }; if (-not (Test-Path .git)) { git init -b main }; git add -A; git diff --cached --quiet; if ($LASTEXITCODE -ne 0) { git commit -m $m }; git remote remove origin 2>$null; git remote add origin $u; git push -u origin main; Remove-Variable g,u
```

macOS/Linux/cPanel:

```bash
printf 'Token veya link: '; read -r g; g=$(printf '%s' "$g" | sed -e "s/^[[:space:]'\"]*//" -e "s/[[:space:]'\"]*$//"); case "$g" in http*) u=$g;; *) u="https://spgroupenerji:$g@github.com/spgroupenerji/$depo.git";; esac; printf 'Commit mesajı: '; read -r m; [ -z "$m" ] && m='ilk commit'; [ -d .git ] || git init -b main; git add -A; git diff --cached --quiet || git commit -m "$m"; git remote remove origin 2>/dev/null; git remote add origin "$u"; git push -u origin main
```

## 3) Tek satır — push

Windows PowerShell:

```powershell
git add -A; git diff --cached --quiet; if ($LASTEXITCODE -ne 0) { $m=Read-Host 'Commit mesajı'; if (-not $m) { $m='guncelleme' }; git commit -m $m }; git push origin main
```

macOS/Linux/cPanel:

```bash
git add -A; if ! git diff --cached --quiet; then printf 'Commit mesajı: '; read -r m; git commit -m "${m:-guncelleme}"; fi; git push origin main
```

## 4) Tek satır — pull

Windows PowerShell / macOS / Linux / cPanel:

```bash
git pull --ff-only origin main
```

Fark yok. cPanel'de `dubious ownership` hatası: `git config --global --add safe.directory "$PWD"`.

## 5) Webhook (cPanel)

```bash
openssl rand -hex 32
```

`.env` → `DEPLOY_WEBHOOK_SECRET=<sır>` · doğrula: `php deploy.php durum`

GitHub → Settings → Webhooks → Add webhook:

`Payload URL: https://<alanadi>.com.tr/deploy/deploy.php?kanca=github`

`Content type: application/json` · Events: push · SSL: Enable · Secret: sır


## 6) Cron (cPanel, opsiyonel)

```bash
export HOME="/home/<kullanici>"; export PATH=/usr/local/cpanel/3rdparty/bin:/usr/local/bin:/usr/bin:/bin; D="$HOME/app.<alanadi>.com"; L="$HOME/deploy.log"; cd "$D" || { echo "$(date '+%F %T') CD BASARISIZ" >> "$L"; exit 1; }; O=$(git rev-parse HEAD); E=$(git pull --ff-only origin main 2>&1); C=$?; N=$(git rev-parse HEAD); if [ $C -ne 0 ]; then echo "$(date '+%F %T') HATA: $E" >> "$L"; elif [ "$O" != "$N" ]; then echo "$(date '+%F %T') GUNCELLENDI ${O:0:7} -> ${N:0:7}" >> "$L"; fi
```