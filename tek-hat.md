# Tek Hat SCADA — Açık Kaynak Proje ve Kütüphane Kataloğu

> Kaynak: kullanıcı notları; lisans, etkinlik ve API bilgileri GitHub API ile 2026-11-04 tarihinde doğrulandı · v202611040706

Tek hat (single-line diagram) şemasını canlı SCADA verisiyle renklendirmek için kullanılabilecek açık kaynak projeler, uygulama içi çizim motorları ve IEC 60617 sembol kütüphaneleri. Her maddede lisans ve son etkinlik bilgisi verilmiştir; lisans, seçim yaparken bağlayıcı kriterdir.

## 1. Doğrudan SCADA / Tek Hat Odaklı Projeler

1.1. **SCADAvis.io** — [`riclolsen/scadavis`](https://github.com/riclolsen/scadavis) · GPL-3.0 · 33 yıldız · son itme 2023-11. Saf HTML5/JavaScript/SVG çalışma zamanıdır: sinoptik ekranlar özel Inkscape SVG editöründe çizilir, ekrandaki her kesici ve baraya bir veri etiketi bağlanır, çalışma anında gelen anlık veriye göre kesici açılıp kapanır, bara renklenir, alarmda yanıp sönme uygulanır. Tek hat renklendirme fikrinin en saf referansıdır; ancak GPL-3.0 lisansı, kodun panele gömülmesi hâlinde türev eser tartışması doğurur. Bu yüzden yaklaşımı referans alınmalı, kodu kopyalanmamalıdır.

1.2. **OSHMI / JSON-SCADA** — [`riclolsen/oshmi`](https://github.com/riclolsen/oshmi) · GPL-3.0 · 467 yıldız; README'si projenin [`riclolsen/json-scada`](https://github.com/riclolsen/json-scada) tarafından devralındığını bildirir. JSON-SCADA aktif geliştirilen halidir (GPL-3.0, 498 yıldız, son itme 2026-11). Trafo merkezi ve kontrol merkezi HMI'sıdır; IEC 61850, IEC 60870-5-104, IEC 60870-5-101 ve DNP3 protokollerini destekler; yığını SVG, HTML5, JavaScript, PHP, Lua, Qt, SQLite, Nginx, Inkscape ve Vega'dır. Bize katan şey, saha protokolünden gelen veriyi SVG sinoptiğe bağlayan olgun mimari örneğidir.

1.3. **FUXA** — [`frangoteam/FUXA`](https://github.com/frangoteam/FUXA) · MIT · 5.250 yıldız · son itme 2026-11. GitHub'daki en yaygın açık kaynak web tabanlı SCADA/HMI projelerinden biridir; arka ucu Node.js, ön yüzü Angular, HTML5 ve SVG'dir. Editörü kendi Angular bileşenleriyle yazılmıştır (svg-edit türevi değildir; bu düzeltme kullanıcı notundaki varsayımı geçersiz kılar). Bize katan şey, bileşen veri bağlama (data-binding) mantığının MIT lisanslı, okunabilir bir referansı olmasıdır. Angular bağımlılığı nedeniyle PHP paneline doğrudan gömülmez.

1.4. **Meta2d.js** — [`le5le-com/meta2d.js`](https://github.com/le5le-com/meta2d.js) · MIT · 1.301 yıldız · son itme 2026-11. "Veri odaklı gösterim + dinamik etkileşim" üzerine kurulu 2B görselleştirme motorudur; web konfigürasyonu, SCADA, rapor ve akış şemaları için yazılmıştır. Çizim, animasyon, mesaj/olay, gerçek zamanlı veri iletişimi, koşullu alarm ve yaşam döngüsü kancaları hazırdır. Çekirdek Canvas tabanlıdır; depoda ayrıca `svg` paketi bulunur. Bize katan şey, kablo üzerinde akan nokta animasyonu, kesici durum değiştirme ve alarm efekti gibi tek hat gereksinimlerinin hazır gelmesidir.

## 2. Uygulama İçi Çizim Editörü Motorları

2.1. **AntV X6** — [`antvis/X6`](https://github.com/antvis/X6) · MIT · 6.751 yıldız · son itme 2026-10. Belgede tanımlı bağlantı noktaları (port/connectionPoint), `orth` (dik açılı) ve engellerden kaçınan `manhattan` yönlendiricileri ile tek hat şemasının en kritik iki ihtiyacını hazır karşılar. SVG tabanlı çizim yapar, düğüm bazında HTML'e de izin verir; kenar rengi `edge.attr('line/stroke', '#22c55e')` ile değiştirilir. Sıfırdan kendi editörünü kurmak isteyen için en kararlı seçenektir.

2.2. **JointJS Core** — [`clientIO/joint`](https://github.com/clientIO/joint) · MPL-2.0 · 5.397 yıldız · son itme 2026-11. Açık kaynak çekirdeği `@joint/core` paketidir ve MPL-2.0 ile gelir (dosya bazlı copyleft; kendi kodunuzu kapatmanızı engellemez). Sürükle-bırak sembol paleti (Stencil), özellik paneli (Inspector), araç çubuğu ve geri al/yinele gibi hazır editör araçları ticari JointJS+ sürümündedir; ticari paket herkese açık npm'de yayımlanmaz. Ücretsiz sürümde bu araçları kendi HTML/JS kodunuzla yazmanız gerekir.

2.3. **draw.io gömülü mod** — [`jgraph/drawio`](https://github.com/jgraph/drawio) · Apache-2.0 · 9.166 yıldız · son itme 2026-10. Kendi çizim motorunuzu yazmak yerine `embed.diagrams.net/?embed=1&proto=json` adresini bir `<iframe>` içinde açarsınız; editör ana sayfayla `postMessage` üzerinden konuşur, kaydettiğinizde düzenlenebilir XML'i (istenirse SVG çıktısını) geri verirsiniz ve bunu `api.php` üzerinden veritabanına yazarsınız. `Sidebar-Electrical` adlı hazır elektrik sembol kitaplığı vardır; ancak bu kitaplık IEC 60617'nin tamamını kapsamaz ve draw.io kendini SVG editörü olarak tanımlamaz (README'de açıkça belirtilir). Apache-2.0, kendi statik kopyanızı barındırmanıza izin verir.

## 3. IEC 60617 Sembol Kütüphaneleri

3.1. **chille/electricalsymbols** — [`chille/electricalsymbols`](https://github.com/chille/electricalsymbols) · 33 sembol · son itme 2017-07. Devre şeması çizmek için gereken en yaygın sembolleri toplar; README'si amacın IEC 60617 ile "mümkün olduğunca uyumlu" olmak olduğunu söyler. **Lisans dosyası yoktur** (GitHub lisans alanı boş); bu yüzden ticari panelde kullanım izni belirsizdir ve kullanımdan önce izin alınmalıdır.

3.2. **basverdoes/ElectricalSymbolLibrary** — [`basverdoes/ElectricalSymbolLibrary`](https://github.com/basverdoes/ElectricalSymbolLibrary) · son itme 2025-12. Yayın kalitesinde devre şeması için vektörel semboller sağlar; ANSI ve IEC standartlarındaki yaygın analog/dijital sembolleri kapsamayı hedefler. Lisans ayrımı kritiktir: yalnız `src/symbols` altındaki semboller CC0 1.0'dır, depodaki diğer tüm dosyalar CC BY-NC-SA 4.0'dır (ticari kullanım yasak). Ayrıca kapsamı tek hat güç sembollerinden çok devre şeması sembolleridir.

## 4. Karar Notları

4.1. Lisans riski sıralaması (düşükten yükseğe): MIT (FUXA, Meta2d.js, X6) → Apache-2.0 (draw.io) → MPL-2.0 (JointJS Core) → GPL-3.0 (SCADAvis, OSHMI/JSON-SCADA). Ticari bir panelde GPL kodunu gömmek yerine yalnız mimari yaklaşımı örnek alınmalıdır.

4.2. Seçim kuralı: sembol çizme yükü ağırsa draw.io gömülü mod; editörün tamamı uygulamanın içinde ve kontrol edilebilir olacaksa X6; hazır animasyon ve veri aboneliği isteniyorsa Meta2d.js.

4.3. Referans mimari her üç durumda da aynıdır: veri etiketi (`tanim_degisken.php` benzeri) → SVG öğesi → durum sınıfı. SCADAvis ve OSHMI bu eşlemeyi on yıldır üretimde kullanır; kendi motorumuzda aynı sözleşmeyi korumak, sonradan kütüphane değiştirmeyi ucuzlatır.

4.4. Kullanıcı notundaki düzeltilen iddialar: FUXA editörü svg-edit türevi değil (kendi Angular bileşenleri); draw.io "tüm IEC 60617 sembolleri" içermez (yalnız hazır elektrik kitaplığı); basverdoes kütüphanesi tek hat değil devre şeması sembolleridir; OSHMI yeni iş için doğru adres değildir, yerine JSON-SCADA kullanılmalıdır.

4.5. Doğrulanmalı: Meta2d.js `svg` paketinin üretim olgunluğu; draw.io gömülü modun `export` olayıyla SVG çıktısı verip vermediği; chille deposu için lisans izni.
