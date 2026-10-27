# GitHub + cPanel Kurulum ve Deploy Rehberi

## 1) İlk Yükleme

Manuel adımlar:

```bash
# 1. Git deposunu başlatın
git init

# 2. GitHub adresinizi origin olarak tanımlayın
git remote add origin https://github.com/<kullanici>/repoadi.git

# 3. Tüm dosyaları Git takibine ekleyin ve kimliği tanımlayın
git add .
git config --global user.name 'spgroupenerji'
git config --global user.email 'spgroup.enerji@gmail.com'

# 4. Dosyaları ilk kayıt (commit) olarak paketleyin
git commit -m 'cPanel'

# 5. Dal adını GitHub standartı olan main yapın
#    (veya master tercih ediyorsanız: git branch -M master)
git branch -M main

# 6. Dosyaları boş repoya gönderin
git remote set-url origin 'https://<kullanici>:<TOKEN>@github.com/<kullanici>/repoadi.git'
git push -u origin main
```

### Tek komut (tokenli linki yapıştır)

```powershell
$u = Read-Host "Tokenli GitHub Linkini Yapistirin"; git init; git config --global user.name "spgroupenerji"; git config --global user.email "spgroup.enerji@gmail.com"; git add .; git commit -m "cPanel"; git branch -M main; git remote remove origin 2>$null; git remote add origin $u.Trim("'"" "); git push -u origin main
```

### Linux / macOS / cPanel — tek satır (bash veya zsh)

Token gizli okunur, **remote adresine yazılmaz**; yukarıdaki token'lı `remote set-url` yaklaşımının güvenli sürümü (bloğun tamamını tek satır hâlinde yapıştırın):

```bash
git_github_yukle(){ local u; printf 'Tokenli GitHub linkini yapıştırın: '; read -r -s u; echo; u="${u//[[:space:]]/}"; u="${u#\"}"; u="${u%\"}"; u="${u#\'}"; u="${u%\'}"; case "$u" in https://*@github.com/*) ;; *) echo "HATA: Link https://KULLANICI:TOKEN@github.com/HESAP/DEPO.git biçiminde olmalı." >&2; return 1;; esac; local rest userinfo hostpath k t yol; rest="${u#https://}"; userinfo="${rest%%@*}"; hostpath="${rest#*@}"; k="${userinfo%%:*}"; t="${userinfo#*:}"; yol="${hostpath#github.com/}"; git init -q || { echo "HATA: git deposu başlatılamadı." >&2; return 1; }; git config --global user.name "spgroupenerji"; git config --global user.email "spgroup.enerji@gmail.com"; git add -A; if git diff --cached --quiet; then git rev-parse --verify -q HEAD >/dev/null || { echo "HATA: eklenecek dosya yok." >&2; return 1; }; else git commit -m "cPanel" || { echo "HATA: commit başarısız." >&2; return 1; }; fi; git branch -M main; git remote remove origin 2>/dev/null || true; git config --get credential.helper >/dev/null 2>&1 || git config --global credential.helper store; printf 'protocol=https\nhost=github.com\nusername=%s\npassword=%s\n\n' "$k" "$t" | git credential approve; [ -f "$HOME/.git-credentials" ] && chmod 600 "$HOME/.git-credentials" 2>/dev/null; git remote add origin "https://github.com/$yol" || { echo "HATA: origin tanımlanamadı." >&2; return 1; }; git push -u origin main || { echo "HATA: push başarısız — token izni (Contents: Read and write), depo yolu veya uzak depodaki mevcut geçmiş (non-fast-forward) denetlenmeli." >&2; return 1; }; printf 'TAMAM: origin https://github.com/%s — token yalnızca kimlik deposunda.\n' "$yol"; }; git_github_yukle
```

**Ne yapar:** Linki gizli okur → kullanıcı/token/depo yolunu ayırır → kimlik deposuna yazar → `origin` adresini tokensiz kurar → ilk commit'i atar (değişiklik yoksa atlar) → `main` dalına push eder.

- Mevcut bir depoda çalıştırırsanız `origin` adresi yapıştırdığınız depoyla değiştirilir; önce `git remote -v` ile doğrulayın.
- Push başarısızsa token iznini (**fine-grained: Contents: Read and write**) ve depo yolunu denetleyin.
- Doğrulama: `git remote -v` çıktısında token görünmemeli; `git status -sb` → `## main...origin/main`.

| Ortam | Fark |
| --- | --- |
| Linux | Komut olduğu gibi çalışır; token `~/.git-credentials` içine 0600 izinle yazılır (masaüstünde `libsecret` varsa oraya). |
| macOS ("Meko OS" macOS olarak yorumlandı — doğrulanmalı) | Önce bir kez `git config --global credential.helper osxkeychain` çalıştırın (token düz metne düşmez); sonra tek satırı yapıştırın. Git yoksa `xcode-select --install`. `/bin/bash` 3.2 ve varsayılan `zsh` ile uyumludur. |
| cPanel | `cPanel » Home » Advanced » Terminal` veya SSH ile **cPanel kullanıcınızla** (root değil) bağlanın; proje köküne girin: `cd "$HOME/app.alanadi.com"`; sonra aynı tek satırı yapıştırın. Arayüzdeki *Git Version Control* clone alanı `kullanıcı:token` kabul etmez; private repo için SSH deploy key kullanın. |

### Alternatif — kısa bash tek satırı

Token'ı doğrudan `origin` adresine gömer; `git remote -v` çıktısında ve shell geçmişinde görünür. Paylaşılan sunucuda üstteki güvenli sürüm kullanılmalıdır. Blok **bash** içindir; zsh'de `read -p` istem yerine coprocess okumasıdır, bu yüzden zsh'de üstteki güvenli sürümü veya `bash -c` ile çalıştırmayı kullanın.

```bash
read -p "Tokenli GitHub Linkini Yapistirin: " u && u=$(echo "$u" | sed -e "s/^[[:space:]'\"]*//" -e "s/[[:space:]'\"]*$//") && git init && git config --global user.name "spgroupenerji" && git config --global user.email "spgroup.enerji@gmail.com" && git add . && git commit -m "cPanel" && git branch -M main && git remote remove origin 2>/dev/null; git remote add origin "$u" && git push -u origin main
```

**Ne yapar:** Linki okur, baştaki/sondaki boşluk ve tırnakları temizler, depoyu başlatıp ilk commit'i atar ve `main` dalına push eder.

cPanel güvenlik notları:

- Depo `public_html` içindeyse `.git` dizinini kapatın — `public_html/.htaccess` içine: `RedirectMatch 404 ^/\.git(/|$)`
- Sunucuda kalıcı **write** token'ı yerine okuma için SSH deploy key veya yalnızca `Contents: Read` kapsamlı fine-grained token kullanın.
- Cron ile otomatik `pull` için 5. bölümdeki `HOME`/`PATH` sarmalayıcısını kullanın.

## 2) Değişiklikten Sonra — Tek Komut: Commit + Push

```powershell
git add -A; git commit -m "guncelleme: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"; git push origin main
```

Tarih damgalı mesaj otomatiktir; kendi mesajınız için `-m "..."` kısmını değiştirin. Farklı dal kullanıyorsanız `main` yerine dal adını yazın. Değişiklik yoksa commit hata verir, komut yine de push'a devam eder (zararsız).

### Linux / macOS / cPanel — tek satır

```bash
git add -A; git diff --cached --quiet || git commit -m "guncelleme: $(date '+%Y-%m-%d %H:%M')"; git push origin main
```

Değişiklik yoksa `git diff --cached --quiet` başarılı döner ve commit atlanır (hata çıkmaz); `;` sayesinde push yine çalışır. macOS'un BSD `date`'i ve Linux/cPanel'in GNU `date`'i bu biçimi destekler. cPanel'de proje kökünde ve cPanel kullanıcısıyla; cron'da 5. bölümdeki sarmalayıcıyla çalıştırın. Push reddedilirse (non-fast-forward) önce 3. bölümdeki `pull` ile uzak değişiklikleri alın.

## 3) Güncel Sürümü Çekme — Tek Komut: Pull

```powershell
git pull --ff-only origin main
```

Yerel değişiklik varsa önce 2. bölümdeki commit+push'u çalıştırın; dallar ayrışmışsa `git pull --rebase origin main` kullanın.

### Linux / macOS / cPanel — tek satır

```bash
git pull --ff-only origin main
```

cPanel'de `fatal: detected dubious ownership` alırsanız dosyalar başka bir kullanıcıya aittir; dizin gerçekten size aitse: `git config --global --add safe.directory "$PWD"`. Farklı dal kullanıyorsanız `main` yerine dal adını yazın. Yerel değişiklik ve ayrışma durumları için yukarıdaki nota bakın.

## 4) GitHub Şifre İstediğinde (Personal Access Token)

`git push` komutunu girdiğinizde sizden Username ve Password isteyecektir.

Nasıl alınır? GitHub'da:
**Settings > en altta Developer Settings > Personal access tokens (tokens classic) > Generate new token** > `repo` kutucuğunu işaretleyip token'ı kopyalayın ve terminalde şifre alanına yapıştırın.

İzinlerden **Contents: read & write** ile aktif edin.

Alternatif (önerilen): **fine-grained token** → yalnızca ilgili depo + **Contents: Read and write**; sunucuda yalnızca okuma gerekiyorsa **Contents: Read**.

### Linux / macOS / cPanel'de token saklama

- Token'ı `git remote` adresine yazmayın; 1. bölümdeki komut URL'yi temiz tutar.
- macOS: `git config --global credential.helper osxkeychain` → token şifreli Anahtar Zinciri'nde tutulur.
- Linux/cPanel: `store` yardımcısı token'ı `~/.git-credentials` içine **düz metin** yazar (0600). Sunucuda kalıcı write token'ı yerine SSH deploy key veya salt-okuma token'ı kullanın.
- Sertleştirme (Git 2.37+): `git config --global transfer.credentialsInUrl warn` → URL'de kimlik bilgisi görülürse uyarır; kesin engellemek için `die` (önce token'lı origin'leri temizleyin).
- Token sızarsa GitHub → Settings → Developer settings → ilgili token'ı iptal edip yenisini üretin.

Mevcut token'lı origin'i temizlemek için (önce geçerli bir kimlik deposu olduğundan emin olun):

```bash
git remote set-url origin "$(git remote get-url origin | sed -E 's#(https://)[^@]*@#\1#')"
```

Kaynak: [git-scm — gitfaq (Credentials)](https://git-scm.com/docs/gitfaq), [cPanel — Git Version Control](https://docs.cpanel.net/cpanel/files/git-version-control/), [cPanel — Private Repositories](https://docs.cpanel.net/knowledge-base/web-services/guide-to-git-set-up-access-to-private-repositories/).

## 5) Deploy Webhook Kurulumu

1. **Webhook kodunu canlıya bir kez indirin** (kod canlıda olmadan GitHub onu çağıramaz): oturum açıp `deploy.php` → **Canlıyı Güncelle** ya da terminalde:

   ```bash
   git fetch origin && git merge --ff-only origin/master
   ```

2. **Sırrı sunucuya koyun:**

   ```bash
   openssl rand -hex 32   # üretin, çıktıyı kopyalayın
   ```

   `.env` dosyasına ekleyin: `DEPLOY_WEBHOOK_SECRET=<kopyaladığınız değer>` — doğrulaması: `php deploy.php durum` → **Kanca: açık (sır tanımlı)** yazmalı.

3. **GitHub → repo → Settings → Webhooks → Add webhook:**

   | Alan | Değer |
   | --- | --- |
   | Payload URL | `https://<alanadi>.com.tr/deploy/deploy.php?kanca=github` |
   | Payload URL (2) | `https://<alanadi>.com/deploy/deploy.php?kanca=github` |
   | Content type | `application/json` |
   | Secret | 2. adımdaki değer |
   | SSL verification | Enable |
   | Events | yalnız push |

   Kaydedince GitHub ping atar; **Recent Deliveries** içinde `200` / `pong` görmelisiniz.

4. **cPanel en son ayar:**

   ```bash
   git fetch origin && git merge --ff-only origin/main
   ```

Cron Kurma
   ```bash
   /bin/bash -c 'export HOME=/home/kullanici; export PATH=/usr/local/cpanel/3rdparty/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH; D=/home/kullanici/app.<alanadi>.com; L=/home/kullanici/deploy.log; rm -f $D/deploy-tani.txt; cd $D || { echo "$(date) CD BASARISIZ" >> $L; exit 1; }; o=$(git rev-parse HEAD); e=$(git pull --ff-only origin main 2>&1); c=$?; n=$(git rev-parse HEAD); if [ $c -ne 0 ]; then echo "$(date) HATA: $e" >> $L; elif [ "$o" != "$n" ]; then echo "$(date) GUNCELLENDI ${o:0:7} -> ${n:0:7}" >> $L; fi'
   ```

   Komutun yaptığı iş: `HOME` ve `PATH` değişkenlerini cPanel ortamına göre kurar → tanı dosyası `deploy-tani.txt`'yi siler → proje dizinine geçer (başarısızsa `CD BASARISIZ` yazar ve çıkar) → `git pull --ff-only origin main` çeker; hata olursa `HATA: <çıktı>`, commit değişmişse `GUNCELLENDI <eski> -> <yeni>` (7 karakterlik kısa hash'ler) yazar, değişiklik yoksa sessiz kalır.



## 6) Sunucu Ortamı Gerçekleri (<sunucu> — app.<alanadi>.com)

> Kaynak: SSH oturum dökümü (2026-10-23). PHP sürümü: 8.4.

**PHP eklenti envanteri** (CloudLinux `selectorctl` ile sorgulandı):

```bash
selectorctl --list-user-extensions --version=8.4 --all
```

Çıktıdaki işaretler: `+` seçili/aktif eklenti, `-` seçili olmayan/devre dışı eklenti, `~` PHP çekirdeğine doğrudan derlenmiş (kapatılamaz) dahili eklenti.

```text
- amqp
- apcu
+ bcmath
- bitset
- brotli
~ bz2
~ calendar
~ core
~ ctype
~ curl
~ date
- dba
- dbase
- diseval
+ dom
- eio
- enchant
~ exif
- ffi
+ fileinfo
~ filter
~ ftp
+ gd
- gearman
- gender
- geoip
- geos
~ gettext
- gmagick
- gmp
- gnupg
- grpc
~ hash
- htscanner
- http
~ iconv
+ igbinary
- imagick
- imap
- inotify
- intl
+ ioncube_loader
- jsmin
~ json
- ldap
- leveldb
~ libxml
- luasandbox
- lzf
- mailparse
+ mbstring
- mcrypt
- memcache
- memcached
- mongodb
+ msgpack
- mysqli
+ mysqlnd
+ nd_mysqli
- nd_pdo_mysql
- newrelic
- oauth
- oci8
- odbc
+ opcache
~ openssl
~ pcntl
~ pcre
- pdf
+ pdo
- pdo_dblib
- pdo_firebird
+ pdo_mysql
- pdo_oci
- pdo_odbc
- pdo_pgsql
- pdo_sqlite
- pdo_sqlsrv
- pgsql
- phalcon5
+ phar
- phpiredis
+ posix
- protobuf
- pspell
- psr
~ random
- raphf
- rar
~ readline
+ redis
~ reflection
- rrd
- scoutapm
~ session
~ shmop
~ simplexml
- snmp
- snuffleupagus
- soap
- sockets
- sodium
- solr
- sourceguardian
~ spl
~ sqlite3
- sqlsrv
- ssh2
~ standard
- stats
- swoole
- sysvmsg
- sysvsem
- sysvshm
- tideways_xhprof
- tidy
- timezonedb
~ tokenizer
- trader
- uploadprogress
- uuid
- vips
- vld
- xdebug
- xdiff
~ xml
+ xmlreader
- xmlrpc
+ xmlwriter
+ xsl
- yaf
- yaml
- yaz
+ zip
~ zlib
- zmq
```

Aktif (`+`) eklentiler: `bcmath`, `dom`, `fileinfo`, `gd`, `igbinary`, `ioncube_loader`, `mbstring`, `msgpack`, `mysqlnd`, `nd_mysqli`, `opcache`, `pdo`, `pdo_mysql`, `phar`, `posix`, `redis`, `xmlreader`, `xmlwriter`, `xsl`, `zip`. Dikkat çekici nokta: klasik `mysqli` devre dışıyken onun yerel sürücüsü `mysqlnd` ve CloudLinux `nd_mysqli` varyantı aktiftir.
