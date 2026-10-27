# RUST MASAÜSTÜ — GÖRSEL DİZAYN ANAYASASI

> Kapsam: GPUI Kit ile çizilen Rust masaüstü arayüzlerinin tema, ölçü, bileşen, hareket, erişilebilirlik ve Türkçe metin hükümleri.
> Öncelik: `AGENTS.md` > bu anayasa > proje içi belgeler
> Doğrulama: 2026-10-27 · context7 + resmî belgeler (bkz. Kaynaklar)

## 1. BAĞLAYICILIK
1.1.1. Bu anayasa `AGENTS.md` ana anayasasının altında alan-özgü uzmanlık katmanıdır; çelişkide ana anayasa uygulanır ve bu metin çelişki giderilerek güncellenmek zorundadır.
1.1.2. Kullanıcının yazılı tasarım direktifi bu metne madde olarak eklenmek ve bu anayasa gibi bağlayıcı sayılmak zorundadır.

## 2. TEMA VE RENK
2.1.1. Tüm renk, yarıçap, tipografi ve hareket değerleri `cx.theme()` üzerinden okunur; tema erişimi için `ActiveTheme` trait'i kapsamda tutulmak zorundadır.
2.1.2. Bileşen gövdesinde sabit renk (hex, rgb) ve sabit yarıçap yazmak yasaktır; değerler tema token'ından gelmek zorundadır.
2.1.3. Tema alanı yoksa token ürün temasında tanımlanır; çağrı yerine palet değeri gömmek yasaktır.
2.1.4. Açık ve koyu tema ayrı ayrı doğrulanır; bir temada okunmayan yüzey veya metin yayına giremez.
2.2.1. Durum renkleri tek eşlemeyle kullanılır: başarı emerald/green, uyarı amber/yellow, hata rose/red, bilgi sky/blue; aynı anlam için ikinci renk seçmek yasaktır.
2.2.2. Durum yalnız renkle anlatılamaz; her durum metin ve ikonla da işaretlenmek zorundadır.
2.2.3. Metin kontrastı en az 4,5:1, büyük metin ve arayüz bileşenleri en az 3:1 olmak zorundadır (WCAG 1.4.3, 1.4.11).
2.2.4. Odak halkası yüksek kontrastlı olmak ve odaklanan öğe kısmen de olsa görünür kalmak zorundadır (WCAG 2.4.11).

## 3. ÖLÇÜ, BOŞLUK VE TİPOGRAFİ
3.1.1. Boşluk baremi 4px'tir; `gap_*`, `p_*`, `px_*` ve `py_*` yardımcıları 4'ün katı değerlerle kullanılmak zorundadır.
3.1.2. 4px katı olmayan ara değer yalnız tema token'ında tanımlanabilir; çağrı yerinde serbest piksel değeri yazmak yasaktır.
3.1.3. Buton, girdi ve liste satırlarında dikey dolgu simetrik olmak zorundadır; `pt` ve `pb` asimetrisi yasaktır.
3.1.4. Tipografi ölçeği tema token'larından gelir; metne serbest punto veya `px(...)` ile boyut vermek yasaktır.
3.1.5. Yoğun veri ekranlarında bileşen `Size` API'si kullanılır; yalnız dış kutu yüksekliğini değiştirmek yasaktır.
3.2.1. Yerleşim `h_flex` ve `v_flex` ile kurulur; serbest mutlak konumlandırma yasaktır.
3.2.2. Genişlik ve yükseklik sınırları `min_w_0`, `min_h_0` ve esnek büyüme ile verilir; sabit ölçüde kırpma yasaktır.

## 4. BİLEŞENLER VE İKONLAR
4.1.1. Bileşenler `gpui_kit::component` altından kullanılır; standart kontrolü (buton, girdi, tablo) sıfırdan yazmak yasaktır.
4.1.2. Buton `Button::new(<kimlik>)` ile kurulur; etiket `.label(...)`, ikon `.icon(...)` ve tıklama `.on_click(...)` ile bağlanmak zorundadır.
4.1.3. İkonlar yalnız `Icon::new(IconName::...)` ile kullanılır; tek ikon seti Lucide'dir ve farklı set karıştırmak yasaktır.
4.1.4. Buton varyantları `ButtonVariants` trait'iyle seçilir; bileşenin rengini ve dolgusunu elle geçersiz kılmak yasaktır.
4.2.1. Tıklama hedefi en az 24×24 mantıksal piksel olmak zorundadır; WCAG 2.5.8 istisnasına girmeyen küçük hedef yasaktır.
4.2.2. Kritik eylem hover'a bağlanamaz; klavye ve işaretçiyle erişilebilen görünür eylem olarak sunulmak zorundadır.
4.2.3. Yerel SVG veya ikon fontu eklemek yasaktır; ikon yalnız `gpui-kit-assets` kataloğundan gelmek zorundadır.

## 5. YERLEŞİM VE PENCERE
5.1.1. Pencere asgari boyutu `WindowOptions` ile tanımlanmak ve düzen bu boyuta kadar bozulmadan daralmak zorundadır.
5.1.2. Bölünmüş paneller kullanıcı tarafından yeniden boyutlandırılabilir olmak ve oran oturumlar arasında korunmak zorundadır.
5.1.3. Tehlikeli ve geri alınamaz eylem ayrı vurgu ve onay ister; tek tıkla geri alınamaz silme yasaktır.
5.1.4. Boş, yükleniyor, hata, çevrimdışı ve salt-okunur durumları için tasarlanmış görünüm olmak zorundadır; boş ekran bırakmak yasaktır.
5.2.1. Menü, araç çubuğu ve kısayol etiketleri platform geleneğine uyar; macOS'ta `cmd`, Linux'ta `ctrl` gösterilmek zorundadır.
5.2.2. Uzun açıklama ve yardım metni kırpılmadan okunabilir olmak zorundadır; taşan metni kesip gizlemek yasaktır.

## 6. HAREKET
6.1.1. Hareket yalnız değişimi açıklar; dekoratif ve sürekli otomatik animasyon yasaktır.
6.1.2. Hareket azaltma tercihi (`prefers-reduced-motion` karşılığı) desteklenmek zorundadır; tercih etkinken animasyonlar hedef duruma sıçrar (`cx.set_reduce_motion(true)`).
6.1.3. Animasyon süreleri tema hareket token'larından (`cx.theme().motion_tokens()`) gelmek zorundadır; serbest süre yazmak yasaktır.
6.1.4. Animasyon tamamlandığında yeni kare istemeyi durdurmak zorundadır; boşta kare isteyen animasyon yasaktır.
6.1.5. Animasyon olmadan da her durum anlaşılır olmak zorundadır; anlamayı animasyona bağlamak yasaktır.

## 7. ERİŞİLEBİLİRLİK
7.1.1. WCAG 2.2 AA bu belgenin bağlayıcı erişilebilirlik hedefidir; her ekran klavye ve ekran okuyucuyla kullanılabilir olmak zorundadır.
7.1.2. Yalnız ikon taşıyan her kontrol erişilebilir ad taşımak zorundadır; adsız ikon düğmesi yasaktır.
7.1.3. Pencere yeniden boyutlandırma ve DPI değişiminde düzen bozulmamak ve keskinlik korunmak zorundadır.
7.1.4. Sekme sırası görsel okuma sırasıyla aynı olmak zorundadır; klavye odağı gizlenen veya kaybolan öğe bırakmak yasaktır.

## 8. METİN VE TÜRKÇE İMLÂ
8.1.1. Arayüz metinleri tam Türkçe imlâ ile yazılır; ğ, ü, ş, ı, ö, ç karakterleri eksiksiz kullanılmak zorundadır.
8.1.2. Lorem ipsum, İngilizce kalıntı ve yer tutucu metin yasaktır; her metin gerçek Türkçe içerik olmak zorundadır.
8.1.3. Hata mesajı Türkçe ve eyleme dönük olmak zorundadır; kullanıcıya ne yapacağını söylemeyen mesaj yasaktır.
8.1.4. Sayı, tarih ve para biçimi Türkçe yerelleşir; sabit İngilizce biçim kullanmak yasaktır.

## Kabul kapısı
- [ ] `grep -rnE "#[0-9a-fA-F]{6}|rgb\(" ui/` sabit renk bulmaz.
- [ ] `grep -rn "cx.theme()" ui/` tüm renk kullanımlarının `theme.*` alanlarından geldiğini doğrular.
- [ ] Açık ve koyu temada kontrast ölçümü: metin çiftleri en az 4,5:1, büyük metin ve bileşen kenarlıkları en az 3:1.
- [ ] Klavye ile tüm ekranlar tarandı; her odaklanan öğede görünür odak halkası var ve birincil görev fare olmadan tamamlandı.
- [ ] `grep -rn "IconName::" ui/` tüm ikonların katalogdan geldiğini, `grep -rn "<svg" .` yerel SVG olmadığını doğrular.
- [ ] Hareket azaltma testi: `cx.set_reduce_motion(true)` ile animasyonlar hedef duruma sıçradı.
- [ ] Boş, yükleniyor, hata, çevrimdışı ve salt-okunur durumları gerçek veriyle açıldı ve ekran görüntüsüyle kayda geçti.
- [ ] Metin denetimi: tüm kullanıcı metinlerinde Türkçe karakter ve yerelleşme kontrolü yapıldı.
- [ ] Tıklama hedefleri ölçüldü (en az 24×24 mantıksal piksel) ve WCAG 2.5.8 istisnaları kayda geçti.
- [ ] FPS Monitor ile release derlemesinde animasyonlu ekranın P95 kare süresi kayda geçti.

## Kaynaklar
- <https://gpui-kit.com/docs/design-guides> — tasarım ilkeleri, hareket politikası ve masaüstü varsayılanları.
- <https://gpui-kit.com/docs/style> — `cx.theme()`, `Styled` API'si ve yerleşim yardımcıları.
- <https://gpui-kit.com/docs/assets> — `Icon` ve `IconName`, Lucide kataloğu.
- <https://gpui-kit.com/docs/animation> — hareket azaltma ve tema hareket token'ları.
- <https://gpui-kit.com/docs/accessibility> — AccessKit ve erişilebilir kontrol kontratı.
- <https://www.w3.org/TR/WCAG22/> — 1.4.3, 1.4.11, 2.4.11 ve 2.5.8 eşikleri.
Erişim: 2026-10-27
