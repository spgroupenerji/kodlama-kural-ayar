# WEB SİTESİ — GÖRSEL DİZAYN ANAYASASI

> Kapsam: Herkese açık tanıtım sitesinin sayfa kompozisyonu, tasarım token'ları, tipografi, renk, ikon, hareket ve performans bütçesi.
> Öncelik: `AGENTS.md` > bu anayasa > proje içi belgeler
> Doğrulama: 2026-10-28 · Context7 + resmî Iconify belgeleri (bkz. Kaynaklar)

## 1. TASARIM ÖZGÜRLÜĞÜ VE MARKA ÇEKİRDEĞİ

1.1.1. Her sayfa kendi özgün kompozisyonunu kurabilir; sayfa başına sabit şablon zorunlu değildir.
1.2.1. Sabit olan marka çekirdeği tasarım token'ları, tipografi ölçeği, durum renkleri, erişilebilirlik ve performans bütçesidir; çekirdek dışına çıkan sayfa kabul edilmez.
1.3.1. Sayfa özgürlüğü marka çekirdeğini, WCAG 2.2 AA uyumunu veya performans bütçesini gerekçe göstererek bozamaz.
1.4.1. Yeni tasarım deseni yalnız mevcut token'larla ifade edilebiliyorsa kullanılabilir; token'a çevrilemeyen tek seferlik stil yasaktır.

## 2. TASARIM TOKEN'LARI VE STİL KAYNAĞI

2.1.1. Tüm renk, boşluk, tipografi ve gölge değerleri `:root` altında CSS değişkeni olarak tanımlanır; token dışında ham değer kullanımı yasaktır.
2.2.1. Tek stil kaynağı `assets/css/site.css` dosyasıdır; üçüncü taraf CSS, `<style>` bloğu ve `@import` yasaktır.
2.3.1. Satır içi `style` yalnız çalışma zamanında hesaplanan koordinat, yüzde veya SVG değerleri için kullanılabilir; statik düzen için yasaktır.
2.4.1. Renkler işaretlemede ham hex kodu olarak yer alamaz; yalnız token değişkenine başvurulur.
2.5.1. Kullanılmayan token ve ölü CSS kuralı bırakılamaz; stil dosyası her sürümde yalnız kullanılan kuralları içerir.

## 3. BOŞLUK BAREMİ

3.1.1. Tüm dolgu, kenar boşluğu ve eleman aralığı 4 piksel bareminin tam katı olmak zorundadır.
3.2.1. 4 pikselin katı olmayan keyfi değer (ör. 5px, 7px, 13px) yasaktır ve değer en yakın barem adımına yuvarlanır.
3.3.1. Buton, form alanı ve liste satırlarında dikey dolgu simetrik olmak zorundadır.
3.4.1. Boşluk token'ları adlandırılmış ölçek olarak tanımlanır; bileşen içinde hesaplanmış ara değer üretilemez.

## 4. TİPOGRAFİ

4.1.1. Varsayılan tipografi sistem font yığınıdır ve marka fontu zorunlu değildir.
4.2.1. Tek marka fontu kullanılabilir; birden fazla web font ailesi yasaktır.
4.3.1. Tipografi ölçeği token olarak tanımlanır ve sayfa içinde ölçek dışı yazı boyutu kullanılamaz.
4.4.1. Gövde metni kök yazı boyutunun (1rem) altına inemez; küçük boyut yalnız yardımcı etiketlerde kullanılır.
4.5.1. Metin %200 yakınlaştırmada ve WCAG 1.4.12 metin aralığı değerlerinde taşmadan okunabilmelidir.

## 5. RENK VE DURUM SEMANTİĞİ

5.1.1. Durum renkleri sabittir ve değiştirilemez: başarı emerald/green, uyarı amber/yellow, hata rose/red, bilgi sky/blue.
5.2.1. Bu semantik eşleme dışında durum rengi seçilemez; sayfa veya bileşen bazında renk sapması yasaktır.
5.3.1. Metin kontrastı WCAG 2.2 AA eşiğini (normal metinde 4.5:1, büyük metinde 3:1) sağlamak zorundadır.
5.4.1. Arayüz bileşeni ve grafik kontrastı en az 3:1 olmak zorundadır (WCAG 1.4.11).
5.5.1. Renk tek başına durum veya anlam taşıyamaz; durum her zaman metin veya ikonla birlikte gösterilir.

## 6. İKONLAR

6.1.1. Tek yetkili ikon sağlayıcı: Iconify Web Component (`<iconify-icon>`) altyapısıdır; başka ikon sağlayıcısı kullanılamaz.
6.1.2. Proje genelinde görsel tutarlılık için tek ikon seti öneki kullanılır: `lucide:`. Farklı ikon setlerinin aynı projede kontrolsüzce harmanlanması yasaktır.
6.1.3. Yükleyici 3.0.4 sürümüne sabitlenir ve `https://code.iconify.design/iconify-icon/3.0.4/iconify-icon.min.js` adresinden `integrity` (SRI) ile `crossorigin="anonymous"` taşıyarak yüklenir.
6.2.1. İkonlar istemci çalışma anında doğrudan resmî Iconify API'sinden (`https://api.iconify.design`) çekilir ve tarayıcı yerel önbelleğinde saklanır; API yanıtları `immutable` önbellekle döner.
6.2.2. Yerel SVG dosyası barındırmak, ikon fontu yüklemek, SVG sprite kurmak veya stillere base64 SVG gömmek yasaktır; ilk yüklemedeki ağ gecikmesi kabul edilir.
6.2.3. Kod tarafından anlık üretilen dinamik vektörel grafikler (pvsGrafik, akış şemaları, matematiksel algoritma çıktıları) ikon kısıtlamasından muaftır.
6.3.1. Arayüzde hiçbir bağlamda emoji karakteri kullanılamaz; her emoji anlamına en uygun `lucide:` ikonu ile değiştirilir; ikonun işlenemediği metin bağlamlarında (form seçenekleri, onay iletileri) emoji tamamen kaldırılır.
6.4.1. Anlam taşıyan her ikon erişilebilir ada sahip olmak zorundadır; süsleme ikonları ise `aria-hidden="true"` taşımak zorundadır.

## 7. BİLEŞEN, ODAK VE ERİŞİLEBİLİRLİK

7.1.1. Her etkileşimli öğe klavyeyle erişilebilir olmak ve görünür odak göstergesi taşımak zorundadır.
7.2.1. Dokunma hedefleri en az 24×24 CSS piksel olmak zorundadır (WCAG 2.5.8).
7.3.1. Form alanları görünür etiket taşır ve hata mesajı alanın yanında Türkçe ve eyleme dönük gösterilir.
7.4.1. Sabit yükseklikle kilitlenen metin kutusu yasaktır; içerik veya yazı boyutu büyüdüğünde düzen kırılamaz.
7.5.1. Hata özeti sayfa başında odaklanabilir olmak ve ilgili alanlarla programatik bağ taşımak zorundadır.

## 8. HAREKET VE PREFERS-REDUCED-MOTION

8.1.1. Animasyon yalnız `transform` ve `opacity` özelliklerini değiştirebilir; layout tetikleyen özellik animasyonu yasaktır.
8.2.1. `prefers-reduced-motion: reduce` tercihinde otomatik oynatma, paralaks ve geçiş animasyonları devre dışı bırakılmak zorundadır.
8.3.1. Hareket kullanıcı girdisini geciktiremez ve odak kaybına yol açamaz.
8.4.1. Video ve hareketli arka plan için kullanıcıya duraklatma denetimi sunulmak zorundadır.

## 9. PERFORMANS BÜTÇESİ VE TESLİM

9.1.1. Sayfa başına JavaScript bütçesi mimari anayasasındaki 30 KB gzip sınırıdır ve bu bütçe sayfa kompozisyonu özgürlüğünden bağımsız bağlayıcıdır.
9.2.1. Core Web Vitals eşikleri (LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1) tasarım kararlarını sınırlar ve eşiği aşan tasarım kabul edilmez.
9.3.1. LCP görseli her sayfa için tasarım aşamasında belirlenir, `fetchpriority="high"` ve `preload` ile işaretlenir ve ilk görünümde `lazy` olamaz.
9.4.1. Görsel bütçesi aşıldığında dekoratif görsel kaldırılır; LCP görseli küçültme yerine kompozisyon sadeleştirilir.

## 10. DOĞRULAMA ZORUNLULUĞU

10.1.1. Başta Iconify Web Component bileşen tanımları olmak üzere, mimaride kullanılan tüm yöntem ve sürümler Context7 üzerinden doğrulanmadan kullanılamaz; doğrulama kaynağı ve tarihi belge başlığına yazılır.

## Kabul kapısı

- [ ] `grep -RE "#[0-9a-fA-F]{3,8}" assets/css/site.css` yalnız `:root` token tanımlarında eşleşir.
- [ ] `grep -RE 'style="[^"]*(display|margin|padding)' .` boştur; statik satır içi stil yoktur.
- [ ] `grep -R "@media (prefers-reduced-motion" assets/css/site.css` eşleşme verir ve DevTools emülasyonunda video ile paralaks durur.
- [ ] `grep -R "<iconify-icon" --include='*.php' --include='*.html' .` en az bir eşleşme döner; tüm ikonlar Iconify Web Component ile basılır.
- [ ] `grep -R -E "font-awesome|bootstrap-icons|<symbol|base64,|data:image/svg" --include='*.php' --include='*.html' .` boştur; yerel SVG, sprite, ikon fontu ve base64 gömme yoktur (dinamik grafik muafiyeti hariç).
- [ ] `grep -R "icon=\"" --include='*.php' --include='*.html' . | grep -v "lucide:"` boştur ve `grep -R -P "[\x{1F300}-\x{1FAFF}\x{2600}-\x{27BF}]" --include='*.php' --include='*.html' .` emoji döndürmez.
- [ ] CSS'teki tüm `px` boşluk değerleri 4'ün katıdır ve dikey dolgular simetriktir.
- [ ] axe veya Lighthouse erişilebilirlik denetiminde kritik ihlal yoktur; kontrast 4.5:1 ve 3:1 ölçümü doğrulanmıştır.
- [ ] Klavye ile tüm etkileşimler tamamlanır, odak görünürdür ve hedef boyut ≥ 24×24 CSS pikseldir.
- [ ] Metin %200 yakınlaştırmada ve WCAG 1.4.12 aralıklarında taşmaz.
- [ ] Mobil Lighthouse: LCP ≤ 2.5 s, CLS ≤ 0.1, INP alan verisi p75 ≤ 200 ms ve sayfa başına JS ≤ 30 KB gzip'tir.

## Kaynaklar

1. https://www.w3.org/TR/WCAG22/ — kontrast, hedef boyut, odak, metin aralığı ve hareket başarı ölçütleri.
2. https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion — hareket azaltma tercihi.
3. https://iconify.design/docs/iconify-icon/ — Iconify Web Component kurulumu, `icon` niteliği ve boyutlandırma.
4. https://iconify.design/docs/api/ — resmî Iconify API; `Cache-Control: public, max-age=604800, immutable` (2026-10-28 doğrulandı).
5. https://registry.npmjs.org/iconify-icon/3.0.4 — sabitlenen yükleyici sürümü (gzip 8 190 bayt, SHA-384 SRI hesaplandı).
6. https://web.dev/articles/vitals — LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1 (p75) eşikleri.
7. https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html — 24×24 CSS piksel hedef boyutu.

Erişim: 2026-10-28
