Promptlar

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