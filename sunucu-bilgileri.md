# Sunucu Bilgileri — Ortam Karşılaştırması ve PHP Eklenti Envanteri

> Kaynak: `sunucu.jpg` ve SSH oturum dökümü · v202610310311

İki farklı barındırma ortamının phpMyAdmin sistem bilgileri: sol sütun yerel/Windows, sağ sütun cPanel (CloudLinux).

## Sol Sütun — Yerel Windows Ortamı

**Veritabanı sunucusu**

| Özellik | Değer |
| --- | --- |
| Sunucu | localhost via TCP/IP |
| Sunucu türü | MariaDB |
| Sunucu bağlantısı | SSL kullanılmamakta |
| Sunucu sürümü | 10.11.13-MariaDB - mariadb.org binary distribution |
| Protokol sürümü | 10 |
| Kullanıcı | veritabani@localhost |
| Sunucu karakter grubu | cp1252 West European (latin1) |

**Web sunucusu**

| Özellik | Değer |
| --- | --- |
| Web sunucusu | Microsoft-IIS/10.0 |
| Veritabanı istemcisi sürümü | libmysql - mysqlnd 8.4.20 |
| PHP uzantıları | mysqli, curl, mbstring |
| PHP sürümü | 8.4.20 |

**phpMyAdmin:** Sürüm 5.2.3

## Sağ Sütun — cPanel Ortamı

**Veritabanı sunucusu**

| Özellik | Değer |
| --- | --- |
| Sunucu | Localhost via UNIX socket |
| Sunucu türü | MySQL |
| Sunucu bağlantısı | SSL kullanılmamakta |
| Sunucu sürümü | 8.0.45-cll-lve - MySQL Community Server - GPL |
| Protokol sürümü | 10 |
| Kullanıcı | <kullanici>@localhost |
| Sunucu karakter grubu | UTF-8 Unicode (utf8mb4) |

**Web sunucusu**

| Özellik | Değer |
| --- | --- |
| Web sunucusu | cpsrvd 11.136.0.13 |
| Veritabanı istemcisi sürümü | libmysql - mysqlnd 8.4.21 |
| PHP uzantıları | mysqli, curl, mbstring |
| PHP sürümü | 8.4.21 |

**phpMyAdmin:** Sürüm 5.2.2

## Özet Karşılaştırma

| Özellik | Sol (Yerel) | Sağ (cPanel) |
| --- | --- | --- |
| Veritabanı | MariaDB 10.11.13 | MySQL 8.0.45 (CloudLinux/cPanel) |
| Bağlantı | TCP/IP | UNIX socket |
| Web sunucusu | IIS 10.0 (Windows) | cpsrvd 11.136.0.13 (cPanel) |
| PHP | 8.4.20 | 8.4.21 |
| phpMyAdmin | 5.2.3 | 5.2.2 |
| Karakter seti | cp1252 (latin1) | utf8mb4 |

Not: Yerel ortamdaki `cp1252 (latin1)` karakter seti, Türkçe karakterli verilerin taşıma sırasında bozulmasına yol açabileceğinden canlıya (`utf8mb4`) aktarımda dikkat gerektirir (doğrulanmalı).

## PHP Eklenti Envanteri — cPanel / CloudLinux

> cPanel sunucusu: `<sunucu>` — `app.<alanadi>.com`, PHP 8.4.21.

Sorgu (CloudLinux `selectorctl`):

```bash
selectorctl --list-user-extensions --version=8.4 --all
```

İşaretler: `+` seçili/aktif, `-` seçili değil (devre dışı), `~` PHP çekirdeğine derlenmiş (kapatılamaz).

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
