# Sunucu Ortamı Karşılaştırması — phpMyAdmin Sistem Bilgileri

> Kaynak: `sunucu.jpg` (ekran görüntüsü; iki phpMyAdmin açılış sayfasının sistem bilgi kutuları yan yana karşılaştırılmış)

İki farklı barındırma ortamının phpMyAdmin sistem bilgileri. Sol sütun yerel/Windows ortamını, sağ sütun cPanel (CloudLinux) ortamını temsil eder.

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

İlgili: cPanel/CloudLinux ortamında PHP 8.4 eklenti envanterinin tam dökümü (`selectorctl` çıktısı) için bkz. `github-cpanel-rehberi.md` → "Sunucu Ortamı Gerçekleri (<sunucu> — app.<alanadi>.com)" bölümü.
