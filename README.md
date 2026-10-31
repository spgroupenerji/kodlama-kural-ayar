# Kişisel Notlar — Kodlama, Sistem ve Referans Defteri

> Bu depo bir ürün veya topluluk kaynağı değil; kendi hızlı erişimim için tuttuğum **kişisel bir karalama defteri**. Herkese açık olmasının nedeni, notlarıma başka cihazlardan kolayca ulaşabilmem.

Buradaki içeriğin bir kısmı doğrudan benim hazırladığım şeyler (prompt blokları, betikler); bir kısmı ise çeşitli yerlerden toplayıp kendi iş akışıma göre not düştüğüm bilgiler. Hepsini kopyala-yapıştır edasıyla, hızlı erişim için bir arada tutuyorum. Düzen, kapsam ve güncellik garanti değil; eksik, tekrarlı veya eskimiş bölümler olabilir.

Buradan bilgi almak isteyenler için herhangi bir yasak ya da kısıtlama yok; isteyen bakabilir, kopyalayabilir, işine yarayan kısmı kullanabilir. Yalnız bu depo bir başvuru kaynağı olarak tasarlanmadı: notların işinize yarayacağının veya güncel olduğunun garantisi yoktur. Faydalı bulursanız ne güzel, bulamazsanız sorun değil.

## Ne var?

- `anayasa/` — proje tipine göre bağlayıcı kurallar: `web-site/`, `web-uygulama/`, `rust-masaustu/`; her set mimari, veri tabanı ve görsel dizayn dosyasından oluşur.
- `prompt/` — hazır prompt blokları, CDN araç kataloğu ve analitik çalışma sistemi promptu.
- `04-skill-mimarisi-kurallari.md` — üretim seviyesinde Skill mimarisi: niyet algılama, şema/protokol, orkestrasyon, durum/bellek, güvenlik, dayanıklılık, gözlemlenebilirlik ve platform kuralları.
- `betikler/`, `winget/` — Windows kurulum ve bakım için `.bat` dosyaları.
- `araclar/` — yardımcı Node betikleri (ör. sayfa ekran görüntüsü).
- `docs/` — ortam envanteri betiği.
- `AGENTS.md`, `CLAUDE.md`, `settings.json` — bu depoda çalışan ajanlar için anayasa ve ayar dosyaları; insan okumasından çok ajan davranışını sabitlemek içindir.
- Kök `*.md` dosyaları — tek konuluk rehberler ve notlar: Windows'ta kodlama, haber çekme kuralları, PHP yapı konvansiyonu, GitHub + cPanel deploy, rclone aktarımları, sunucu karşılaştırması, HTML etiket rehberi, model kurulumları.

## Kullanım

- Arama: `grep -ri "terim" .` veya dosya adıyla; dizin yapısı bilinçli olarak düzenli değildir.
- Notlar yazıldığı tarihte doğrulanmıştır; sürüm, API ve fiyat bilgileri değişebilir. Emin olunmayan ayrıntılar ilgili dosyada "doğrulanmalı" etiketiyle durur.
- Komutları kendi ortamınızda denemeden uygulamayın; oluşabilecek veri kaybı veya hesap riski size aittir.
- Destek, düzeltme talebi veya issue takibi beklenmiyor; burada bir bakım taahhüdü yoktur.
- Lisans yok; isteyen kopyalayıp kullanabilir, kaynak gösterme zorunluluğu yoktur.

## Başka bir şey arıyorsanız

Bu depo dağınık kişisel notlardan oluşur. Daha düzenli projeler (Rust masaüstü uygulamaları, Python mini uygulamaları, AutoCAD Lisp çalışmaları) için profilimdeki diğer depolara bakın:

- https://github.com/spgroupenerji?tab=repositories

Son güncelleme: 2026-10-31
