# CDN Araç Kataloğu — HTML Projeleri

> Kaynak: kullanıcı notu (2026-10-23).
> Kapsam: Esas proje Vite + React SPA olarak derlenir ve kütüphanelerini npm ile kurar; bu katalog HTML tabanlı prototip ve yan projeler içindir (bkz. `prompt.md`, 2. blok). Katalog bir seçim havuzudur; her proje yalnızca ihtiyaç duyduğu araçları yükler. Üretimde sürümler sabitlenir ve CDN yolları uygulama anında doğrulanır.

**Çatı ve UI altyapısı**
- React + ReactDOM — bileşen tabanlı SPA (ESM/esm.sh; React 19 UMD yayınlamaz)
- Vue 3 — progresif çatı (`<script>` global build)
- Alpine.js — hafif reaktif DOM (`<script defer>`)
- htmx — HTML üzerinden AJAX etkileşimi (`<script>`)
- Preact — hafif React alternatifi (`<script type="module">`)
- jQuery — eski tarayıcı/eklenti uyumu (`<script>`)
- Bootstrap 5 — grid, bileşen, modal (CSS + `<script>` bundle)
- Tailwind CSS tarayıcı sürümü (`@tailwindcss/browser@4.3.3`) — CDN'den çalışır, derleme adımı yoktur; tema `@theme` bloğuyla verilir (tam sürüm + SRI sabitlenir)
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
