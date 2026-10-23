# PHP Uygulama (Panel) Yapı Konvansiyonu

> Kaynak: `<proje>/docs/YAPI.md` (18 Ekim 2026) ve `<proje>/docs/ornek-yapi.md` (2 Ekim 2026) yaşayan yapı otoritelerinden damıtıldı; 23 Ekim 2026 disk taramasıyla doğrulandı. Bu belge **üst konvansiyondur**: her projenin kendi `docs/YAPI.md`'si o projenin ağaç gerçeğinin tek otorisidir; buradaki kurallar yeni projelere iskelet, mevcut projelere denetim listesi sağlar. Halka açık tanıtım siteleri için bkz. `web-sitesi-yapisi.md`.

## 1. Kapsam

Oturumlu, rol tabanlı, API'li iç uygulamalar (raporlama panelleri, yönetim sistemleri). Tek web kökü, cPanel/LiteSpeed barındırma, Composer minimal bağımlılık. Çatışma durumunda sıra: proje anayasaları (`anayasa-mimari.md`, `anayasa-veri_tabani.md`) → bu belge → proje `docs/YAPI.md` ağaç gerçeği.

## 2. Dizin iskeleti

```text
/
├── index.php                 → Web kabuğu: ?page=X çözümleyici, belge başı (CDN, CSRF taşıyıcısı), belge sonu
├── login.php                 → Oturum açma + şifremi unuttum + sıfırlama karşılama
├── api.php                   → API kapısı: modül çözümleme + oturum + CSRF + denetim kaydı kancası
├── config.php                → .env yükleyici, PDO, oturum, CSRF, hız sınırı, günlük çekirdeği
├── .htaccess                 → Hassas dosya kapıları, include-only dizin kapıları, HTTPS, temiz adres
├── .env / .env.example       → Gerçek sırlar (sürüm dışı) / sırsız örnek
├── .user.ini                 → cPanel yerel PHP ayarları
├── .cpanel.yml               → cPanel Git dağıtım tanımı (gövdesiz; dağıtım deploy/ ile yönetilir)
├── composer.json             → Yalnız gerekçeli paketler (ör. mpdf, phpmailer)
├── manifest.json / sw.js / offline.html → PWA üçlüsü
│
├── api/                      → <sayfa_kodu>_api.php; işleyici handle_<sayfa_kodu>_api($pdo, $input)
├── sayfa/                    → <sayfa_kodu>.php ince sunum kabukları
├── destek/                   → Include-only ortak katman: iş mantığı, Rapor/, E-Posta/, Veri/ (DAO), goc/
├── sidebar/                  → Ortak sol menü kabuğu
├── js/                       → app.js (fetch/CSRF/bildirim sözleşmesi) + <sayfa>.js + vendor/ (SHA256 sabit)
├── data/                     → Statik marka/PWA varlıkları + goc/ şema göçleri (sürümde)
├── log/                      → Çalışma zamanı logları (içerik sürüm dışı; web'e kapalı)
├── deploy/                   → deploy.php (canlı güncelleme) + log_dosya.php (log geçidi)
├── docs/                     → YAPI.md, anayasalar, kurulum betikleri (web'e kapalı)
├── uploads/                  → Kullanıcı yüklemeleri (sürüm dışı; script çalıştırma kapalı)
└── vendor/                   → Composer kurulumu (sürüm dışı)
```

## 3. Modül çözümleme (tek müşteri prensibi)

Manuel izinli liste **yoktur**. `api.php` bir modülü üç koşulla geçerli sayar:

| Koşul | Sonuç |
| --- | --- |
| `/^[a-z][a-z0-9_]*$/` desenine uymaz | Geçersiz modül (400) |
| `api/<modül>_api.php` dosyası yok | Geçersiz modül (400) |
| `sayfa/<modül>.php` yok **ve** headless değil | Geçersiz modül (400) |

- Headless modüller (sayfasız/oturumsuz, ör. şifre sıfırlama, bildirim) `api.php` içindeki tek elemanlı listede açıkça listelenir.
- Modül adı = sayfa kodu; işleyici fonksiyon adı dosya adından türetilir (`handle_<kod>_api`). İkinci bir kayıt listesi tutulmaz.
- İstek zinciri: gövde çözümü → desen → dosya kuralı → CSRF (GET/HEAD/OPTIONS muaf) → headless değilse oturum + zaman aşımı + rol denetimi → denetim kaydı kalkanı içinde çağrı.

## 4. Tek manifest katalog

Sayfa, menü ve rol tanımları tek kaynakte durur (`destek/sayfa_katalogu.php` biçimi); `index.php`, `api.php` ve `sidebar.php` aynı kaynağı okur. Rol sıkılaştırma (`['*']` → `['yonetici']`) yalnız veri değişikliğidir, kod değişikliği gerektirmez. Roller üç yerde tekrarlanmaz; tekrarlanıyorsa bu bir sapmadır ve YAPI.md'de "Ölü uçlar" disipliniyle listelenir.

## 5. Temel akışlar

- **Web isteği**: `.htaccess` kapıları → `index.php` yapılandırma + oturum + `?page=` temizliği (`basename()` + sonek kırpar) → katalogdan tanım + dosya + yetki üçlüsü → belge başı + sidebar + `sayfa/<kod>.php` + `js/<kod>.js`.
- **Giriş**: CSRF + hız sınırı + `password_verify` + `session_regenerate_id(true)`.
- **Canlı güncelleme**: `deploy/deploy.php` yönetici oturumu + POST + CSRF ile çalışır; `?kanca=github` ucu HMAC-SHA256 doğrular; her iki yol `git merge --ff-only` kullanır; `uploads/` zaman damgalı arşivlere yedeklenir; günlük `log/deploy.log`'a yazılır. Kurulum bütününde bkz. `github-cpanel-rehberi.md`.
- **Log toplama**: Tüm loglar tek `log/` dizininde, her kanalın kendi budama tavanıyla; dizin web'e kapalı, tek istisna `deploy/log_dosya.php` uygulama denetimidir.

## 6. Girdi, çıktı ve güvenlik

- **CSRF**: Her durum değiştiren istekte zorunlu; doğrulama `hash_equals` ile sabit zamanlı; GET/HEAD/OPTIONS muaf; istemci `X-CSRF-Token` başlığı + gövde alanı taşır.
- **Çıktı**: JSON yanıtlar tek yardımcıdan (Content-Type + `nosniff` + `no-store` + `JSON_UNESCAPED_UNICODE`); HTML kaçışı sunucuda `htmlspecialchars(ENT_QUOTES)`, istemcide tek `htmlTemizle()` işlevinde.
- **Hata**: İstemciye yalnız sadeleştirilmiş mesaj döner; sınıf/dosya/satır/iz loga gider.
- **Denetim kaydı**: Fail-closed; yalnız adı geçen okuma eylemleri loglanmaz; parola/token alanları `[MASKELI]`.
- **Hız sınırı**: Sabit pencere + dosya kilidi; giriş ve sıfırlama yollarında ayrı limitler.
- **Parola**: bcrypt, cost ≥ 12.
- **DAO kuralı**: Tüm SQL tek veri katmanındadır (`destek/Veri/` ailesi); controller'larda SQL metni ve `$pdo->` çağrısı bulunmaz. Sorgu kuralları için bkz. `anayasa-veri_tabani.md`.
- **Tablo uçları**: Liste uçlarında limit/offset zorunlu; `COUNT` önbellek üzerinden; transaction yalnız sarmalayıcı işlevle.

## 7. Stil ve istemci

- Tailwind **derlenmez**; sabit sürüm CDN'den gelir.
- İkon politikası proje başına **tek yol**dur: ya Iconify CDN ya tümüyle inline SVG; iki yol karıştırılmaz, yeni ikon fontu eklenmez.
- Satır içi `style` yasaktır; istisnalar yalnız anayasal alanlardır (PDF/e-posta şablonları, giriş ekranı teması, `@page` kuralları).
- `js/app.js` `<head>` sonunda `defer` ile yüklenir; sözleşmesi `window.*` üzerinden açılır (`apiIstek`, `bildirimGoster`, `htmlTemizle`, yükleniyor örtüsü); yakalanmamış hata ve söz redleri tek bildirim kanalına bağlanır.
- `js/vendor/*` ve gömülü üçüncü parti kopyalar (ör. phpmailer) sabittir, dokunulmaz.
- Belge (PDF/Excel) üretim politikası için bkz. `istemci-tarafi-belge-uretimi.md`.

## 8. Çalışma zamanı

- **PHP 8.0+** tabanı (çekirdek `str_contains`/`str_starts_with` kullanımı); MultiPHP'de 8.x sabitlenir, 7.4'te fatal risk vardır.
- `declare(strict_types=1)` birinci taraf iş mantığında zorunlu; sunum kabukları muaf olabilir.
- PDO + MySQL: hazırlanmış deyim, `ATTR_EMULATE_PREPARES => false`, istisna modu.
- Oturum sertleştirme: `use_strict_mode`, `use_only_cookies`, `HttpOnly`, `SameSite=Lax`, HTTPS'te `Secure`; çerez adı proje önekli.
- `.env` yükleyicisi `KEY=VALUE` ayrıştırır; mevcut ortam değişkenlerini ezmez.
- Composer: yeni bağımlılık tek cümleyle gerekçelendirilir; `vendor/` sürüm dışı, sunucuda `composer install`.

## 9. Değişmezler

1. `.env` sürüm dışıdır ve web'den erişilemez; sırlar yalnız `.env` (ve gerekiyorsa `deploy/.env`) içinde yaşar.
2. `api/`, `sayfa/`, `destek/`, `sidebar/`, `docs/`, `log/`, `vendor/` yalnız include edilir; doğrudan HTTP çağrısı yapılmaz (kök + dizin yerel `.htaccess` kapıları).
3. Modül = dosya çifti kuralı: yeni modül için `sayfa/<kod>.php` + `api/<kod>_api.php` çifti ve katalog kaydı yeterlidir.
4. Sayfa/menü/rol tanımı tek manifest'te; rol listeleri koddan çoğaltılmaz.
5. CSRF her durum değiştiren istekte zorunludur.
6. Hata ayrıntısı istemciye sızmaz; loglarda PII maskelenir.
7. SQL yalnız DAO katmanındadır; controller'da SQL yazılmaz.
8. Yüklemelerde boyut, MIME ve dosya imzası doğrulaması zorunludur; istemci dosya adına güvenilmez.
9. `js/vendor/*` ve gömülü kütüphane kopyaları sabittir; yeni bağımlılık gerekçesiz eklenmez.
10. `uploads/` depoda tutulmaz; web'de script çalıştırma kapalıdır.
11. Log dosyaları web'den servis edilmez; tek istisna `deploy/log_dosya.php` denetimidir.
12. Servis işçisi yalnız gezinme isteklerini yakalar, ağ hatasında bağımsız `offline.html` gösterir; başka varlık önbelleklenmez.
13. UI metinleri tam Türkçe imlâ ile yazılır (ğ, ü, ş, ı, ö, ç).

## 10. Adresleme (temiz URL)

Kök `.htaccess` dört kural yazar:

1. `^login/?$` → `login.php` (iç rewrite).
2. `THE_REQUEST` içinde `/login.php` görülürse 301 ile `/login`'e döner.
3. `THE_REQUEST` içinde `index.php?page=X` → `/X` (301, sorgu dizisi korunur).
4. Gerçek dosya/dizin değilse tek segment `^([a-z0-9_]+)/?$` → `index.php?page=$1` [QSA].

## 11. Yeni modül tarifi

1. `sayfa/<kod>.php` (ince kabuk) + `api/<kod>_api.php` (`handle_<kod>_api`) çiftini yaz.
2. Kataloğa sayfa kaydını ekle (`baslik`, `ikon`, `menu`, `roller`, gerekirse `kutuphaneler`).
3. `js/<kod>.js`'i yaz; `app.js` sözleşmesinden (`apiIstek`, `htmlTemizle`) ayrı fetch/kaçış üretme.
4. SQL'i DAO katmanına koy; controller'da sorgu bırakma.
5. Doğrula: `php -l` (yeni dosyalar), hedefli grep (`jsonYanit`/`islemLoguYaz` kullanımı, controller'da SQL yok), katalogdan görünürlük denetimi, `git status --porcelain` beklenen küme.

## 12. Proje YAPI.md şablonu

Her panel projesi `docs/YAPI.md`'yi şu iskeletle tutar ("yaşayan yapı otoritesi" beyanı + tarama tarihi damgası ile başlar):

1. Proje Yapısı (açıklamalı ağaç; satır sayıları tarihli working tree'den)
2. Temel akışlar (web isteği, modül çözümleme, canlı güncelleme, log toplama; projeye özgü akışlar örn. DAQ)
3. Rol modeli
4. Girdi ve çıktı kuralları
5. Stil (+ PWA alt bölümü)
6. Çalışma zamanı ve kütüphaneler (PHP, Composer, ortam anahtarları tablosu)
7. Değişmezler
8. Adresleme
9. Doğrulama (+ sunucu ortam envanteri ve cPanel→GitHub kurulum ekleri)

Her yeniden yapılandırma görevi ilgili bölümü güncellemekle yükümlüdür; ölü uçlar ve kasıtlı sapmalar açıkça listelenir ("Ölü uçlar" disiplini).

## 13. Doğrulama

- Bu belgenin türetildiği kaynaklar diskte doğrulanmıştır: `<proje>/docs/YAPI.md`, `<proje>/docs/ornek-yapi.md`.
- Panel projelerinde görev doğrulaması: `php -l`, hedefli grep denetimleri, `git status --porcelain`; kanıtlar görev raporuna gömülür.
- Şema değişikliği yalnız numaralı göç dosyalarıyla (ör. `data/goc/0001_*.php` deseni) uygulanır.
