Promptlar

> Kaynak: kullanıcı notu (2026-10-23) — hedef mimari, Motion yeniden tasarımı ve CDN araç kataloğu.

## Hedef Mimari — Vite + React SPA + LiteSpeed PHP REST API

Çalışma zamanında Node.js servis bağımlılığı yaratmayan hibrit model: Vite ile derlenen React tek sayfa uygulaması (SPA, istemci taraflı yönlendirme) + LiteSpeed üzerinde çalışan PHP REST API. React ve API aynı alan adında (`dijital.<alanadi>`) barınacağı için CORS yapılandırması gerekmez; mevcut veritabanı ve `deploy/` dağıtım mekanizması korunur. Vite yalnızca derleme aşamasında Node.js gerektirir; üretimde sunucuya yalnızca statik `dist/` çıktısı gider ve sunucuda Node çalışmaz.

- **Kapsam önceliği:** Bu bölüm, aşağıdaki "yalnızca CDN" kısıtının yerini alır. Esas proje Vite + React SPA olarak derlenir; CDN kataloğu HTML tabanlı prototip ve yan projeler için geçerlidir. React SPA'da kütüphaneler npm ile kurulur.
- **Yönlendirme:** LiteSpeed'de `/api/*` PHP'ye, diğer tüm yollar `index.html`'e yönlendirilir (SPA fallback); derin bağlantılar 404 vermez.
- **Güvenlik:** Aynı alan adı CORS'u ortadan kaldırır; CSRF, oturum doğrulama ve girdi doğrulama aynı şekilde zorunludur.
- **Tasarım:** Sayfalar Motion (eski adıyla Framer Motion; React'te `motion/react`) ile yeniden tasarlanacak. Yazılım firması kimliğine uygun olarak her sayfa tipografi, boşluk, hareket eğrisi, responsive kırılım, erişilebilirlik (WCAG) ve performans bütçesi açısından özenle kurgulanacaktır.

## CDN Araç Kataloğu — HTML Projeleri

Aşağıdaki liste, HTML projelerinde doğrudan CDN üzerinden `<script>`, `<script type="module">` veya `<link>` ile çağrılabilen popüler ve kapsamlı araç havuzudur. Katalog bir seçim havuzudur; her proje yalnızca ihtiyaç duyduğu araçları yükler. Üretimde sürümler sabitlenir ve CDN yolları uygulama anında doğrulanır. Bu proje için zorunlu alt küme, aşağıdaki "CDN Kütüphaneleri" bölümünde ayrıca tanımlanmıştır.

**Çatı ve UI altyapısı**
- React + ReactDOM — bileşen tabanlı SPA (ESM/esm.sh; React 19 UMD yayınlamaz)
- Vue 3 — progresif çatı (`<script>` global build)
- Alpine.js — hafif reaktif DOM (`<script defer>`)
- htmx — HTML üzerinden AJAX etkileşimi (`<script>`)
- Preact — hafif React alternatifi (`<script type="module">`)
- jQuery — eski tarayıcı/eklenti uyumu (`<script>`)
- Bootstrap 5 — grid, bileşen, modal (CSS + `<script>` bundle)
- Tailwind CSS Play CDN — hızlı prototip (yalnızca geliştirme; üretimde derlenmiş CSS)
- DaisyUI — Tailwind bileşen katmanı (CSS)
- Bulma — bağımsız CSS çatısı (CSS)

**Hareket ve animasyon**
- Motion (Framer Motion) — React/JS animasyon, layout, gesture (ESM: `https://cdn.jsdelivr.net/npm/motion@latest/react/+esm`)
- GSAP + ScrollTrigger — timeline, scrub, pin (UMD; ScrollTrigger ayrı dosya)
- Lenis — ataletli kaydırma (UMD/ESM)
- Anime.js — hafif timeline animasyonu (UMD)
- AOS — kaydırma ile belirme (UMD + CSS)
- ScrollReveal — görünürlük animasyonu (UMD)
- SplitType — metni harf/kelime bölme (UMD)
- Typed.js — daktilo efekti (UMD)
- AutoAnimate — otomatik liste/geçiş animasyonu (ESM)
- Matter.js — 2B fizik (UMD)
- Lottie Web — After Effects/JSON animasyon (UMD)
- Rive — etkileşimli vektör animasyon (UMD canvas)

**3B ve veri görselleştirme**
- Three.js — WebGL sahne (ESM + import map; yeni sürümlerde UMD yok)
- Babylon.js — tam kapsamlı 3B motor (UMD)
- PixiJS — hızlı 2B WebGL render (UMD)
- p5.js — yaratıcı kodlama (UMD)
- D3.js — veri odaklı SVG (UMD)
- Chart.js — hafif grafik (UMD)
- ApexCharts — dashboard grafikleri (UMD)
- ECharts — büyük veri görselleştirme (UMD)
- Plotly.js — bilimsel grafik (UMD)
- model-viewer — 3B model önizleme (ESM)

**Kaydırma, galeri ve medya**
- Swiper — carousel/slider (UMD + CSS)
- Splide — erişilebilir slider (UMD)
- Embla Carousel — hafif carousel (ESM)
- PhotoSwipe — galeri/lightbox (ESM)
- GLightbox — hafif lightbox (UMD)
- Fancybox — galeri/modal (UMD + CSS)
- Plyr — video/ses oynatıcı (UMD + CSS)
- hls.js — HLS akış (UMD)
- Howler.js — ses yönetimi (UMD)
- Tone.js — Web Audio (UMD)

**Form, etkileşim ve geri bildirim**
- Tippy.js — tooltip/popover (UMD + CSS)
- Floating UI — konumlandırma (UMD)
- SweetAlert2 — modal/onay (UMD)
- Toastify JS — bildirim (UMD + CSS)
- SortableJS — sürükle-bırak sıralama (UMD)
- Choices.js — seçim/etiketleme (UMD + CSS)
- Tom Select — gelişmiş select (UMD + CSS)
- Flatpickr — tarih/saat seçici (UMD + CSS)
- IMask — maskeli girdi (UMD)
- Dropzone — dosya yükleme (UMD + CSS)

**İkon, tipografi ve stil**
- Remix Icon — ikon fontu (CSS)
- Font Awesome — ikon seti (CSS)
- Bootstrap Icons — ikon fontu (CSS)
- Lucide — SVG ikon seti (UMD)
- Google Fonts — font servisi (CSS link)
- Animate.css — hazır CSS animasyonları (CSS)
- Normalize.css — tarayıcı normalizasyonu (CSS)

**Veri ve yardımcı araçlar**
- Axios — HTTP istemcisi (UMD)
- Day.js — tarih/saat (UMD)
- Lodash — koleksiyon/yardımcı (UMD)
- UUID — kimlik üretimi (UMD)
- Marked — Markdown ayrıştırma (UMD)
- DOMPurify — HTML temizleme/XSS koruması (UMD)
- Highlight.js — kod vurgulama (UMD + CSS)
- PapaParse — CSV ayrıştırma (UMD)
- JSZip — ZIP oluşturma/okuma (UMD)
- qrcode — QR üretimi (UMD)
- html2canvas — DOM'u görüntüye çevirme (UMD)
- jsPDF — PDF üretimi (UMD)
- PDF.js — PDF görüntüleme (ESM)
- SheetJS — Excel okuma/yazma (resmî CDN)
- Monaco Editor — kod editörü (AMD loader)
- CodeMirror 5 — hafif kod editörü (UMD + CSS)

```text
Bağlamı gereksiz şişirmeden, odak kaybı olmadan, kararlılığı ve verimliliği olabilecek en üst noktada tutmak için yapılması gerekeni yap.
Bu görev için uygun olan skill, MCP ve plugin araçlarını en etkin şekilde kullan.
```

Sen, ödüllü yaratıcı stüdyoların (Locomotive, Active Theory, Dogstudio) seviyesinde çalışan kıdemli bir Creative Technologist ve WebGL/Frontend Mimarı rolündesin.

Görevin; hayali veya belirtilen bir üst düzey yazılım/teknoloji şirketi için yalnızca CDN bağlantıları kullanarak, doğrudan tarayıcıda çalışan, görsel olarak büyüleyici, sinematik, interaktif ve kurumsal ağırlığı yüksek HTML/CSS/JS projesi oluşturmaktır.

---

- **Kamera ve Katman Hissi (Parallax & Depth):** Sayfa 2B bir doküman gibi değil, derinliği olan 3B bir sahne gibi hissettirmelidir. Arka plan, orta katman ve ön plan farklı hızlarda (scrubbing) hareket etmelidir.
- **Yumuşak Akış (Inertial Scrolling):** Lenis entegre edilerek tarayıcının yerel sert kaydırma mekaniği yerine pürüzsüz, ataletli (smooth momentum) kaydırma sağlanmalıdır. GSAP ScrollTrigger, Lenis `raf` döngüsüne senkronize edilmelidir.
- **Sahne Geçişleri ve Pinning:** Bölümler (Sections) arası geçişlerde ani kaybolma yerine; GSAP ScrollTrigger ile `pin: true` kullanılarak ekran sabitlenmeli, içerikler ölçeklenme (scale), bulanıklaşma (blur), opaklık ve 3D rotasyon (`rotateX/rotateY`) ile sahneyi terk edip yeni sahneye yer açmalıdır.
- **Mikro Etkileşimler ve İmleç:** Özel bir Manyetik İmleç (Custom Fluid/Magnetic Cursor) bulunmalı; butonların, kartların ve interaktif nesnelerin üzerine gelindiğinde genişleyip blending mode (`mix-blend-mode: difference`) ile sinematik tepki vermelidir.
- **Ses ve Ambiyans (Opsiyonel/Kullanıcı Tetiklemeli):** Howler.js ile buton tıklamalarında ve bölüm kilit açılmalarında tok, tiz olmayan, sofistike mikro "haptic" ses efektleri (SFX) çalınabilmelidir (varsayılan sessiz, tek tıkla aktif).

---

Aşağıdaki kütüphaneleri HTML `<head>` veya `<body>` kapanışından hemen önce en güncel stabil CDN linkleriyle (cdnjs/unpkg/jsdelivr) eksiksiz dahil et:

1. **Scroll ve Sinematik Motor:**
   - `Lenis`: Pürüzsüz kaydırma omurgası.
   - `GSAP` + `ScrollTrigger`: Zaman çizelgesi (Timeline), SVG çizimleri ve `scrub: 1` senkronlu geçişler.
   - `SplitType` (veya GSAP tabanlı metin bölme): Başlıkların harf harf veya kelime kelime staggered/maskelenerek yükselmesi için.
2. **3D Arka Plan ve Atmosfer:**
   - `Three.js`: Hero alanında etkileşimli, fare hareketine duyarlı 3B dijital çekirdek/küre, ızgara (cyber grid) veya sinematik parçacık dalgası (wave mesh).
   - `tsParticles`: WebGL haricindeki alt bölümlerde süzülen derinlik hissi veren ortam partikülleri.
3. **Tipografi ve Arayüz:**
   - `Tailwind CSS (Play CDN)`: Hızlı, modern tipografi ve grid düzeni.
   - `Remix Icon` veya `Font Awesome`: Vektörel minimal ikonografi.
   - `Typed.js`: Hero veya terminal alanında dinamik teknoloji yığını çıktıları.
4. **Veri ve Performans Görselleri:**
   - `ApexCharts` veya `Chart.js`: "Performans Analitiği" veya "Sistem Metrikleri" bölümünde koyu tema neon çizgilerle animasyonlu veri grafikleri.
5. **İnteraktif Bileşenler ve Geri Bildirim:**
   - `Swiper.js`: Referanslar ve Vaka Analizleri (Case Studies) için "coverflow" veya 3B kayan kartlar.
   - `SweetAlert2` + `Canvas-Confetti`: İletişim formu başarıyla gönderildiğinde sinematik onay modalı ve kutlama efekti.
   - `Tippy.js`: Metrikler veya mimari şemalar üzerinde modern koyu cam (glassmorphism) tooltip'ler.

---

- **Performans:** Three.js render döngüsü ve GSAP animasyonları tarayıcı yenileme hızına (`requestAnimationFrame`) optimize edilmeli; bellek sızıntılarına (memory leak) karşı olay dinleyiciler düzenli kurulmalıdır.

---

Zen Tasarım Felsefesi Katmanı

Tüm fazlalıkları eleyerek kullanıcının zihnini yormayan; sakin, sezgisel ve işlevsel bir sadelik sunmak — klasik Zen estetiğini modern ve fütüristik tasarım dinamikleriyle birleştirmek.

- **Kanso (Basitlik ve Arılık):** Kullanıcıyı boğan karmaşık menüler, gereksiz görsel sınırlar ve işlevsiz dekoratif süslemeler arayüzden bütünüyle ayıklanır. Tasarım yalnızca doğrudan amaca hizmet eden, sade ve amaca yönelik öğeleri barındırır.
- **Yohaku / Ma (Negatif Alan ve Boşluk):** Ekrandaki boş alanlar pasif bir "boşluk" değil; dikkati doğrudan ana içeriğe yönlendiren, bilişsel yükü hafifleten ve tasarıma fütüristik ferahlık katan bilinçli bir kompozisyon unsurudur.
- **Sezgisellik ve Görünmez Teknoloji:** Kullanıcı herhangi bir kılavuza ihtiyaç duymadan bir sonraki adımı öngörebilmelidir. Arayüz jestleri ve dokunmatik hareketler o kadar doğaldır ki teknoloji kullanıcının önüne geçmez; bağlamı anlayarak arka planda sessizce akar.
- **Hiyerarşi ve Derinlik (Kademeli Odak):** Ekranda aynı anda onlarca düğme yığmak yerine, yalnızca o an ihtiyaç duyulan aksiyon görünür kılınır. İkincil işlevler zarif derinlik katmanları ve kademeli açılmalarla gizlenerek arayüz karmaşası engellenir.
- **Shizen (Doğallık ve Ritim):** Arayüzün tepkileri fiziksel dünyanın kurallarına (yaylanma, eylemsizlik, kütle ve ivmelenme) uyum sağlayarak mekanik hissi ortadan kaldırır. Etkileşimler organik bir akışa kavuşur.