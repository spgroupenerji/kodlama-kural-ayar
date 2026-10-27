# RUST MASAÜSTÜ — MİMARİ ANAYASASI

> Kapsam: Rust ve GPUI Kit ile geliştirilen masaüstü uygulamalarının bağımlılık, katman, eşzamanlılık, masaüstü davranışı, erişilebilirlik, performans ve paketleme hükümleri.
> Öncelik: `AGENTS.md` > bu anayasa > proje içi belgeler
> Doğrulama: 2026-10-27 · context7 + resmî belgeler (bkz. Kaynaklar)

## 1. BAĞLAYICILIK VE KATMAN SINIRI
1.1.1. Bu anayasa, `AGENTS.md` ana anayasasına bağlı alan-özgü uzmanlık katmanıdır; çelişkide ana anayasa uygulanır ve bu metin çelişki giderilerek güncellenmek zorundadır.
1.1.2. Kullanıcının yazılı mimari direktifi bu metne madde olarak eklenmek ve bu anayasa gibi bağlayıcı sayılmak zorundadır.
1.2.1. Uygulama `ui/`, `domain/` ve `depo/` modüllerine ayrılır; `ui/` altında SQL, ağ çağrısı ve dosya yazma işlemi bulunamaz, bulunduğu değişiklik birleştirilemez.
1.2.2. `render` gövdesinde iş kuralı, doğrulama veya veri dönüşümü yürütmek yasaktır; render yalnız `Entity` durumunu çizer.
1.2.3. `domain/` hiçbir arayüz tipini (`gpui`, `gpui_kit`) içe aktaramaz; alan mantığı arayüzden bağımsız ve test edilebilir olmak zorundadır.
1.3.1. Katmanlar arası veri tipli `struct` ve `enum` ile taşınır; global mutable durum (`static mut`, kilitsiz `static`) yasaktır.
1.3.2. Sistem sınırından (dosya, kullanıcı girdisi, kanal) giren veri tipli modele çözülüp doğrulanmadan iç katmana aktarılamaz.
1.3.3. Modül genel API'lerinde parametre ve dönüş tipleri açıkça yazılır; tipi gizleyen `Box<dyn Any>` kaçışı yasaktır.

## 2. BAĞIMLILIK VE SÜRÜM SABİTLEME
2.1.1. Arayüz bağımlılığı `gpui-kit = "=0.8.1"` (Apache-2.0) paketiyle sınırlıdır; ikinci bir arayüz paketi eklemek yasaktır.
2.1.2. Ayrıca `gpui` paketi veya başka bir GPUI çatalı eklemek yasaktır; GPUI yalnız `gpui_kit::*` yeniden dışa aktarımıyla kullanılır.
2.2.1. Varsayılan arka uç `gpui-pre` 0.3.10'dur (Apache-2.0); başka sürüm kullanmak yasaktır ve yükseltme yalnız `gpui-kit` sürüm yükseltmesiyle ve doğrulanmış uyumluluk kaydıyla yapılabilir.
2.2.2. `gpui-component` 0.8.1 ve `gpui-kit-assets` 0.8.1 sürümleri `gpui-kit` varsayılan `component` ve `assets` özelliklerinden gelir; ayrıca bağımlılık olarak eklenmeleri yasaktır.
2.2.3. GPUI Fast 0.1.12 yalnız ölçülmüş kazanç ve yazılı gerekçeyle `features = ["gpui-fast"]` üzerinden etkinleştirilebilir; gerekçesiz kullanım yasaktır.
2.3.1. WebView, gömülü tarayıcı motoru ve JavaScript köprüsü eklemek yasaktır; arayüz yalnız yerel GPUI çizimiyle üretilir.
2.3.2. Yeni bağımlılık yalnız MIT veya Apache-2.0 lisanslıysa eklenebilir; atıf şartı koşan lisans (ör. Slint Royalty-free) yasaktır.
2.3.3. Her yeni bağımlılık, gerekçesi ve lisans sonucuyla birlikte inceleme kaydında bildirilmeden kullanılamaz.
2.4.1. Tüm sürümler tam numarayla sabitlenir ve `Cargo.lock` commit edilir; `*` joker sürüm ve kilit dosyasız derleme yasaktır.
2.4.2. Doğrulanmamış API üretime giremez; her dış API çağrısı sürümlü belge veya crate kaynağıyla doğrulanıp incelemede kaynağıyla gösterilmek zorundadır.

## 3. ARAÇ ZİNCİRİ VE PLATFORMLAR
3.1.1. Asgari araç zinciri Rust 1.92'dir; Linux GPUI platform bağımlılığı `oo7 0.6.0` bu alt sınırı zorunlu kılar ve daha eski sürümle derleme reddedilir.
3.2.1. Birincil hedefler macOS 15+ ve Linux'tur (Wayland ve X11); Windows ikincil hedeftir ve birincil hedeflerin davranışını değiştiren Windows-özel dal eklemek yasaktır.
3.2.2. Linux'ta çalışan bir Vulkan sürücüsü zorunludur; yalnız `libvulkan1` paketini kurup sürücüyü atlamak yasaktır.
3.2.3. macOS geliştirme ortamında Xcode Command Line Tools kurulu olmak zorundadır; eksik araç zinciriyle derleme yapılamaz.
3.3.1. CI `macos-latest` ve `ubuntu-latest` matrisinde `fail-fast: false` ile çalışır; bir işin hatası diğer işi iptal edemez.
3.3.2. Linux işi kurulum belgesindeki Ubuntu 24.04 sistem paketlerini kurmak zorundadır; eksik sistem bağımlılığıyla yeşil sonuç kabul edilmez.
3.3.3. Doğrulama komutları `cargo build --release --locked` ve `cargo test --locked`'tır; bu iki komut geçmeden artefakt üretilemez.
3.3.4. `cargo fmt --check` ve `cargo clippy -- -D warnings` temiz değilse birleştirme yapılamaz.
3.4.1. Uygulama `gpui_kit::application().run` içinde önce `gpui_kit::init(cx)` çağrılarak ve `open_window(WindowOptions, ...)` ile açılır; pencere içeriği `Render` uygulayan tek kök tip olmak ve `cx.new(...)` ile oluşturulmak zorundadır.
3.4.2. Pencere açılamazsa uygulama açık Türkçe hata mesajıyla sıfır dışı kodla kapanır; hata sessizce yutulamaz.

## 4. EŞZAMANLILIK VE YÜRÜTME MODELİ
4.1.1. UI iş parçacığında veritabanı, ağ ve senkron dosya G/Ç işlemi yapmak yasaktır; bu işler GPUI `BackgroundExecutor` üzerinde yürütülür.
4.1.2. UI ile arka plan arasındaki veri yalnız sınırlı kapasiteli kanallarla taşınır; sınırsız kuyruk ve tampon yasaktır.
4.1.3. Kuyruk dolduğunda üretici bekletilir ve geri basınç uygulanır; veri kaybı sessizce kabul edilemez.
4.2.1. UI durumunu yalnız UI tarafındaki `Entity` günceller; arka plan görevi sonucu mesajla iletmek zorundadır ve UI durumuna doğrudan yazamaz.
4.2.2. Her arka plan görevi pencere kapanışında iptal edilir; sahipsiz görev bırakmak ve kapanmış pencereye güncelleme yapmak yasaktır.
4.2.3. Aynı anda yürüyen görev sayısı sabit bir üst sınırla sınırlanır; sınırsız görev üretimi yasaktır.
4.3.1. Dış çağrılar (ağ, dosya, alt süreç) katı zaman aşımıyla sınırlanır; zaman aşımı koruması olmayan çağrı üretim kodunda yer alamaz.
4.3.2. Yeniden deneme yalnız üst sınır, üstel geri çekilme ve rastgele sapma ile yapılır; sınırsız deneme ve deneme fırtınası yasaktır.
4.3.3. Sürekli başarısız dış bağımlılık devre kesiciyle kapatılır; arızayı gizleyen sonsuz yeniden deneme yasaktır.
4.3.4. Uzun süren işlem ilerleme ve iptal kontrolü sunmak zorundadır; kilit yalnız en küçük kritik kesitte tutulur.

## 5. HATA, GİZLİLİK VE LOGLAMA
5.1.1. Kullanıcıya gösterilen hata mesajı Türkçe ve eyleme dönüktür; istemciye stack trace, dosya yolu, SQL veya sürücü ayrıntısı gösterilemez.
5.1.2. Hata `Result` ile taşınır; boş hata dalı ve hatayı yutan blok yasaktır.
5.1.3. `unwrap()` üretim yolunda yasaktır; `expect()` yalnız başlangıçta değişmez kabul edilen ve Türkçe gerekçe metni taşıyan çağrılarda kullanılabilir.
5.1.4. Alan hataları ile sistem hataları ayrı `enum` tipleriyle modellenmek zorundadır; ikisi de maskelenmez, uygun katmanda ele alınır.
5.2.1. Sırlar yalnız `.env` veya secret manager'dan okunur; kod, depo ve derleme çıktısına gömme yasaktır.
5.2.2. Loglarda parola, token ve kişisel veri `[MASKE]` ile maskelenir; ham değer yazmak yasaktır.
5.2.3. Loglar yapısal üretilir (düzey, zaman, modül, olay); metin birleştirmeyle log yazmak yasaktır.

## 6. MASAÜSTÜ DAVRANIŞI
6.1.1. Pencere boyutu, konumu ve bölünme oranları oturumlar arasında saklanmak ve açılışta geri yüklenmek zorundadır.
6.1.2. Her birincil komutun klavye kısayolu vardır ve menüde ya da araç ipucunda görünür; yalnız fareyle erişilebilen komut yasaktır.
6.1.3. Kısayol platform farkı `cx.platform_info().is_mac()` ile çözülür; her platforma `ctrl` varsaymak yasaktır.
6.1.4. Her etkileşimli bölgenin görünür odak halkası vardır; modal veya pencere kapandığında odak mantıklı öğeye dönmek zorundadır.
6.2.1. Metin düzenlenen her alanda geri al ve ileri al çalışmak zorundadır; platform kısayollarıyla uyumsuz eşleme yasaktır.
6.2.2. Dosya seçimi ve kaydetme yerel platform diyaloglarıyla yapılır; özel dosya tarayıcısı yazmak yasaktır.
6.2.3. Kaydedilmemiş değişiklik varken kapatma isteği Türkçe onay sormak zorundadır; sessiz veri kaybı yasaktır.
6.3.1. Ağ yokken uygulama yerel işlevlerini sürdürür; ağ bağımlı özellik pasifleşir ve çökme yasaktır.

## 7. PAKETLEME VE SÜRÜM DAMGASI
7.1.1. Her derleme tek damga üretir: yerel saatle `vYYYYMMDDHHMM`; ikinci damga üretmek yasaktır.
7.1.2. Aynı damga hem artefakt adında hem Hakkında penceresindeki sürüm bilgisinde görünmek zorundadır.
7.1.3. Artefakt adı `release/${APP_AD}_beta-<damga>` biçimindedir ve `release/` içinde tam olarak bir dosya kalır; ikinci dosya bırakılamaz.
7.1.4. Yeni artefakt önce geçici ada kopyalanır, sonra atomik taşınır; eski artefaktı başarılı taşımadan önce silmek yasaktır.
7.1.5. Derleme veya kopyalama başarısızsa betik sıfır dışı kodla çıkmak ve `release/` içinde yarım dosya bırakmamak zorundadır.
7.1.6. `release/` ve `target/` `.gitignore` içindedir; damga, ikili dosya ve derleme çıktısı depoya işlenemez.
7.1.7. Betikler hedefe göre üretilir: Windows için PowerShell, macOS ve Linux için bash; iki betik aynı damga kuralını uygulamak zorundadır.
7.1.8. Paketleme betiği art arda iki kez çalıştırıldığında `release/` içinde tek dosya kalmalı, damga değişmemeli ve çıkış kodu 0 olmalıdır; bu koşul sağlanmadan artefakt yayınlanamaz.
7.1.9. Paket imzalama, notarization ve dmg/AppImage/deb üretimi bu anayasada düzenlenemez; ayrı belgede ele alınmak zorundadır.

## 8. ERİŞİLEBİLİRLİK VE PERFORMANS
8.1.1. Erişilebilirlik AccessKit ağacıyla sağlanır (gpui-pre 0.3.10 → accesskit ^0.24.0); her etkileşimli öğe rol, ad, durum ve eylemleriyle tanımlanmak zorundadır.
8.1.2. Etkileşim için standart bileşen kullanılır; yeni bir etkileşimli `div` yalnız klavye, odak ve erişilebilirlik semantiği birlikte kurulduğunda yazılabilir, aksi hâlde yasaktır.
8.2.1. Hedef 120 FPS'tir ancak garanti değildir; ölçüm release derlemesinde tam pencere üzerinde gpui-kit FPS Monitor (`fps_monitor`) ile yapılmak zorundadır.
8.2.2. 120 Hz hedefi kare bütçesi olarak ~8,33 ms'dir ve bu bütçe düzen, boya, GPU ve kompozitör maliyetini kapsar; yalnız `render` süresi ölçüm sayılmaz.
8.2.3. Performans raporu ortalama yerine kare süresi dağılımı ve P95 değeri içermek zorundadır.
8.3.1. IME ve ekran okuyucu davranışı gerçek kullanıcı testiyle doğrulanır; başsız ağaç testi tek başına kanıt sayılmaz.
8.3.2. WCAG 2.2 AA hedefi görsel dizayn anayasasında bağlayıcıdır ve erişilebilirlik gerilemesi olan derleme yayınlanamaz.

## Kabul kapısı
- [ ] `cargo build --release --locked` ve `cargo test --locked`, `macos-latest` ve `ubuntu-latest` işlerinin ikisinde de yeşil.
- [ ] `cargo fmt --check` ve `cargo clippy -- -D warnings` sıfır uyarı verir.
- [ ] `cargo tree -i gpui-pre` tek sürüm (0.3.10) döndürür; `cargo tree -i gpui` uygulama bağımlılığı bulmaz.
- [ ] `git ls-files release target` boş döner; `release/` içinde tek artefakt vardır ve damgası Hakkında sürümüyle eşleşir.
- [ ] Paketleme betiği iki kez çalıştırıldı: çıkış kodu 0, tek dosya, damga değişmedi.
- [ ] `grep -rn "rusqlite\|std::fs::write\|Command::new" ui/` eşleşme vermez.
- [ ] FPS Monitor ölçümü release ve tam pencere için kayda geçti; P95 kare süresi 8,33 ms bütçesine göre değerlendirildi.
- [ ] AccessKit ağacı başsız testte rol, ad ve durum doğruladı; ekran okuyucu (VoiceOver/Orca) ve IME gerçek pencere testi yapıldı.
- [ ] `grep -rnE "(api[_-]?key|token|password)\s*=" --include=*.rs .` sır bulmaz ve `.env` izlenmiyor.
- [ ] Lisans taraması yalnız MIT veya Apache-2.0 sonucu verdi; atıf şartlı lisans yok.

## Kaynaklar
- <https://gpui-kit.com/docs/installation> — Rust 1.92 alt sınırı, platform gereksinimleri, `gpui-pre` 0.3.10 sabiti.
- <https://gpui-kit.com/docs/accessibility> — AccessKit ağacı ve erişilebilirlik kontratı.
- <https://gpui-kit.com/docs/fps> — 120 Hz kare bütçesi ve FPS Monitor ölçüm yöntemi.
- <https://gpui-kit.com/docs/keybinding> — `KeyBinding`, platform kısayol farkı ve odak yolu.
- <https://crates.io/crates/gpui-kit> — 0.8.1 sürümü, Apache-2.0 lisansı, varsayılan özellikler.
- <https://releases.rs/docs/1.92.0/> — Rust 1.92.0 sürüm kaydı.
Erişim: 2026-10-27
