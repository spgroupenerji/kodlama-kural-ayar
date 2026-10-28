# Hazır Promptlar

> Kaynak: kullanıcı notu (2026-10-23). Kullanım: Konuya uyan bloğu olduğu gibi yapıştır; ortak kütüphane havuzu `cdn-katalog.md`.
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
- Stil ve ikon: Tailwind Play CDN + Remix Icon.
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
