# PHP Yapı Konvansiyonu — Uygulama ve Web Sitesi

> Kaynak: bu repodaki `php-uygulama-yapisi.md`, `web-sitesi-yapisi.md` ve `istemci-tarafi-belge-uretimi.md` belgelerinin tek dosyada birleşimi (2026-10-24). Yeni proje kurulumu ve denetimi için kopyala-yapıştır referansıdır; her projenin kendi `docs/YAPI.md` dosyası o ağacın tek otoritesidir.

İki proje tipi aynı çekirdeği paylaşır: oturumlu panel uygulaması ve halka açık SEO odaklı web sitesi. Ortak kurallar §1'de, her tipin iskeleti ve akışları §2–§3'te, farklar §4'te, belge üretimi §5'tedir.

## 1. Ortak çekirdek

### 1.1 Çalışma zamanı

- PHP 8.0+; `declare(strict_types=1)` birinci taraf iş mantığında zorunlu, sunum kabukları muaf.
- PDO + MySQL: hazırlanmış deyim, `ATTR_EMULATE_PREPARES => false`, istisna modu.
- `.env` yükleyici `KEY=VALUE` ayrıştırır, mevcut ortam değişkenlerini ezmez; `.env` sürüm dışı ve web'e kapalıdır.
- Composer: yeni bağımlılık tek cümleyle gerekçelendirilir; `vendor/` sürüm dışıdır, sunucuda `composer install` çalışır.
- Oturum sertleştirme: `use_strict_mode`, `use_only_cookies`, `HttpOnly`, `SameSite=Lax`, HTTPS'te `Secure`; çerez adı proje önekli.
- Loglar tek `log/` dizininde, kanal başına budama tavanıyla tutulur; web'den servis edilmez (tek istisna deploy log denetimidir).

### 1.2 Güvenlik ve veri

- CSRF: durum değiştiren her istekte zorunlu; `hash_equals` ile sabit zamanlı doğrulama; GET/HEAD/OPTIONS muaf; istemci `X-CSRF-Token` başlığı + gövde alanı taşır.
- Çıktı: JSON tek yardımcıdan üretilir (`Content-Type`, `nosniff`, `no-store`, `JSON_UNESCAPED_UNICODE`); HTML kaçışı sunucuda `htmlspecialchars(ENT_QUOTES)`, istemcide tek `htmlTemizle()` işleviyle yapılır.
- Hata: istemciye yalnız sade mesaj döner; sınıf/dosya/satır/iz loga gider. Loglarda parola, token ve PII `[MASKELI]` olarak maskelenir.
- Denetim kaydı fail-closed çalışır; yalnız adı geçen okuma eylemleri loglanmaz.
- Hız sınırı: sabit pencere + dosya kilidi; giriş ve parola sıfırlama yollarında ayrı limitler.
- Parola: bcrypt, cost ≥ 12.
- SQL yalnız DAO/veri katmanında yaşar; controller'da SQL metni ve `$pdo->` çağrısı bulunmaz. Liste uçlarında limit/offset zorunlu, transaction yalnız sarmalayıcı işlevle açılır.
- Yükleme: boyut + MIME + dosya imzası doğrulanır; istemci dosya adına güvenilmez; `uploads/` sürüm dışıdır ve script çalıştırma kapalıdır.
- `.htaccess`: HTTPS zorunlu; `api/`, `sayfa/`, `destek/`, `sidebar/`, `docs/`, `log/`, `vendor/` include-only (doğrudan HTTP isteği 403); `.env` kapılı.
- UI metinleri tam Türkçe imlâ ile yazılır (ğ, ü, ş, ı, ö, ç).

### 1.3 İstemci

- Tailwind CSS v4 standalone CLI ile derlenir; derlenmiş CSS depoda tutulur, çalışma zamanı CDN'i kullanılmaz (bkz. `anayasa/web-uygulama/gorsel-dizayn.md`).
- İkon politikası proje başına tek yoldur: Lucide inline SVG sprite; çalışma zamanı Iconify API'si ve ikon fontu eklenmez (bkz. `anayasa/web-uygulama/gorsel-dizayn.md`).
- Satır içi `style` yasaktır; istisna yalnız anayasal alanlardır (PDF/e-posta şablonları, giriş ekranı teması, `@page` kuralları).
- `js/app.js` `<head>` sonunda `defer` ile yüklenir; sözleşme `window.*` üzerinden açılır (`apiIstek`, `bildirimGoster`, `htmlTemizle`); yakalanmamış hata ve söz redleri tek bildirim kanalına bağlanır.
- `js/vendor/*` ve gömülü üçüncü parti kopyalar sabittir, dokunulmaz.
- Bu proje tipinin bağlayıcı anayasası `anayasa/web-uygulama/` setidir; çelişkide anayasa kazanır.

## 2. Uygulama (panel) iskeleti

Oturumlu, rol tabanlı, API'li iç uygulamalar (raporlama panelleri, yönetim sistemleri). Tek web kökü, cPanel/LiteSpeed barındırma.

### 2.1 Dizin iskeleti

```text
/
├── index.php             → Web kabuğu: ?page=X çözümleyici, belge başı/sonu
├── login.php             → Oturum açma + şifremi unuttum + sıfırlama
├── api.php               → API kapısı: modül çözümleme + oturum + CSRF + denetim kancası
├── config.php            → .env, PDO, oturum, CSRF, hız sınırı, günlük çekirdeği
├── .htaccess             → Kapılar, include-only dizinler, HTTPS, temiz adres
├── .env.example          → Sırsız örnek (.env sürüm dışı)
├── .user.ini / .cpanel.yml → cPanel PHP ayarları / Git dağıtım tanımı
├── composer.json         → Yalnız gerekçeli paketler
├── manifest.json / sw.js / offline.html → PWA üçlüsü
│
├── api/                  → <kod>_api.php; işleyici handle_<kod>_api($pdo, $input)
├── sayfa/                → <kod>.php ince sunum kabukları
├── destek/               → Include-only ortak katman: iş mantığı, Rapor/, E-Posta/, Veri/ (DAO), goc/
├── sidebar/              → Ortak sol menü kabuğu
├── js/                   → app.js + <kod>.js + vendor/ (sabit)
├── data/                 → Statik marka/PWA varlıkları + goc/ şema göçleri
├── log/                  → Çalışma zamanı logları (web'e kapalı)
├── deploy/               → deploy.php + log_dosya.php
├── docs/                 → YAPI.md ve anayasalar (web'e kapalı)
├── uploads/              → Kullanıcı yüklemeleri (sürüm dışı, script kapalı)
└── vendor/               → Composer kurulumu (sürüm dışı)
```

### 2.2 Modül çözümleme

Manuel izinli liste yoktur. `api.php` bir modülü üç koşulla geçerli sayar: `/^[a-z][a-z0-9_]*$/` desenine uymayan, `api/<modül>_api.php` dosyası bulunmayan veya `sayfa/<modül>.php` olmayıp headless da olmayan modül 400 döner.

- Headless modüller (sayfasız/oturumsuz; şifre sıfırlama, bildirim) `api.php` içindeki tek elemanlı listede açıkça listelenir.
- Modül adı = sayfa kodu; işleyici adı dosya adından türetilir (`handle_<kod>_api`). İkinci kayıt listesi tutulmaz.
- İstek zinciri: gövde çözümü → desen → dosya kuralı → CSRF → oturum + zaman aşımı + rol denetimi → denetim kaydı kalkanı içinde çağrı.

### 2.3 Tek manifest katalog

Sayfa, menü ve rol tanımları tek kaynakta durur (`destek/sayfa_katalogu.php`); `index.php`, `api.php` ve `sidebar.php` aynı kaynağı okur. Rol sıkılaştırma (`['*']` → `['yonetici']`) yalnız veri değişikliğidir. Roller üç yerde tekrarlanmaz; tekrar sapma sayılır ve YAPI.md'de listelenir.

### 2.4 Temel akışlar

- **Web isteği**: `.htaccess` kapıları → `index.php` yapılandırma + oturum + `?page=` temizliği (`basename()` + sonek kırpma) → katalog + dosya + yetki → belge başı + sidebar + `sayfa/<kod>.php` + `js/<kod>.js`.
- **Giriş**: CSRF + hız sınırı + `password_verify` + `session_regenerate_id(true)`.
- **Canlı güncelleme**: `deploy/deploy.php` yönetici oturumu + POST + CSRF ile çalışır; `?kanca=github` ucu HMAC-SHA256 doğrular; iki yol da `git merge --ff-only` kullanır; yüklemeler zaman damgalı arşivlenir; günlük `log/deploy.log`'a yazılır.
- **Log toplama**: tek `log/` dizini, kanal başına budama tavanı; `deploy/log_dosya.php` denetim istisnasıdır.

### 2.5 Adresleme (temiz URL)

Kök `.htaccess` dört kural yazar:

1. `^login/?$` → `login.php` (iç rewrite).
2. `THE_REQUEST` içinde `/login.php` görülürse 301 ile `/login`'e döner.
3. `THE_REQUEST` içinde `index.php?page=X` görülürse 301 ile `/X`'e döner (sorgu dizisi korunur).
4. Gerçek dosya/dizin değilse tek segment `^([a-z0-9_]+)/?$` → `index.php?page=$1` [QSA].

### 2.6 Yeni modül tarifi

1. `sayfa/<kod>.php` (ince kabuk) + `api/<kod>_api.php` (`handle_<kod>_api`) çiftini yaz.
2. Kataloğa kaydı ekle (`baslik`, `ikon`, `menu`, `roller`, gerekirse `kutuphaneler`).
3. `js/<kod>.js` yaz; `app.js` sözleşmesinden (`apiIstek`, `htmlTemizle`) ayrı fetch/kaçış üretme.
4. SQL'i DAO katmanına koy; controller'da sorgu bırakma.
5. Doğrula: `php -l`, hedefli grep (`jsonYanit`/`islemLoguYaz` kullanımı, controller'da SQL yok), katalog görünürlüğü, `git status --porcelain`.

### 2.7 docs/YAPI.md iskeleti

1. Proje Yapısı (açıklamalı ağaç)
2. Temel akışlar
3. Rol modeli
4. Girdi ve çıktı kuralları
5. Stil (+ PWA alt bölümü)
6. Çalışma zamanı ve kütüphaneler
7. Değişmezler
8. Adresleme
9. Doğrulama (+ ortam envanteri)

Her yeniden yapılandırma görevi ilgili bölümü güncellemekle yükümlüdür; ölü uçlar ve kasıtlı sapmalar açıkça listelenir.

## 3. Web sitesi iskeleti

Halka açık, SEO odaklı kurumsal tanıtım sitesi; yönetim paneli site içinde gömülü yaşayabilir. Güvenlik, çıktı ve çalışma zamanı kuralları §1 ile aynıdır.

### 3.1 İki gerçekleştirme tarzı

- **A) Tek kabuk + bölümler**: `index.php` kabuğu çizer, içerik `sayfa-bolum/` bölümlerinden dahil edilir (anasayfa, kurumsal, hizmetler, blog, iletişim, yasal sayfalar, hata).
- **B) Rota dağıtıcı + tam sayfa**: `index.php` yalnız rota ve güvenlik dağıtıcısıdır, HTML basmaz; `$_GET['page']` + slug beyaz listesi doğrulanmış dosyaya çözülür (LFI olanaksız); her `sayfa/<ad>.php` kendi tam HTML belgesidir. Yeni sayfa: dosya + veri katmanındaki slug haritası.

Seçim içerik hacmine ve SPA ihtiyacına göre yapılır; iki tarz da bu konvansiyona uyar.

### 3.2 Dizin iskeleti

```text
/
├── index.php             → Web kabuğu (A) veya rota/güvenlik dağıtıcısı (B)
├── merkez.php            → Gömülü yönetim paneli: giriş kontrolü, SEO sayfa kataloğu (tek geçit)
├── api.php               → Halka açık API kapısı: IS_API, action çözümü, X-Robots-Tag: noindex
├── config.php            → .env, PDO, oturum, CSRF, günlük çekirdeği
├── .htaccess             → HTTPS, panel 301'leri, SEO rewrite'ları, hassas dosya kapıları
├── manifest.json / sw.js / offline.html → PWA üçlüsü
├── robots.txt / llms.txt → Tarama kuralları + LLM özeti (kökte zorunlu)
│
├── sayfa-bolum/          → İçerik bölümleri (A tarzı); B tarzında yerine sayfa/ tam sayfaları
├── seo/                  → seo_data.php, seo-hesapla.php, seo-yazdir.php, sitemap-generator.php
├── destek/               → oturum.php (yönetici oturumu tek kaynağı), blog/hizmet verisi,
│                           e-posta gönderimi + kuyruğu, log geçidi
├── js/                   → app.js + etkileşim dosyaları + gömülü vendor (ör. three.min.js)
├── data/                 → Görseller, broşür/katalog, favicon (.htaccess ile script'e kapalı)
├── webfonts/             → Yerel fontlar (harici font CDN'i yok)
├── veritabani/           → migrationlar/ (numaralı şema göçleri)
├── deploy/               → deploy.php + log_dosya.php
├── docs/                 → Proje dokümanları ve anayasalar (web'e kapalı)
└── log/                  → Uygulama logları (sürüm dışı)
```

### 3.3 Temel akışlar

- **İstek**: `.htaccess` HTTPS'i zorlar; `hizmet/<slug>` ve `blog/<slug>` temiz adresleri `index.php?page=...&<param>=<slug>` iç rewrite'ına iner; `sitemap.xml` → `seo/sitemap-generator.php`; gerçek dosya olmayan tek segment `index.php?page=$1` [QSA] ile karşılanır.
- **SEO üretimi**: `seo/` tek kaynaktır; `seo_data.php` veri, `seo-hesapla.php`/`seo-yazdir.php` hesap/çıktı, `sitemap-generator.php` 24 saatlik önbellekle `sitemap.xml` üretir; `robots.txt` sitemap referansı taşır.
- **Halka açık API**: `api.php` `IS_API` sabitiyle açılır; `action` query/PATH_INFO/`/api/<action>` rewrite'ından çözülür; `X-Robots-Tag: noindex` ile taramaya kapanır.
- **Yönetim**: `merkez.php` tek geçit; oturum sözleşmesi `destek/oturum.php` içindedir (`admin_id` + 3600 sn hareketsizlik).
- **Form/e-posta**: iletişim/talep formları CSRF'li `api.php` ucuna gider; gönderim `destek/eposta-gonder.php` + `eposta-kuyrugu.php` üzerinden kuyruklanır.
- **Dağıtım/PWA**: `deploy/deploy.php` + GitHub kancası + PWA üçlüsü panel konvansiyonuyla birebir aynıdır.

### 3.4 Site değişmezleri

1. **SEO katmanı tek kaynaktır**: meta/başlık/sitemap üretimi `seo/` dışına çoğaltılmaz; her yeni sayfa slug haritasına kaydedilir.
2. **`robots.txt` ve `llms.txt` kökte zorunludur**; `robots.txt` kendi alan adının `sitemap.xml`'ini işaret eder.
3. **API yanıtları taranmaz**: `X-Robots-Tag: noindex` `api.php`'de merkezîdir.
4. **İçerik dizinleri include-only'dir**: `sayfa/`/`sayfa-bolum/`, `seo/`, `destek/`, `docs/` doğrudan URL'den açılmaz; temiz adres rewrite'ları üzerinden servis edilir.
5. **Font yereldir**: `webfonts/` sürümde tutulur; harici font CDN'i açılmaz.
6. **Panel tek geçittir**: `login.php`/`admin.php`/`admin/` 301 ile `merkez.php`'de birleşir; ikinci giriş yüzeyi açılmaz.
7. **Şema değişikliği numaralı göçle**: `migrations/001_*.php` (veya `veritabani/migrationlar/`) deseni; elle ALTER yok.
8. **Gömülü vendor sabittir**: `three.min.js` gibi minimize kütüphaneler dokunulmaz.

## 4. İki yapının farkları

| Konu | Uygulama (panel) | Web sitesi |
| --- | --- | --- |
| Giriş | `login.php` + tüm sayfalarda oturum | Site halka açık; panel tek geçit |
| API | `api/` modül dizini + `api.php` kapısı | Tek `api.php`, `action` çözümü |
| İçerik | `sayfa/<kod>.php` ince kabuklar | `sayfa-bolum/` bölümleri veya tam `sayfa/` |
| SEO | Yok | `seo/` + `sitemap.xml` + `robots.txt` + `llms.txt` zorunlu |
| Veri katmanı | `destek/Veri/` DAO | `destek/depo/` Deposu sınıfları veya `veritabani/migrationlar/` |
| Oturum | Tüm sayfalar | Yalnız yönetim (`destek/oturum.php` tek kaynak) |

## 5. İstemci tarafı belge üretimi (PDF/Excel)

Sunucu paketleri (mpdf, phpspreadsheet, phpword) yüksek bellek/CPU maliyeti nedeniyle terk edildi; üretim tarayıcıda yapılır: sıfır sunucu yükü, limitsiz ücretsiz çıktı, anlık render.

- **Tüm kütüphaneler yerel barındırılır; dış CDN bağımlılığı yoktur.**
- **PDF**: `pdfmake.min.js` — bildirimsel JSON şemasıyla vektörel PDF; `vfs_fonts.js` gömülü Roboto ile Türkçe karakterleri (ğ, ü, ş, ı, ö, ç) ve ₺ destekler.
- **Excel**: `exceljs.min.js` — stillendirilmiş çalışma kitabı üretir ve gelen .xlsx dosyasını tarayıcıda parse eder.
- **Word**: çıktı üretilmez.

Mimari iki aşamalıdır:

1. **Tembel yükleme (`app.js`)**: ağır kütüphaneler sayfa yüklenirken çağrılmaz; "PDF İndir"/"Excel'e Aktar" tıklanınca `Belgeler` nesnesi üzerinden dinamik yüklenir (`belgekatmaniYukle`).
2. **Merkezi motor (`belge.js`)**: kurucular saf fonksiyondur (DOM/ağ bağımlılığı yok; yalnız veri + Base64 logolar → şablon yapısı); `BelgeUretici` motoru yükler, logoları Base64'e çevirir; PDF'i yeni sekmede önizler (popup engellenirse indirir), Excel'i Blob URL ile .xlsx olarak indirir.

## 6. Doğrulama

- Yeni/değişen dosyalarda `php -l`; hedefli grep (`jsonYanit`, `islemLoguYaz`, controller'da SQL yok); katalog görünürlüğü; `git status --porcelain` beklenen küme.
- Şema değişikliği yalnız numaralı göç dosyalarıyla (`goc/0001_*.php`, `migrations/001_*.php`).
- Belge ile proje ağacı çelişirse ağaç kazanır; `docs/YAPI.md` güncellenir.
