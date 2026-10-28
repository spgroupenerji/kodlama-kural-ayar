# Hazır Promptlar

> Kaynak: kullanıcı notu (2026-10-23; scrollytelling notları 2026-10-28). Kullanım: Konuya uyan bloğu olduğu gibi yapıştır; ortak kütüphane havuzu `cdn-katalog.md`. 4. bölüm prompt bloğu değil, seçim notudur.
> "Ham malzeme" ve "doğrulama" bölümleri zorunludur: malzeme yoksa varsayım tek satırda belirtilir, kanıtsız madde tamam sayılmaz.

## 1) Sinematik Kurumsal Site — HTML, Yalnızca CDN

Prototip ve yan projeler içindir; ana proje için 2. blok kullanılır.

```text
Rol: Ödüllü stüdyoların (Locomotive, Active Theory, Dogstudio) seviyesinde kıdemli Creative Technologist ve WebGL/frontend mimarı.

Görev: Üst düzey bir yazılım/teknoloji şirketi için yalnızca CDN bağlantılarıyla, tek HTML dosyasında çalışan sinematik, interaktif, kurumsal ağırlığı yüksek site üret.

Ham malzeme (kod yazmadan önce topla; eksikse varsayımı tek satırda belirt):
- Şirketin gerçek metinleri (başlık, hizmet, referans, iletişim), logosu, ekran görüntüleri, ölçülebilir metrikleri.
- Marka paleti, yazı tipi ve ton. Placeholder metin "örnek" olarak işaretlenir; lorem ipsum kullanılmaz.

Deneyim kuralları (zorunlu):
1. Derinlik: Arka plan, orta katman ve ön plan farklı hızlarda paralaks hareket eder; sayfa 2B doküman değil 3B sahnedir.
2. Kaydırma: Lenis ile ataletli kaydırma; GSAP ScrollTrigger, Lenis'in requestAnimationFrame döngüsüne senkronize edilir; kaydırma tuzağı kurulmaz.
3. Geçişler: Sahne pin: true ile sabitlenir; içerik scale, blur, opacity ve rotateX/rotateY ile çıkar; ani kaybolma yoktur, sahne başına tek odak vardır.
4. İmleç: Manyetik özel imleç buton ve kartlarda genişler, mix-blend-mode: difference ile tepki verir; dokunmatik cihazlarda devre dışıdır.
5. Ses: Howler.js ile tok, tiz olmayan mikro SFX; varsayılan sessiz, tek tıkla aktif.
6. Hareket dili: Yaylanma ve eylemsizlik; aynı öğede tek eğri; prefers-reduced-motion açıkken dekoratif hareket tamamen kapanır.

Yığın (tek seçim, gerekçeli):
- Hareket: Lenis + GSAP/ScrollTrigger + SplitType (maskeli başlık stagger).
- 3B: Three.js — hero'da fareye duyarlı dijital çekirdek/küre veya cyber grid; WebGL yoksa CSS gradient/görsel fallback.
- Ortam: tsParticles — yalnızca alt bölümlerde, düşük yoğunlukta.
- Stil ve ikon: Tailwind tarayıcı CDN'i (`@tailwindcss/browser`, tam sürüm + SRI; derleme adımı yok) + Remix Icon.
- Grafik: Chart.js, koyu tema ve neon çizgiler; tek grafik kütüphanesi kullanılır.
- Slider: Swiper — coverflow veya 3B kayan kartlar.
- Hero terminal: Typed.js.
- Geri bildirim: SweetAlert2 + Canvas-Confetti yalnızca başarılı form gönderiminde; Tippy.js cam tooltip.
- Kalan ihtiyaç: cdn-katalog.md havuzundan cdnjs/unpkg/jsdelivr üzerinden seçilir; sürümler sabitlenir ve CDN URL'leri yüklenmeden önce 200 doğrulanır.

Tasarım felsefesi — Zen katmanı:
- Kanso: İşlevsiz süs yok; her öğe doğrudan amaca hizmet eder.
- Ma: Boşluk pasif değil; bölümler arası nefes ve tek odak.
- Görünmez teknoloji: Kılavuz olmadan sonraki adım öngörülür.
- Kademeli odak: Aynı anda tek aksiyon; ikincil işlevler katmanda.
- Shizen: Hareket fiziksel (kütle, ivme), mekanik değil.

Erişilebilirlik ve performans bütçesi:
- Klavye ile tüm etkileşim, görünür focus, WCAG AA kontrast; ses ve video kontrolü kullanıcıda.
- İlk yükleme ≤ 1,5 MB (gzip), LCP ≤ 2,5 s, INP ≤ 200 ms, CLS ≤ 0,1; orta donanımda ≥ 50 fps.
- Tek rAF döngüsü; temizlikte Three.js dispose, ScrollTrigger.kill ve olay dinleyicisi sökümü.

Doğrulama (teslimden önce kanıtla):
- Lighthouse mobil: Performance ≥ 85, Accessibility ≥ 95; axe-core kritik ihlali yok.
- DevTools Performance kaydı: uzun görev yok, kaydırmada kare düşmesi yok.
- 360/768/1440/1920 px ekran görüntüleri; konsol hatası sıfır; reduced-motion açıkken animasyon kapalı.
- Tüm kütüphaneler CDN'den ve sürümü sabit; yerel dosya yok; tek HTML dosyası eksiksiz çalışır.

Kabul: Maddeler kanıtlarıyla sağlanır; sağlanamayan her madde gerekçesiyle listelenir.
```

## 2) Ana Proje — Vite + React SPA + LiteSpeed PHP API

```text
Ana projeyi şu hedef mimariye göre geliştir:
1. Model: Vite ile derlenen React SPA (istemci taraflı yönlendirme) + LiteSpeed üzerinde PHP REST API. Çalışma zamanında Node yok: Node yalnızca derleme aşamasında, üretime yalnızca statik dist/ gider.
2. Yönlendirme: LiteSpeed'de /api/* PHP'ye, diğer tüm yollar index.html'e (SPA fallback); derin bağlantılar 404 vermez.
3. Güvenlik: React ve API aynı alan adında (dijital.<alanadi>), CORS gerekmez. CSRF, oturum doğrulama ve girdi doğrulama zorunludur.
4. Süreklilik: Mevcut veritabanı ve deploy/ mekanizması korunur; kütüphaneler npm ile kurulur, CDN kullanılmaz.
5. Sözleşme: Her uç nokta için metot, yol, girdi/çıktı şeması ve hata kodları önce yazılır; istemci bu sözleşmeye göre tiplenir.

Ham malzeme (kod yazmadan önce topla):
- Mevcut veritabanı şeması, deploy/ betikleri, LiteSpeed/.htaccess yönlendirme kuralları, mevcut rota envanteri.
- Bugünkü davranışın baseline'ı: hangi URL 200/404 dönüyor, hangi API çağrıları çalışıyor.

Doğrulama (teslimden önce kanıtla):
- npm run build temiz; dist/ çalışma zamanında Node gerektirmez; bundle bütçesi tanımlı ve aşılmıyor.
- Derin bağlantı sunucuda 200; /api/* PHP'ye gider; CSRF'siz POST reddedilir; oturumsuz korumalı uç nokta 401 döner.
- Deploy öncesi/sonrası smoke test listesi ve geri alma adımı yazılı.
```

## 3) Sinematik Scrollytelling — Awwwards Seviyesi

1. bloktan farkı: içerik 500vh'lik bir ray üzerinde sabitlenir, arkadaki tek sahneyi kaydırma sürer; sayfa düzeni değil kamera hareketi tasarlanır. Yeni projelerde açılış bloğu olarak kullanılır.

```text
Rol: Awwwards "Site of the Day" seviyesinde sinematik kaydırma deneyimleri üreten kıdemli creative developer.

Bana standart bir SaaS landing page YAPMA. Bento grid, kart içinde kart veya standart hero section yasak. Awwwards "Site of the Day" kalitesinde bir scrollytelling (sinematik kaydırma) deneyimi inşa edeceğiz.

Mimari kuralları:
1. Lenis ile ataletli kaydırma kur; Lenis'i gsap.ticker üzerinden ScrollTrigger'a senkronize et. İkinci bir requestAnimationFrame döngüsü açma.
2. Arka planda tam ekran (100vw × 100vh, position: fixed) tek bir Three.js/Canvas sahnesi çalışsın; DOM yalnızca metin katmanı olsun.
3. Sayfa yüksekliği 500vh olsun; içerik bölümleri GSAP ScrollTrigger (`scrub: 1.5`, `pin: true`) ile kameranın X, Y, Z koordinatlarını ve rotasyonunu sürsün.
4. Metinler SplitText mantığıyla (SplitType) satır satır maskelenerek, `filter: blur(20px)` → `0px` ve opacity geçişiyle belirsin; aynı anda tek odak olsun.
5. WebGL yoksa veya prefers-reduced-motion açıksa statik fallback'e düşülsün; konsol hatası sıfır kalsın.

Ham malzeme (kod yazmadan önce topla; eksikse varsayımı tek satırda belirt):
- Marka adı, gerçek metinler (başlık, bölüm, CTA), logo, ürün görselleri ve ölçülebilir metrikler.
- 3B varlık: .glb sahne veya Yöntem A için video/kare dizisi; yoksa üretim planı ve geçici düşük poligonlu sahne.
- Hedef cihaz sınıfları ve performans bütçesi: mobil ≥ 50 fps, masaüstü ≥ 60 fps.

Doğrulama (teslimden önce kanıtla):
- Lenis + gsap.ticker tek rAF döngüsü; DevTools Performance kaydında uzun görev ve kare düşmesi yok.
- 360/768/1440/1920 px'te 500vh sahne, pin ve scrub doğru; prefers-reduced-motion açıkken hareket kapalı.
- Lighthouse mobil: Performance ≥ 85, Accessibility ≥ 95; CLS ≤ 0,1; WebGL fallback'i çalışıyor.
- Konsol hatası sıfır; tüm kütüphaneler sürümü sabit CDN veya npm kaynağından.
```

## 4) Sinematik Scrollytelling — Yığın, MCP, Beceri ve Platform Notları

> Prompt bloğu değildir; 1. ve 3. blok için seçim notudur. Kaynak: kullanıcı notu (2026-10-28). Adres, paket ve platform adları kullanımdan önce doğrulanır; doğrulanamayanlar "doğrulanmalı" etiketlidir.

### 4.1 Neden standart görünür?
- **Araç farkı:** Impeccable ve UI/UX Pro Max gibi beceriler "AI slop"u (tipografi, renk, hizalama hataları) düzeltip Stripe/Linear düzeyinde temiz kurumsal arayüz üretir; tasarımı düzgünleştirir, sinematik filme dönüştürmez.
- **DOM mimarisi:** Standart siteler kutular üzerine kuruludur; kaydırdıkça metin ve görsel kutuları yukarı çıkar.
- **Yöntem A — video/kare dizisi (Apple tekniği):** Arka planda 3B bir video veya ~300 sıralı `.webp` kare durur; sayfa kaymaz, JS kaydırma yüzdesini hesaplayıp videoyu 1. saniyeden 2. saniyeye ilerletir.
- **Yöntem B — gerçek zamanlı 3B (WebGL):** Ekranda Three.js sahnesi çalışır; kaydırma çubuğu kameranın rayıdır, kaydırdıkça kamera sahnenin içinde uçar.

### 4.2 Teknoloji yığını
- **GSAP + ScrollTrigger:** İşin yönetmeni; `pin: true` ekranı sabitler, `scrub: 1` animasyonu fare tekerleğine yumuşak bağlar. Bu ikisi olmadan sinematik his yakalanmaz.
- **Lenis (Darkroom Engineering):** Tarayıcının kesikli kaydırmasına ağırlık ve eylemsizlik katar; tekerlek bırakılsa bile ekran yağ gibi akmaya devam eder.
- **Three.js / React Three Fiber:** `.glb` modelleri, ışıklandırmayı ve kamera açılarını tarayıcıda çalıştıran WebGL motoru.
- **GLSL shader'lar (Curtains.js / OGL):** Görselde su dalgası, cam kırılması ve sıvı geçiş efektleri üreten ekran kartı kodu.
- **Barba.js / Astro View Transitions:** Sayfa geçişlerinde beyazlayıp yenilenmeyi önler; sahneden sahneye film kurgusu gibi kesintisiz geçiş sağlar.
- **Zincir:** Lenis → `gsap.ticker` → ScrollTrigger → Three.js. Kaydırma tek rAF döngüsünden geçer; ikinci döngü kurulmaz (bkz. 1. blok, kural 2).

### 4.3 MCP sunucuları
Ajanın körlemesine kod yazması yerine 3B sahneyi ve tasarım aracını doğrudan kontrol etmesini sağlar.

| MCP sunucusu | İşlev | Bağlantı / kurulum |
| --- | --- | --- |
| Spline MCP | 3B nesneleri, ışıkları ve kaydırma tetikleyicilerini Spline sahnesinde kurar | `mcp.spline.design/mcp` veya Spline masaüstü uygulaması |
| Framer MCP | Framer kanvasında sayfa, animasyon düzeni ve CMS oluşturur | `https://mcp.framer.com/mcp`; OAuth |
| Three.js DevTools MCP | Tarayıcıdaki 3B sahneyi canlı denetler: materyal, shader, kamera, FPS (69 araç) | npm `threejs-devtools-mcp` (v0.5.0) |
| Three.js Resources MCP | Güncel GLSL/TSL shader dönüştürücülerini ve hazır 3B şablonlarını ajana besler | Kurulum/API anahtarı gerekmez; adres doğrulanmalı |
| three-js-mcp (WebSocket) | "Kamerayı sağa kaydır, küpü döndür" gibi komutlarla canlı sahneyi WebSocket üzerinden yönetir | Node.js; paket adı doğrulanmalı — npm'de `locchung-three-js-mcp` bulunamadı |

### 4.4 Beceriler (skill)
- **`impeccable`:** Standart modda kullanma; alt komutlar: `/impeccable overdrive` (iddialı shader, WebGL, sıra dışı efekt), `/impeccable animate` (mikro etkileşim), `/impeccable delight` (koreografik geçiş). Katalog §3'te `pbakaus/impeccable` olarak kayıtlı.
- **taste-skill (Leonxlnx):** Simetrik kutuları yasaklayan, katı tipografi ve GSAP motion engineering kısıtları içeren beceri; `Leonxlnx/taste-skill` (katalog §3).
- **12-principles-of-animation (raphaelsalaja):** Disney'in 12 animasyon prensibini (squash and stretch, anticipation, follow through) arayüze uygular; depo adı doğrulanmalı. Katalogdaki `LottieFiles/motion-design-skill` aynı prensipleri kapsar.

### 4.5 Hazır platformlar (kod yazmadan)
- **Spline + Framer:** Endüstri standardı ikili; 3B sahne ve kamera yolu Spline'da tasarlanır, tek tıkla URL alınıp Framer'a gömülür; metin parallax'ı ve kaydırma transform'ları sıfır kodla ayarlanır.
- **MotionSites.ai:** 3B kaydırmalı sinematik site şablonları ve Claude prompt kütüphanesi; sahne kodları doğrudan kopyalanır.
- **Scrollytelling.ai:** Kaydırmaya duyarlı sinematik hikâye ve sunum üreten yapay zekâ motoru.
- **Builder.io + Veo 3 / Sora:** En pratik hile; 5 saniyelik sinematik kamera videosu üretilir, karelere (image sequence) bölünür ve GSAP ScrollTrigger ile kaydırmaya bağlanır. Apple'ın AirPods/Mac Pro sayfalarındaki tekniktir, her cihazda 60 fps hedefler.

### 4.6 Yöntem seçimi
- Etkileşimli gerçek 3B (kamera, ışık, model) gerekiyorsa → Yöntem B: Three.js + ScrollTrigger.
- Sinematik his yeterli, hızlı ve her cihazda akıcı olacaksa → Yöntem A: video/kare dizisi + ScrollTrigger.
- Kod yazmadan görsel üretim → Spline + Framer; 3B bilgisi olmadan sinematik → Builder.io + video tekniği.
