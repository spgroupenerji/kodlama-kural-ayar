# WEB SİTESİ — GÖRSEL DİZAYN ANAYASASI

> Kapsam: Herkese açık tanıtım sitesinin sayfa kompozisyonu, tasarım token'ları, tipografi, renk, ikon, hareket ve performans bütçesi.
> Öncelik: `AGENTS.md` > bu anayasa > proje içi belgeler
> Doğrulama: 2026-10-27 · context7 + resmî belgeler (bkz. Kaynaklar)

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

6.1.1. Tek ikon seti Lucide'dır ve sürüm 1.61.0 olarak sabitlenir; farklı ikon seti, ikon fontu veya karışık set yasaktır.
6.2.1. İkonlar satır içi SVG olarak tek kaynaktan üretilir; CDN, ikon fontu ve base64 SVG gömme yasaktır.
6.3.1. İkon boyutu 24×24 piksel ve çizgi kalınlığı 2 piksel varsayılanıyla kullanılır; sapma token ile gerekçelendirilmelidir.
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

## Kabul kapısı

- [ ] `grep -RE "#[0-9a-fA-F]{3,8}" assets/css/site.css` yalnız `:root` token tanımlarında eşleşir.
- [ ] `grep -RE 'style="[^"]*(display|margin|padding)' .` boştur; statik satır içi stil yoktur.
- [ ] `grep -R "@media (prefers-reduced-motion" assets/css/site.css` eşleşme verir ve DevTools emülasyonunda video ile paralaks durur.
- [ ] `grep -R "font-awesome|iconify|bootstrap-icons" .` boştur ve tüm ikonlar Lucide satır içi SVG'dir.
- [ ] CSS'teki tüm `px` boşluk değerleri 4'ün katıdır ve dikey dolgular simetriktir.
- [ ] axe veya Lighthouse erişilebilirlik denetiminde kritik ihlal yoktur; kontrast 4.5:1 ve 3:1 ölçümü doğrulanmıştır.
- [ ] Klavye ile tüm etkileşimler tamamlanır, odak görünürdür ve hedef boyut ≥ 24×24 CSS pikseldir.
- [ ] Metin %200 yakınlaştırmada ve WCAG 1.4.12 aralıklarında taşmaz.
- [ ] Mobil Lighthouse: LCP ≤ 2.5 s, CLS ≤ 0.1, INP alan verisi p75 ≤ 200 ms ve sayfa başına JS ≤ 30 KB gzip'tir.

## Kaynaklar

1. https://www.w3.org/TR/WCAG22/ — kontrast, hedef boyut, odak, metin aralığı ve hareket başarı ölçütleri.
2. https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion — hareket azaltma tercihi.
3. https://lucide.dev/ — Lucide ikon seti, 24 px boyut ve 2 px çizgi varsayılanı.
4. https://registry.npmjs.org/lucide/1.61.0 — sabitlenen Lucide sürümü (npm latest, deprecated değil).
5. https://web.dev/articles/vitals — LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1 (p75) eşikleri.
6. https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html — 24×24 CSS piksel hedef boyutu.

Erişim: 2026-10-27
