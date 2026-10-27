# ANAYASA DİZİNİ — Proje Tipine Göre Bağlayıcı Kurallar

> Sürüm: 2026-10-27
> Öncelik: `AGENTS.md` > ilgili alan anayasası > proje içi belgeler
> Doğrulama: Sürüm ve API iddiaları context7 ve resmî belgelerle doğrulandı (bkz. §4).

Bu dizin, kök dizindeki tekil `anayasa-*.md` metinlerinin üç proje tipine ayrılmış halidir. Her proje yalnız kendi setini kopyalar; setler arasında hüküm taşınmaz.

## 1. Set seçimi

| Proje tipi | Dizin | Kimlik | Tipik iş |
| --- | --- | --- | --- |
| SEO/satış odaklı tanıtım sitesi | `web-site/` | Herkese açık, oturum yok | Tanıtım, teklif, lead formu, içerik |
| Oturumlu panel ve çevrimiçi sistem | `web-uygulama/` | Oturum, rol, denetim kaydı | Yönetim paneli, raporlama, SCADA arayüzü, API |
| Rust masaüstü uygulaması | `rust-masaustu/` | GPU çizim, yerel veri | GPUI + SQLite masaüstü araçları |

Her set üç dosyadan oluşur: `mimari.md`, `veri-tabani.md`, `gorsel-dizayn.md`.

## 2. Ortak değişmezler

Aşağıdaki hükümler üç sette de bağlayıcıdır; alan anayasaları bunları yalnız somutlaştırır.

1. Ana Anayasa (`AGENTS.md`) üstündür; alan anayasası yalnız kendi katmanında uzmanlık hükmü koyar.
2. Tüm kullanıcı metinleri tam Türkçe imlâ ile yazılır (ğ, ü, ş, ı, ö, ç).
3. Sırlar yalnız `.env` veya secret manager üzerinden yönetilir; loglarda parola, token ve kişisel veri maskelenir.
4. Tüm sürümler sabitlenir; `@latest` ve dinamik sürüm etiketi yasaktır; doğrulanmamış API üretime giremez.
5. Erişilebilirlik hedefi WCAG 2.2 AA'dır; klavye ile tam kullanım ve görünür odak zorunludur.
6. Boşluk baremi 4px'tir; durum renkleri başarı `emerald/green`, uyarı `amber/yellow`, hata `rose/red`, bilgi `sky/blue` ile eşlenir.
7. İkon seti Lucide'dir; ikon fontu ve çalışma zamanı ikon API'si kullanılmaz.
8. `prefers-reduced-motion` desteği zorunludur; hareket, tercih kapalıyken devre dışı kalır.
9. Ölçülebilir kabul kapısı bulunmayan anayasa tamamlanmış sayılmaz; her belge komut, araç veya ölçüm içeren bir kapıyla biter.

## 3. Çakışma çözümü

Çelişki halinde sıra: kullanıcının en güncel yazılı talimatı → `AGENTS.md` → ilgili alan anayasası → proje `YAPI.md`/README → model genel bilgisi. Üstteki kaynak kazanır; alttaki hüküm geçersiz sayılır ve düzeltilir.

## 4. Doğrulanmış sürüm tablosu

| Bileşen | Sürüm | Kapsam | Doğrulama kaynağı |
| --- | --- | --- | --- |
| PHP | 8.4.27 (hedef; 8.5.12 mevcut) | site, uygulama | endoflife.date/php; `sunucu-karsilastirmasi.md` |
| MySQL / MariaDB | MySQL 8.4.13 LTS veya MariaDB 10.11+ (mevcut MySQL 8.0.45, EOL 2026-04-30) | site, uygulama | endoflife.date/mysql; cPanel ortam bilgisi |
| Tailwind CSS | 4.3.3 (standalone CLI, derlenmiş CSS) | uygulama | npm registry; v4.3.3 release ikilileri |
| htmx | 2.0.11 | uygulama | npm registry |
| Lucide | 1.61.0 | site, uygulama | npm registry (latest, deprecated değil) |
| Python | 3.14 (asgari 3.14.10) | uygulama servis katmanı | endoflife.date/python |
| gpui-kit / gpui-pre | 0.8.1 / 0.3.10 | Rust masaüstü | crates.io API; gpui-kit v0.8.1 release notu |
| Rust | 1.92+ (asgari; kararlı 1.99.1) | Rust masaüstü | gpui-kit kurulum belgesi; endoflife.date/rust |
| rusqlite / rusqlite_migration | 0.41.0 / 2.6.0 | Rust masaüstü | crates.io API |
| AccessKit | 0.24 (gpui-pre bağımlılığı) | Rust masaüstü | crates.io bağımlılık kaydı |

## 5. Bakım

1. Sürüm, EOL veya API değişiminde yalnız ilgili set güncellenir; belgenin `Doğrulama` satırı tarihlenir.
2. Her değişiklik tek konu taşır; eski hüküm silinir, çelişen ikinci hüküm bırakılmaz.
3. Kök dizindeki `anayasa-*.md` dosyaları ile `rust-gpui-kit-arayuz.md` bu dizine taşınmış ve kaldırılmıştır; geçmiş kayıt Git tarihindedir.
4. Yeni proje kurulurken önce bu dizinden doğru set seçilir, sonra proje `docs/` dizinine kopyalanır; kök dizindeki metinler doğrudan referans verilmez.
