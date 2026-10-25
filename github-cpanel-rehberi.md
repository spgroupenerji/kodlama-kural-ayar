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

## 2) Değişiklikten Sonra — Tek Komut: Commit + Push

```powershell
git add -A; git commit -m "guncelleme: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"; git push origin main
```

Tarih damgalı mesaj otomatiktir; kendi mesajınız için `-m "..."` kısmını değiştirin. Farklı dal kullanıyorsanız `main` yerine dal adını yazın. Değişiklik yoksa commit hata verir, komut yine de push'a devam eder (zararsız).

## 3) Güncel Sürümü Çekme — Tek Komut: Pull

```powershell
git pull --ff-only origin main
```

Yerel değişiklik varsa önce 2. bölümdeki commit+push'u çalıştırın; dallar ayrışmışsa `git pull --rebase origin main` kullanın.

## 4) GitHub Şifre İstediğinde (Personal Access Token)

`git push` komutunu girdiğinizde sizden Username ve Password isteyecektir.

Nasıl alınır? GitHub'da:
**Settings > en altta Developer Settings > Personal access tokens (tokens classic) > Generate new token** > `repo` kutucuğunu işaretleyip token'ı kopyalayın ve terminalde şifre alanına yapıştırın.

İzinlerden **Contents: read & write** ile aktif edin.

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
