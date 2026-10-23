# Kurumsal Web Sitesi Yapı Konvansiyonu

> Kaynak: `web-<alanadi>` ve `web-dijital.<alanadi>` ağaç taramaları (23 Ekim 2026, disk) + `web-dijital/docs/yapi.md` (12 Ekim 2026). Bu belge halka açık tanıtım sitelerinin yapı konvansiyonudur; oturumlu panel/uygulamalar için bkz. `php-uygulama-yapisi.md`. Her projenin kendi `docs/yapi.md`'si ağaç gerçeğinin otoritesidir.
>
> **Uyarı:** `web-<alanadi>/docs/YAPI.md` panel projesinden kopyalanmış eski bir metindir (`python_daq/`, `login.php`, `api/` anlatır; o ağaçta bunlar yoktur). O projenin ağaç otoritesi değildir — tazelenmesi gerekir (doğrulanmalı).

## 1. Kapsam ve panel'den farklar

Halka açık, SEO odaklı kurumsal tanıtım sitesi; yönetim paneli site içinde gömülü yaşayabilir (`merkez.php`). Güvenlik, girdi/çıktı ve dağıtım kuralları panel konvansiyonuyla ortaktır (`php-uygulama-yapisi.md` §6, §9, §10); farklar:

| Konu | Panel uygulaması | Web sitesi (bu belge) |
| --- | --- | --- |
| Giriş | `login.php` + tüm sayfalarda oturum | Site halka açık; panel tek geçit: `login.php`/`admin.php` 301 → `merkez.php` |
| API | `api/` modül dizini + `api.php` kapısı | Tek `api.php`, `action` çözümü; `/api/<action>` rewrite'ı |
| İçerik | `sayfa/<kod>.php` ince kabuklar | `sayfa-bolum/` (bölümler) veya `sayfa/` (tam HTML sayfalar) |
| SEO | Yok | `seo/` katmanı + `sitemap.xml` + `robots.txt` + `llms.txt` zorunlu |
| Font/ikon | CDN politikası | Aynı politika + yerel `webfonts/`; gömülü vendor (ör. `three.min.js`) |
| Veri katmanı | `destek/Veri/` DAO | `destek/depo/` Deposu sınıfları veya `veritabani/migrationlar/` |
| Oturum | Tüm sayfalar | Yalnız yönetim: `destek/oturum.php` tek kaynak |

## 2. İki gerçekleştirme tarzı

Her ikisi de bu konvansiyona uyar; seçim içerik hacmine ve SPA ihtiyacına göre yapılır.

- **A) Tek kabuk + bölümler** (`web-<alanadi>`): `index.php` (950 satır) kabuğu çizer, içerik `sayfa-bolum/` bölümleri kabuğa dahil olur (11 bölüm: anasayfa, hakkimizda, hizmet-katalog, hizmet_detay, blog-donemler, blog_detay, iletisim, üç yasal sayfa, hata).
- **B) Rota dağıtıcı + tam sayfa** (`web-dijital.<alanadi>`): `index.php` (93 satır) "yalnızca rota ve güvenlik dağıtıcısı; HTML kabuğu basmaz" — `$_GET['page']` + slug beyaz listesi doğrulanmış sayfa dosyasına çevrilir, dizin atlatma (LFI) olanaksızdır; her `sayfa/<ad>.php` kendi tam HTML belgesidir (15 sayfa). Yeni sayfa: `sayfa/<ad>.php` + veri katmanındaki slug haritası. Proje dokümanına göre istemci tarafı React SPA ile hibrittir (detay için `web-dijital/docs/yapi.md`).

## 3. Referans ağaç — web-<alanadi> (23 Ekim 2026 taraması)

```text
/
├── index.php (950)           → Web kabuğu: rota, belge başı, bölümlerin dahili
├── merkez.php (3680)         → Gömülü yönetim paneli: giriş kontrolü, talep/kart yönetimi,
│                               SEO sayfa kataloğu sabitleri (tek geçit; login/admin 301 buraya)
├── api.php (282)             → Halka açık API kapısı: IS_API sabiti, action çözümü,
│                               X-Robots-Tag: noindex, JSON Content-Type
├── config.php (331)          → .env, PDO, oturum, CSRF, günlük çekirdeği
├── .htaccess                 → HTTPS 301, panel 301'leri, sitemap/favicon rewrite,
│                               hizmet/<slug> ve blog/<slug> rewrite, /api/<action>, catch-all,
│                               hassas dosya kapıları (Require all denied blokları)
├── .cpanel.yml / .user.ini   → cPanel tanımı / yerel PHP ayarları
├── manifest.json / sw.js / offline.html → PWA üçlüsü (gezinme-yalın servis işçisi)
├── robots.txt / llms.txt     → Tarama kuralları + LLM özeti (bkz. §6 sapma 2)
│
├── sayfa-bolum/              → 11 içerik bölümü (anasayfa … yasal-*, hata.php)
├── seo/                      → seo-hesapla.php, seo-yazdir.php, seo_data.php,
│                               sitemap-generator.php (24 saat önbellek; kök sitemap.xml yazar)
├── destek/                   → blog-icerik.php, hizmet-detay_data.php, oturum.php
│                               (yönetici oturumu tek kaynağı; admin_id + 3600 sn hareketsizlik;
│                               log_dosya.php koşulsuz yükler)
├── js/                       → app.js (1112), three-arkaplan.js (273), three.min.js (gömülü vendor;
│                               WebGL arka plan — bkz. prompt/tasarim-giris-promptu.md)
├── data/                     → Statik görseller (.webp/.webm), broşür PDF, katalog/, favicon;
│                               data/.htaccess script'e kapalı
├── webfonts/                 → Yerel font dosyaları (6 adet; harici font CDN'i yok)
├── veritabani/               → migrationlar/ (şema göçleri dizini)
├── deploy/                   → deploy.php + log_dosya.php (panel konvansiyonuyla aynı)
├── docs/                     → .htaccess kapılı; anayasa/ (anayasa-mimari.md,
│                               anayasa-veri_tabani.md, anayasa-gorsel_dizayn.md, uyum-durumu.md),
│                               cpanel-github.sh, ortam_envanteri.*, YAPI.md (eski kopya — §6)
├── log/                      → Tarih adlı uygulama logları (sürüm dışı içerik)
└── md/ , test/               → Yerel plan ve test dosyaları
```

### web-dijital.<alanadi> farkları

- `admin.php` (6 satır): eski adresleri `/merkez.php`'ye taşıyan 301 saplaması; `admin/admin.php` dizinde durur (`docs/yapi.md`'de panel olarak anılır — güncel rolü doğrulanmalı).
- `sayfa/` (15 tam HTML sayfa: enerji-analiz, fatura-kontrol, gorev-akisi, medikal-vaka, santiye-yonetim, pvsentez, kurumsal-dosya …) — `sayfa-bolum/` yok; `.htaccess` `^sayfa(/|$)` isteğini 403'ler (include-only).
- `migrations/` (kökte): numaralı PHP göçleri `001_kullanicilar.php` … `007_eposta_kuyrugu.php` + `calistir.php` + `.htaccess`.
- `destek/` çok daha zengin: `.htaccess` (dizin yerel kapı), `depo/` DAO katmanı (`AyarDeposu`, `MedyaDeposu`, `SeoDeposu`, `TalepDeposu`, `yukle.php`), `lumen-*` tema/kabuk dosyaları (kabuk, tema, kapanis, ek, teklif, urun, yasal), `eposta-gonder.php` + `eposta-kuyrugu.php`, `veritabani.php`, `migrasyon.php`, `ustbar_data.php`.
- `deploy/sorgu-analiz.php` ek aracı; `uploads/` (`.htaccess` korulu, sürüm dışı); `php.ini`; `benioku.txt`; `docs/yapi.md` (gerçek site dokümanı, 12 Ekim 2026).

## 4. Temel akışlar

- **İstek**: `.htaccess` HTTPS'i zorlar; `hizmet/<slug>` ve `blog/<slug>` temiz adresleri `index.php?page=...&<param>=<slug>` iç rewrite'ına iner; `sitemap.xml` → `seo/sitemap-generator.php`; `favicon.ico` → statik dosya; gerçek dosya olmayan tek segment `index.php?page=$1` [QSA] ile karşılanır.
- **SEO üretimi**: `seo/` katmanı tek kaynaktır — `seo_data.php` veri, `seo-hesapla.php`/`seo-yazdir.php` hesap/çıktı, `sitemap-generator.php` 24 saatlik önbellekle `sitemap.xml` üretir; `robots.txt` sitemap referansı taşır.
- **Halka açık API**: `api.php` `IS_API` sabitiyle açılır, `action`'ı query/PATH_INFO/`/api/<action>` rewrite'ından çözer, `X-Robots-Tag: noindex` ile taramayı kapatır. Uç listesi projenin kendi `docs/yapi.md`'sinden doğrulanmalı (web-dijital: iletisim, sayfa, ayarlar, csrf).
- **Yönetim**: `merkez.php` tek geçit; oturum sözleşmesi `destek/oturum.php`'dedir (`admin_id` + 1 saat hareketsizlik düşüşü); `deploy/log_dosya.php` bu sözleşmeye koşulsuz bağlanır.
- **Form/e-posta** (web-dijital deseni): iletişim/talep formları CSRF'li `api.php` ucuna gider; gönderim `destek/eposta-gonder.php` + `eposta-kuyrugu.php` üzerinden kuyruklanır.
- **Dağıtım/PWA**: `deploy/deploy.php` + GitHub kancası + PWA üçlüsü panel konvansiyonuyla birebir aynı (`github-cpanel-rehberi.md`).

## 5. Değişmezler (siteye özgü olanlar)

Panel değişmezlerinin tamamı (`php-uygulama-yapisi.md` §9) geçerlidir; ek olarak:

1. **SEO katmanı tek kaynaktır**: meta/başlık/sitemap üretimi `seo/` dışına çoğaltılmaz; her yeni sayfa `seo_data.php`/slug haritasına kaydedilir.
2. **`robots.txt` ve `llms.txt` kökte zorunludur**; `robots.txt` kendi alan adının `sitemap.xml`'ini işaret eder.
3. **API yanıtları taranmaz**: `X-Robots-Tag: noindex` `api.php`'de merkezdır.
4. **İçerik dizinleri include-only'dir**: `sayfa/`/`sayfa-bolum/`, `seo/`, `destek/`, `docs/` doğrudan URL'den açılmaz; temiz adres rewrite'ları üzerinden servis edilir.
5. **Font yereldir**: `webfonts/` sürümde tutulur; harici font CDN'i açılmaz.
6. **Panel tek geçittir**: `login.php`/`admin.php`/`admin/` 301 ile `merkez.php`'de birleşir; ikinci bir giriş yüzeyi açılmaz.
7. **Şema değişikliği numaralı göçle**: `migrations/001_*.php` deseni (veya `veritabani/migrationlar/`); elle ALTER yok.
8. **Gömülü vendor sabittir**: `three.min.js` gibi minimize kütüphaneler dokunulmaz; sürüm notu YAPI belgesinde taşınır.

## 6. Bilinen sapmalar (kaynak ağaçlarda, 23 Ekim 2026)

1. `web-<alanadi>/docs/YAPI.md` panel projesinden kopya eski metin; ağaçla uyumsuz (bkz. künye uyarısı).
2. `web-<alanadi>/robots.txt` ve `llms.txt` `dijital.<alanadi>.com` alan adını işaret ediyor (kopya kökenli) — site kendi alan adını işaretlemeli (doğrulanmalı).
3. `web-<alanadi>/destek/` dizin yerelinde `.htaccess` yok (web-dijital'de var); koruma kök `.htaccess` bloklarına dayanıyor — dizin yerel kapağı eklenmeli (doğrulanmalı).
4. `web-dijital/docs/yapi.md` satır sayıları bayat (ör. `index.php` 350 → gerçekte 93; `config.php` 302 → 784).

## 7. Üst düzey girdi kapanış denetimi

İki ağacın anlamlı tüm üst düzey girdileri bu belgede açıklanmıştır; kapanış tablosu:

| Girdi | Kapsam | Bölüm |
| --- | --- | --- |
| `.cpanel.yml`, `.user.ini`, (`php.ini` dijital) | Barındırma/çalışma zamanı ayarları | §3 ağaç |
| `.htaccess` | Kapılar, rewrite, HTTPS | §3, §4 |
| `index.php`, `merkez.php`, `api.php`, `config.php` | Giriş noktaları | §2, §3, §4 |
| `sayfa-bolum/` (ana) / `sayfa/` (dijital) | İçerik katmanı | §2, §3 |
| `seo/`, `robots.txt`, `llms.txt`, `sitemap` üretimi | SEO katmanı | §4, §5 |
| `destek/` (+ `depo/`, `lumen-*`, `oturum.php`, e-posta) | Ortak katman/DAO | §3, §4 |
| `js/`, `webfonts/`, `data/` | İstemci ve statik varlıklar | §3, §5 |
| `veritabani/` (ana), `migrations/` (dijital) | Şema göçleri | §3, §5 |
| `deploy/` | Canlı güncelleme | §4 |
| `docs/` | Proje dokümantasyonu ve anayasalar | §3, §6 |
| `log/`, `md/`, `test/`, `uploads/` | Çalışma zamanı / yerel (sürüm dışı içerik) | §3 |
| `admin.php`, `admin/`, `benioku.txt` (dijital) | Panel geçidi ve ek dosyalar | §3 |
| `.git*`, `.ignore`, `AGENTS.md`, `CLAUDE.md`, `.codegraph/`, `.gitnexus/`, `.claude/`, `.taste-skill/`, `.workbuddy-ai/` (yalnız ana), `graft/` (yalnız ana) | Sürüm kuralları ve ajan indeksleri (konvansiyon dışı) | — |

## 8. Doğrulama

- **Yol varlık denetimi**: bu belgedeki ağaç girdileri 23 Ekim 2026'da diskle eşleştirildi (referans ağaç + delta yolları; sapma bulunursa §6'ya yazılır).
- **Kalan girdi denetimi**: iki ağacın `ls` çıktısı §7 tablosuyla karşılaştırılır; açıklanmayan girdi kalmaz.
- **Çelişki denetimi**: bu repodaki diğer belgelerle (`prompt/tasarim-giris-promptu.md`, `github-cpanel-rehberi.md`, `anayasa-*.md`) çakışma grep ile taranır.
