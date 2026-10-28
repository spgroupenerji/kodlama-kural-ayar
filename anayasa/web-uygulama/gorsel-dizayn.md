# WEB UYGULAMA — GÖRSEL DİZAYN ANAYASASI

> Kapsam: Oturumlu panel uygulamalarının kalıcı kabuk yerleşimi, tipografi, boşluk, renk, ikon ve bileşen davranışı standartlarını kapsar.
> Öncelik: `AGENTS.md` > bu anayasa > proje içi belgeler
> Doğrulama: 2026-10-27 · context7 + resmî belgeler (bkz. Kaynaklar)

## 1. KAPSAM VE DEĞİŞMEZLER

1.1.1. Bu anayasa; panel, gösterge tablosu, veri tablosu, form, modal ve gezinme yüzeylerinin istisnasız tümünü bağlar, hiçbir yüzey kapsam dışı bırakılamaz.
1.1.2. `AGENTS.md` bu metnin üstündedir; çelişkide Ana Anayasa hükmü uygulanır ve bu metin görsel katmanın uzmanlık belgesidir.
1.1.3. Sabit uygulama hissi zorunludur: kalıcı kabuk (sidebar + üst çubuk + içerik), tek katalogdan gelen menü, sabit bileşen davranışları ve yoğun veri düzeni her sayfada korunur.
1.1.4. WCAG 2.2 AA tüm arayüzlerde bağlayıcı hedeftir; erişilebilirlik gerilemesi tespit edilen sürüm dağıtılamaz.
1.1.5. Kullanıcıya gösterilen her hata Türkçe, eyleme dönük ve alanı işaret eden metindir; iç hata ayrıntısı ve yığın izi arayüze taşınamaz.
1.1.6. Kullanıcının yazılı ve güncel tasarım direktifi bu anayasaya eklenir ve bağlayıcılık kazanır; çelişkide en güncel yazılı onay uygulanır.

## 2. KABUK VE YERLEŞİM

2.1.1. Her sayfa aynı kabuk sırasıyla çizilir: sidebar, üst çubuk, içerik alanı; gezinmede kabuğun konumu ve genişliği değişemez.
2.1.2. Sidebar genişliği ve daraltma davranışı token ile sabitlenir; aynı davranış tüm sayfalarda geçerlidir.
2.1.3. Üst çubuk sabittir ve kullanıcı, bildirim ve oturum eylemlerini taşır; kaydırmada yerinden ayrılamaz.
2.1.4. Kaydırma yalnız içerik alanında gerçekleşir; gövde kaydırması kabuğu yerinden oynatamaz.
2.2.1. İçerik alanı yatayda `max-w-7xl` ile sınırlandırılır, `mx-auto` ile ortalanır ve `px-4 sm:px-6 lg:px-8` nefes payını korur.
2.2.2. Muafiyet yalnız tam ekran harita, tekil topoloji şeması ve yatay kaydırma gerektiren çok kolonlu telemetri tablosudur; bu üç yüzey dışında `w-full` kullanılamaz.
2.2.3. Menü tek katalogdan üretilir; tam olarak bir öğe aktif işaretlenir ve aktiflik renk, ikon ve `aria-current` ile birlikte bildirilir.
2.2.4. Sayfa başına tek `h1` bulunur; başlık seviyeleri atlanamaz ve görsel hiyerarşi başlık yapısıyla tutarlı olmak zorundadır.
2.2.5. Sayfa başlığı, eylem çubuğu ve içerik sırası tüm modüllerde aynıdır; modüle özel yerleşim yalnız katalogda tanımlı istisnayla açılır, keyfi yerleşim yasaktır.

## 3. BOŞLUK, IZGARA VE YOĞUNLUK

3.1.1. Dolgu, kenar payı ve boşluklarda 4px baremi bağlayıcıdır; `p-[7px]`, `gap-[3px]` gibi keyfi piksel değerleri yasaktır.
3.1.2. Dikey dolgu simetriktir (`py-1`, `py-1.5`, `py-2`); `pt-2 pb-3.5` gibi asimetrik dolgu yasaktır.
3.1.3. Veri yoğun yüzeylerde satır yüksekliği token ile sabitlenir ve sayfa türüne göre değişmez.
3.1.4. Sayısal kolonlar `tabular-nums` ile hizalanmak ve sayısal içerik sağa yaslanmak zorundadır.
3.1.5. Bileşenler arası dikey ritim aynı boşluk adımıyla kurulur; kart içi ve kart arası boşluk karıştırılamaz.
3.1.6. Dar ekranda ızgara tek kolona inmek zorundadır ve hiçbir bileşen yatay taşma üretemez.

## 4. TİPOGRAFİ VE RENK

4.1.1. Yazı tipi sistem yığınıdır (`font-sans`); harici font bağlantısı ve gömülü web font yasaktır.
4.1.2. Taban gövde 13/14 px'tir (`text-sm`); bilgi yoğunluğunu azaltmak için `text-base` boyutuna zorlama yasaktır.
4.1.3. Keyfi punto (`text-[6.5px]`, `text-[11px]`) yasaktır; yalnız Tailwind standart ölçeği kullanılır.
4.1.4. Renkler yalnız Tailwind renk ailelerinden seçilir; ham hex, RGB ve keyfi renk değeri yasaktır.
4.1.5. Durum renkleri sabittir: başarı emerald/green, uyarı amber/yellow, hata rose/red, bilgi sky/blue; sayfa bazında keyfi durum rengi seçilemez.
4.1.6. Durum yalnız renkle iletilmez; her durum metin ve ikonla birlikte sunulur.
4.1.7. Metin kontrastı WCAG AA'dır (normal metin 4,5:1, büyük metin 3:1); eşiğin altında kalan renk çifti kullanılamaz.
4.1.8. Odak göstergesi `focus-visible` ile her zeminde görünür kalır; odak halkası kaldırılamaz.

## 5. İKONLAR

5.1.1. Tek ikon kaynağı Lucide 1.61.0 inline SVG sprite'tır; ikinci ikon seti yasaktır.
5.1.2. Çalışma zamanı Iconify API, ikon fontu ve base64 SVG gömme yasaktır.
5.1.3. İkon boyutu metin ölçeğiyle aynı adımdan seçilir; keyfi piksel boyutu yasaktır.
5.1.4. Dekoratif ikon `aria-hidden="true"` taşır; anlam taşıyan ikon erişilebilir adla eşleştirilir.
5.1.5. Yalnız ikon içeren buton erişilebilir ad taşımak zorundadır; adsız ikon butonu yayınlanamaz.
5.1.6. Kodla üretilen dinamik vektörel grafikler (akış şeması, topoloji) ikon kuralından muaftır.

## 6. BİLEŞEN DAVRANIŞLARI

6.1.1. Aynı bileşen aynı davranışı gösterir: buton, tablo, form, modal ve bildirim davranışı sayfaya göre değiştirilemez.
6.1.2. Her liste ve tablo yükleniyor, boş, hata ve dolu durumlarının dördünü de tanımlamak zorundadır; tanımsız durum bırakılamaz.
6.1.3. Modal odak tuzağı kurmak, ESC ile kapanmak ve kapanınca odağı tetikleyiciye geri vermek zorundadır.
6.1.4. Form alanı etiketiyle bağlıdır; hata metni alanla `aria-describedby` üzerinden ilişkilendirilir.
6.1.5. Tablo başlıkları `th` ve `scope` ile tanımlanır; sıralama durumu `aria-sort` ile bildirilir.
6.1.6. Aktif ve pasif durumlar Tailwind sınıf değişimiyle yönetilir; elle yazılmış özel durum sınıfı yasaktır.
6.1.7. Yıkıcı eylem onay modalı ister; geri alınamaz eylemde sonuç açıkça yazılır ve Türkçe metinle onay alınır.
6.1.8. Boş durum açıklama ve tek eylem önerisi taşımak zorundadır; yalnız "kayıt yok" metni yayınlanamaz.
6.1.9. Uzun metin, URL ve sayı taşması `break-words` ve gerekli kırpma ile karşılanmak zorundadır; taşan hücre yayınlanamaz.

## 7. HAREKET VE ERİŞİLEBİRLİK

7.1.1. Hareket yalnız anlam taşıdığında kullanılır; dekoratif, sürekli veya dikkat çeken animasyon yasaktır.
7.1.2. `prefers-reduced-motion: reduce` desteği zorunludur; bu tercihte hareket ve geçişler kapatılır.
7.1.3. Odak sırası DOM sırasını izler; programatik odak yalnız modal ve bildirim gibi tanımlı durumlarda taşınır.
7.1.4. Etkileşim hedefleri en az 24x24 CSS piksel boyutunda olmak zorundadır (WCAG 2.2 Başarı Ölçütü 2.5.8).
7.1.5. 320 CSS piksel genişlikte içerik yatay gövde kaydırması olmadan kullanılabilir olmak zorundadır (WCAG 1.4.10 yeniden akış).
7.1.6. Yapışkan üst çubuk ve sidebar klavye odağını örtemez (WCAG 2.4.11).
7.1.7. Tüm etkileşimler klavyeyle tamamlanabilir; yalnız fare veya yalnız dokunmayla erişilen işlev yasaktır.
7.1.8. Görsel ve bileşenler yüklenirken yer ayırır; görsel kayması CLS 0,1 eşiğini aşamaz ve LCP görseli öncelikli yüklenir.

## 8. GÖRSEL TESLİM VE KOD KURALI

8.1.1. Stiller yalnız CDN'deki Tailwind tarayıcı motoru (`@tailwindcss/browser@4.3.3`) ve `text/tailwindcss` bloğundaki `@theme` tokenlarından gelir; derleme adımı yoktur, depoda CSS dosyası tutulmaz.
8.1.2. Satır içi `style` yasaktır; istisna yalnız JavaScript'in hesapladığı dinamik koordinat ve ölçülerdir.
8.1.3. Elle yazılmış ikinci stil dosyası ve ham CSS sınıfı yasaktır; stil `@theme` tokenları ve Tailwind utility sınıflarıyla tanımlanır.
8.1.4. JavaScript ile üretilen DOM'da görsel özellik sınıf atamasıyla verilir; `innerHTML` ile stil enjekte edilemez.
8.1.5. Görsel varlıklar kendi alan adımızdan sabit sürümle servis edilir; Tailwind tarayıcı motoru dışında harici varlık CDN'i yasaktır.
8.1.6. Sayfa şablonlarında serbest `<style>` bloğu yasaktır; yalnız `type="text/tailwindcss"` bloğu ve dinamik hesaplama gerektiren SVG çizimi bu kuraldan muaftır.
8.1.7. Sunucu taraflı PDF ve e-posta çıktı şablonları satır içi stil kuralından muaftır; bu istisna yalnız çıktı üreten şablon dosyalarını kapsar.
8.1.8. Leaflet, Chart.js ve Three.js gibi tuval tabanlı kütüphanelerin zorunlu varlıkları ve render işlemleri satır içi stil kuralından muaftır.

## Kabul kapısı

- [ ] `grep -R 'style=' --include='*.php' --include='*.html' .` yalnız dinamik koordinat/ölçü satırlarını döner.
- [ ] `grep -R -E '(bg|text|border)-\[#|text-\[[0-9]|(p|px|py|gap)-\[[0-9]' --include='*.php' --include='*.html' .` hiçbir eşleşme üretmez.
- [ ] `grep -R -E 'cdn\.|fonts\.google|iconify' --include='*.php' --include='*.html' --include='*.css' .` yalnız Tailwind'in sabitlenmiş jsDelivr satırını döner.
- [ ] `grep -R -E 'motion-reduce:|prefers-reduced-motion' --include='*.php' --include='*.html' .` en az bir eşleşme döner; DevTools reduced-motion emülasyonunda hareket durur.
- [ ] `grep -R '<symbol' assets/` en az bir eşleşme döner; ikon sprite'ı tek kaynaktan gelir.
- [ ] `grep -R 'aria-current' sidebar/` aktif menü işaretini doğrular; `grep -c 'aria-current' sidebar/` değeri 1'dir.
- [ ] Üç farklı modül sayfasının HTML çıktısında sidebar, üst çubuk ve `<main>` aynı sırayla bulunur.
- [ ] Chrome DevTools mobil görünümde 320 px genişlikte yatay gövde kaydırması yoktur.
- [ ] axe DevTools veya Lighthouse erişilebilirlik denetiminde WCAG 2.2 AA ihlali bulunmaz.
- [ ] Metin kontrastı ölçümünde 4,5:1 altında kalan metin/ikon çifti yoktur.
- [ ] Chrome DevTools klavye turunda odak tuzağı yalnız modaldadır, ESC ile kapanır ve odak tetikleyiciye döner.
- [ ] CLS ≤ 0,1 ve LCP p75 ≤ 2,5 s ölçüm kayıtları `docs/` altında mevcuttur.

## Kaynaklar

1. Tailwind CSS tarayıcı sürümü (`@tailwindcss/browser`) — https://www.npmjs.com/package/@tailwindcss/browser
2. Lucide SVG sprite — https://lucide.dev/guide/static/svg-sprite
3. WCAG 2.2 (W3C Recommendation, 12 Aralık 2024) — https://www.w3.org/TR/WCAG22/
4. Çekirdek Web Vitals eşikleri — https://web.dev/articles/vitals
5. `prefers-reduced-motion` — https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion

Erişim: 2026-10-27
