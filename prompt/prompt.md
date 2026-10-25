# Hazır Promptlar

> Kaynak: kullanıcı notu (2026-10-23) — hedef mimari, Motion yeniden tasarımı ve CDN araç kataloğu.
> Kullanım: Konuya uyan bloğu olduğu gibi yapıştır. Ortak kütüphane havuzu için `cdn-katalog.md`.

## 1) Sinematik Kurumsal Site — HTML, Yalnızca CDN

Prototip ve yan projeler içindir; ana proje için 2. blok kullanılır.

```text
Bağlamı gereksiz şişirmeden, odak kaybı olmadan, kararlılığı ve verimliliği olabilecek en üst noktada tut; bu göreve uygun skill, MCP ve plugin araçlarını en etkin şekilde kullan.

Rol: Ödüllü yaratıcı stüdyoların (Locomotive, Active Theory, Dogstudio) seviyesinde kıdemli bir Creative Technologist ve WebGL/Frontend Mimarı.

Görev: Üst düzey bir yazılım/teknoloji şirketi için yalnızca CDN bağlantılarıyla, doğrudan tarayıcıda çalışan; görsel olarak büyüleyici, sinematik, interaktif ve kurumsal ağırlığı yüksek HTML/CSS/JS projesi üret.

Deneyim kuralları (zorunlu):
- Derinlik: Sayfa 2B doküman değil 3B sahne gibi; arka plan, orta katman ve ön plan farklı hızlarda (scrub) paralaks hareket eder.
- Kaydırma: Lenis ile pürüzsüz, ataletli kaydırma; GSAP ScrollTrigger, Lenis raf döngüsüne senkronize edilir.
- Geçişler: Bölümler arası ani kaybolma yok; ScrollTrigger pin: true ile sahne sabitlenir, içerik scale, blur, opacity ve 3B rotasyonla (rotateX/rotateY) sahneyi terk eder.
- İmleç: Manyetik özel imleç; buton, kart ve interaktif nesnelerde genişler, mix-blend-mode: difference ile sinematik tepki verir.
- Ses: Howler.js ile tok, tiz olmayan sofistike mikro SFX; varsayılan sessiz, tek tıkla aktif (kullanıcı tetiklemeli).

Kütüphaneler (<head> ya da </body> kapanışından hemen önce; cdnjs/unpkg/jsdelivr üzerinden güncel stabil sürümlerle eksiksiz):
- Lenis; GSAP + ScrollTrigger (timeline, SVG çizim animasyonları, scrub: 1 senkronlu geçişler); SplitType (başlıklarda harf/kelime stagger ve maskeli yükselme)
- Three.js: hero alanında fare hareketine duyarlı 3B dijital çekirdek/küre, ızgara (cyber grid) ya da sinematik parçacık dalga mesh
- tsParticles: alt bölümlerde süzülen, derinlik hissi veren ortam partikülleri
- Tailwind CSS (Play CDN); Remix Icon ya da Font Awesome; Typed.js (hero/terminal alanında dinamik teknoloji yığını çıktıları)
- ApexCharts ya da Chart.js: "Performans Analitiği / Sistem Metrikleri" bölümünde koyu tema, neon çizgilerle animasyonlu grafikler
- Swiper: referanslar ve vaka analizleri için coverflow ya da 3B kayan kartlar
- SweetAlert2 + Canvas-Confetti: iletişim formu başarıyla gönderildiğinde sinematik onay modalı ve kutlama efekti
- Tippy.js: metrikler ve mimari şemalar üzerinde koyu cam (glassmorphism) tooltip'ler

Tasarım felsefesi — Zen katmanı:
- Kanso: işlevsiz süs, karmaşık menü ve gereksiz görsel sınır yok; yalnızca doğrudan amaca hizmet eden öğe.
- Ma (Yohaku): boşluk pasif değil; dikkati ana içeriğe yönlendiren, bilişsel yükü hafifleten bilinçli kompozisyon.
- Görünmez teknoloji: kılavuz olmadan sonraki adım öngörülür; teknoloji bağlamı anlayarak arka planda sessizce akar.
- Kademeli odak: aynı anda yalnızca gerekli aksiyon görünür; ikincil işlevler zarif derinlik katmanlarına ve kademeli açılımlara gizlenir.
- Shizen: tepkiler yaylanma, eylemsizlik, kütle ve ivmelenme kurallarıyla organik; mekanik his yok.

Performans: render döngüsü ve animasyonlar requestAnimationFrame'a optimize; sayfa/örnek temizliğinde Three.js dispose, ScrollTrigger kill ve olay dinleyici sökümüyle bellek sızıntısı önlenir.

Kabul: Tüm kütüphaneler CDN'den yüklenir (yerel dosya yok); tek HTML dosyasında eksiksiz çalışır; düşük donanımda akıcı, mobil kırılımlarda kompozisyon bozulmaz.
```

## 2) Ana Proje — Vite + React SPA + LiteSpeed PHP API

```text
Ana projeyi şu hedef mimariye göre geliştir:
- Model: Vite ile derlenen React SPA (istemci taraflı yönlendirme) + LiteSpeed üzerinde PHP REST API. Çalışma zamanında Node bağımlılığı yok: Node yalnızca derleme aşamasında, üretime yalnızca statik dist/ çıktısı gider, sunucuda Node çalışmaz.
- Yönlendirme: LiteSpeed'de /api/* PHP'ye, diğer tüm yollar index.html'e (SPA fallback); derin bağlantılar 404 vermez.
- Güvenlik: React ve API aynı alan adında (dijital.<alanadi>), CORS gerekmez. CSRF, oturum doğrulama ve girdi doğrulama zorunludur.
- Süreklilik: Mevcut veritabanı ve deploy/ dağıtım mekanizması korunur; kütüphaneler npm ile kurulur (CDN kullanılmaz).
```

## 3) Sayfa Yeniden Tasarımı — Motion (React)

```text
Bu projenin sayfalarını Motion (eski adıyla Framer Motion; React'te motion/react) ile yeniden tasarla.
Yazılım firması kimliğine uygun olarak her sayfa; tipografi, boşluk, hareket eğrisi, responsive kırılım, erişilebilirlik (WCAG) ve performans bütçesi açısından özenle kurgulanacaktır.
```
