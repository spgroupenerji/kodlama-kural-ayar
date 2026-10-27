# WEB UYGULAMA — MİMARİ ANAYASASI

> Kapsam: Oturumlu panel uygulamalarının PHP çalışma zamanı, istek yaşam döngüsü, ön yüz teslimi, servis katmanı, güvenlik kapıları ve dağıtım disiplinini kapsar.
> Öncelik: `AGENTS.md` > bu anayasa > proje içi belgeler
> Doğrulama: 2026-10-27 · context7 + resmî belgeler (bkz. Kaynaklar)

## 1. KAPSAM VE ÖNCELİK

1.1.1. Bu anayasa, cPanel/LiteSpeed üzerinde çalışan oturumlu ve rol tabanlı PHP panel uygulamalarını ve bunların çalıştığı çevrimiçi sistemleri bağlar; halka açık SEO siteleri web-site alanının anayasasına tabidir ve bu metnin kapsamına alınamaz.
1.1.2. `AGENTS.md` bu metnin üstündedir ve çelişkide onun hükmü uygulanır; bu anayasa alan-özgü uzmanlık katmanıdır.
1.1.3. Proje içi belgeler (`docs/YAPI.md` dâhil) bu anayasanın altındadır; çelişen proje belgesi düzeltilmeden dağıtım yapılamaz.
1.1.4. Her hüküm denetlenebilir kanıt üretmek zorundadır; kanıtsız uygunluk beyanı kabul edilmez.
1.2.1. Üretim çalışma zamanı PHP 8.4.27 veya üzeridir; 8.4 dalının altına inilemez ve barındırıcı destekliyorsa 8.5.x kullanılır.
1.2.2. PHP, MySQL, Tailwind CSS, htmx, Lucide ve Python sürümleri sabittir; `@latest` veya dinamik sürüm etiketi ve doğrulanmamış API üretime giremez.
1.2.3. Sunucu sürüm farkı ve uzantı envanteri `docs/ortam_envanteri.sh` çıktısıyla kayda geçirilmeden dağıtım yapılamaz.

## 2. SUNUCU VE YAPILANDIRMA

2.1.1. Web kökü tektir; `destek/`, `api/`, `sayfa/`, `sidebar/`, `docs/`, `log/` ve `vendor/` doğrudan HTTP isteğine kapalıdır ve `.htaccess` bu yollar için 403 döndürmek zorundadır.
2.1.2. HTTPS zorunludur; HTTP istekleri 301 ile HTTPS'e yönlendirilir ve TLS sonlandırma katmanı dışında HTTP dinlenmez.
2.1.3. `.env` ve `.user.ini` web'den erişilemez; bu kapıları içermeyen dağıtım reddedilir.
2.2.1. `config.php` tek yapılandırma noktasıdır; `.env` yükleyicisi mevcut ortam değişkenlerini ezmez ve `.env` sürüm dışıdır, depoya giremez.
2.2.2. Sırlar yalnız `.env` veya secret manager'da tutulur; kod, depo, log ve hata mesajında düz metin sır bulunamaz.
2.2.3. Üretimde `display_errors=Off`, `log_errors=On` ve OPcache etkin olmak zorundadır; dağıtım sonrası `opcache_reset()` çağrılır.
2.2.4. Loglarda parola, token ve kişisel veri `[MASKELI]` olarak maskelenir; maskesiz kayıt güvenlik ihlali sayılır.
2.2.5. Uygulama zaman dilimi `config.php` içinde tek noktada tanımlanır; modül düzeyinde ikinci tanım yasaktır.

## 3. İSTEK YAŞAM DÖNGÜSÜ VE KOD KATMANLARI

3.1.1. HTTP girişi yalnız `index.php` ve `api.php` üzerindendir; modül çözümlemesi desen, işleyici dosyası ve sayfa varlığı koşullarıyla yapılır ve manuel izinli liste tutulamaz.
3.1.2. Headless modüller `api.php` içindeki tek elemanlı açık listede tanımlanır; listede olmayan sayfasız modül 400 döner.
3.1.3. İstek zinciri gövde çözümü, desen, dosya kuralı, CSRF, oturum ve zaman aşımı, rol denetimi ve denetim kaydı sırasıyla işletilir; sıra atlanamaz.
3.1.4. SQL yalnız DAO/veri katmanında yaşar; controller ve istemci kodunda SQL metni veya `$pdo->` çağrısı bulunamaz.
3.2.1. Sayfa, menü ve rol tanımları tek katalogdan (`destek/sayfa_katalogu.php`) okunur; `index.php`, `api.php` ve sidebar aynı kaynağı kullanmak zorundadır, ikinci kaynak yasaktır.
3.2.2. `sayfa/<kod>.php` ince sunum kabuğudur; iş mantığı `destek/` katmanına aittir ve sunum kabuğu iş kuralı içeremez.
3.2.3. Yeni modül; sayfa kabuğu, API işleyicisi, katalog kaydı ve istemci dosyası birlikte tamamlanmadan kullanıma açılamaz.
3.3.1. Tek modüle özel fonksiyon ve veri yapıları çağıran dosyada kalır; iki veya daha fazla modülün paylaştığı yan etkisiz mantık `destek/` altında toplanmak zorundadır.
3.3.2. Ortak kütüphane üst iş mantığına bağımlı olamaz; bağımlılık yönü `destek/` katmanından modüle doğru tek yönlüdür, ters yön yasaktır.
3.3.3. Birinci taraf iş mantığında `declare(strict_types=1)` ve parametre/dönüş tip bildirimleri zorunludur; gerekçesiz `mixed` kullanımı reddedilir.
3.3.4. Adlandırma, tip ve yapı kodun amacını doğrudan açıklamak zorundadır; kendini açıklamayan kod gözden geçirmede reddedilir.
3.4.1. Boş `catch` bloğu ve hatayı yutan blok yasaktır; her istisna sınıfı, mesajı ve yığın iziyle loglanır.
3.4.2. Kullanıcıya Türkçe ve eyleme dönük hata mesajı gösterilir; iç hata ayrıntısı, yığın izi ve dosya yolu istemciye sızmaz.
3.4.3. Alan hataları ile sistem hataları ayrı yönetilir; sistem hatası güvenli varsayılan ve son geçerli durumla karşılanmak zorundadır.
3.4.4. Yarım bırakılmış işaretler, yoruma alınmış kod ve ölü uç dağıtım engelidir.
3.4.5. Yorum yalnız standart dışı protokol, karmaşık matematik veya mimari zorunluluk gerekçesinde yazılır; bariz mantığı tekrarlayan yorum yasaktır.

## 4. KİMLİK, OTURUM VE YETKİ

4.1.1. Oturum sertleştirmesi zorunludur: `session.use_strict_mode=1`, `session.use_only_cookies=1`, `session.cookie_httponly=1`, `session.cookie_samesite=Lax` ve HTTPS'te `session.cookie_secure=1`.
4.1.2. Oturum çerezi proje önekli addır; girişte `session_regenerate_id(true)` çağrılmadan oturum kimliği kullanılamaz.
4.1.3. Parolalar bcrypt (cost ≥ 12) veya argon2id ile hashlenir; düz metin parola hiçbir katmanda bulunamaz.
4.1.4. Hareketsizlik ve mutlak oturum süreleri tanımlıdır; süre aşımında oturum sunucuda sonlandırılır ve kullanıcı girişe yönlendirilir.
4.2.1. Durum değiştiren her istekte CSRF koruması zorunludur; belirteç `hash_equals` ile sabit zamanlı doğrulanır ve GET/HEAD/OPTIONS muaftır.
4.2.2. CSRF belirteci gövde alanı ve `X-CSRF-Token` başlığıyla taşınır; taşıyıcılardan biri eksikse istek 403 ile reddedilir.
4.2.3. Yetkilendirme rol tabanlıdır ve roller tek katalogda tanımlıdır; yetkisiz istek 403 döner ve denetim kaydına yazılır.
4.2.4. Giriş ve parola sıfırlama uçlarında ayrı hız sınırları uygulanır; eşik aşımında istek 429 ile reddedilir.
4.2.5. Denetim kaydı fail-closed çalışır; yalnız açıkça adı geçen okuma eylemleri loglanmaz.
4.3.1. Yükleme; boyut, MIME türü ve dosya imzası doğrulanmadan kabul edilmez ve istemci dosya adına güvenilmez.
4.3.2. `uploads/` dizini sürüm dışıdır, script çalıştırmaya kapalıdır ve yalnız doğrulanmış dosya olarak sunulur.
4.3.3. CSP `default-src 'self'`, `script-src 'self'`, `style-src 'self'`, `object-src 'none'` ve `frame-ancestors 'none'` ile yayınlanır; `unsafe-inline` ve `unsafe-eval` yasaktır.
4.3.4. HSTS `includeSubDomains` ve sabit `max-age` ile yayınlanır; `X-Content-Type-Options: nosniff` ve `Referrer-Policy` başlıkları eksiksiz olmak zorundadır.

## 5. ÖN YÜZ TESLİMİ

5.1.1. Sayfalar sunucuda render edilmiş HTML olarak teslim edilir; SPA framework, istemci tarafı yönlendirici ve sanal DOM katmanı yasaktır.
5.1.2. Tailwind CSS 4.3.3, Node.js gerektirmeyen platforma uygun standalone ikiliyle (Windows: `tailwindcss-windows-x64.exe`) `-i assets/css/kaynak.css -o assets/css/app.css --minify` komutuyla derlenmek zorundadır.
5.1.3. Derlenmiş `assets/css/app.css` depoda izlenir ve sürümle birlikte dağıtılır; `dist/` gibi sürüm dışı bırakılan veya yalnız üretimde üretilen çıktı yasaktır.
5.1.4. Çalışma zamanında Tailwind tarayıcı motoru, CDN bağlantısı ve `assets/css/app.css` dışında stil kaynağı yasaktır.
5.1.5. `assets/css/kaynak.css` yalnız `@theme` bloklarıyla token tanımlar; token dışı ham değer ve elle yazılmış ikinci CSS dosyası yasaktır.
5.2.1. htmx 2.0.11 yalnız gerekli kısmi etkileşimde (liste yenileme, satır içi form, modal içerik) kullanılır; tam sayfa gezinme normal bağlantıyla yapılır.
5.2.2. htmx kendi sunucumuzdan servis edilir, sürümü sabittir ve script etiketi `integrity` (SRI) özniteliği olmadan yayınlanamaz.
5.2.3. htmx isteklerinin CSRF başlığı `htmx:configRequest` olayıyla `app.js` sözleşmesinden eklenir; modül içinde ayrı başlık kopyası yasaktır.
5.2.4. htmx ile gelen kısmi yanıt sunucuda üretilir ve yalnız hedef bölgeyi değiştirir; istemci tarafı şablon motoru yasaktır.
5.3.1. `js/app.js` `<head>` sonunda `defer` ile yüklenir; `apiIstek`, `bildirimGoster` ve `htmlTemizle` sözleşmesi dışına çıkan modül içi fetch veya kaçış üretimi yasaktır.
5.3.2. Yakalanmamış hata ve söz redleri tek bildirim kanalına bağlanır; sessiz yutma yasaktır.
5.3.3. İstemci JavaScript toplamı gzip 60 KB'yi, derlenmiş CSS toplamı gzip 30 KB'yi aşarsa dağıtım reddedilir.
5.4.1. İkonlar Lucide 1.61.0 inline SVG sprite üzerinden verilir; çalışma zamanı Iconify API, ikon fontu ve ikinci ikon seti yasaktır.
5.4.2. Yazı tipi sistem yığınıdır; harici font CDN'i ve gömülü web font yasaktır, taban gövde 13/14 px'tir.
5.4.3. Ön yüz teslimi WCAG 2.2 AA hedefini korumak zorundadır; erişilebilirlik ölçümü olmadan ön yüz değişikliği dağıtıma çıkamaz.

## 6. SERVİS VE TELEMETRİ KATMANI

6.1.1. Servis katmanı gerektiğinde Python 3.14 (asgari 3.14.10) ve `asyncio` ile yazılır; farklı Python dalı üretime giremez, parametre ve dönüş tipleri eksiksiz tanımlanır ve gerekçesiz `Any` yasaktır.
6.1.2. Olay döngüsünde bloklayan senkron girdi/çıktı (dosya, soket, senkron veritabanı sürücüsü) yürütmek yasaktır; tüm girdi/çıktı yerel asenkron sürücülerle veya thread havuzunda yürütülür.
6.1.3. Olay döngüsü tick süresini uzatma potansiyeli taşıyan CPU-yoğun rutinler münhasıran `asyncio.to_thread` veya `ProcessPoolExecutor` havuzuna devredilir.
6.1.4. Her harici ağ ve girdi/çıktı çağrısı katı `timeout` ile sınırlandırılır; zaman aşımı koruması olmayan çağrı üretim kodunda yer alamaz.
6.1.5. Başlatılan her `asyncio.Task` için güçlü referans tutulur ve `asyncio.CancelledError` yakalanarak soket, kilit ve dosya tanımlayıcıları deterministik serbest bırakılır.
6.1.6. Coroutine ile thread arasında paylaşılan korumasız belleğin doğrudan okunması ve yazılması yasaktır; veri takası `asyncio.Queue`, `queue.Queue` veya `asyncio.run_coroutine_threadsafe` ile tek yönlü ve atomik yapılır.
6.1.7. Paylaşılan mutasyon `asyncio.Lock` veya `threading.Lock` ile korunur; kilit altında ağ, disk veya uzun hesap yapılamaz ve kilit edinme sırası deterministiktir.
6.1.8. Sınırsız kuyruk, arabellek ve önbellek yasaktır; kuyruklar `maxsize` ile tanımlanır ve dolduğunda üretici `await queue.put()` ile bekletilir.
6.1.9. Doygunlukta deterministik yük atma (HTTP 429/503 veya en eskisini düşürme) işletilir ve düşürülen her veri yapısal sayaçla kaydedilir.
6.1.10. Geçici hata yeniden denemeleri tavan deneme sayısı, üstel geri çekilme ve rastgele sapma içerir; kontrolsüz `while True` ve fırtına yaratan ani deneme yasaktır.
6.1.11. Sürekli başarısız dış bağımlılık için devre kesici uygulanır; açık devrede istek hızla reddedilir ve yapısal metrikle raporlanır.
6.1.12. Tüm loglar JSON yapısal formatta `timestamp`, `level`, `trace_id` ve `module` alanlarıyla üretilir; string biçimlendirmeyle log yazımı yasaktır.
6.1.13. Sistem sınırlarından giren yapılandırılmamış veri katı şemayla (`Pydantic`, dondurulmuş `dataclass` veya `TypedDict`) doğrulanmadan iç katmana aktarılamaz.

## 7. PERFORMANS BÜTÇESİ

7.1.1. Sunucu yanıt süresi (TTFB) p95'te 500 ms'yi aşamaz.
7.1.2. API yanıt süresi p95'te 300 ms'yi aşamaz.
7.1.3. LCP p75'te 2,5 saniyeyi aşamaz (çekirdek Web Vitals eşiği).
7.1.4. Derlenmiş CSS gzip toplamı 30 KB, JavaScript gzip toplamı 60 KB sınırını aşamaz.
7.2.1. Bütçe ölçümü her sürümde kayda geçirilir; eşik aşımı kök neden giderilmeden kapatılamaz ve aşım sürümü dağıtılmaz.
7.2.2. Ölçüm aracı ve komutu proje `docs/` klasöründe tanımlıdır; tanımsız araçla yapılan ölçüm kabul edilmez.

## 8. DAĞITIM VE GERİ DÖNÜŞ

8.1.1. Dağıtım yalnız `git merge --ff-only` ile yapılır; force push, geçmiş yeniden yazımı ve ff dışı birleştirme yasaktır.
8.1.2. GitHub kancası HMAC-SHA256 imzası doğrulanmadan çalışmaz; imzasız veya geçersiz imzalı istek 403 döner.
8.1.3. Panelden tetiklenen dağıtım yönetici oturumu, POST ve CSRF olmadan yürütülemez.
8.1.4. Her dağıtım öncesi geri dönüş hedefi olan önceki commit kimliği kayda geçirilir; kayıtsız dağıtım reddedilir.
8.1.5. Şema değişikliği veri tabanı anayasasının migration disiplinine tabidir; dağıtım sırasında elle SQL çalıştırılamaz.
8.1.6. Log ve denetim tek kanaldadır (`log/`); kanal başına budama tavanı tanımlıdır ve log dizini web'den erişilemez.
8.1.7. Dağıtım sonrası OPcache temizlenir ve sağlık kontrolü yapılır; başarısız sağlık kontrolünde geri dönüş zorunludur.
8.1.8. `.env` ve `uploads/` dağıtımda üzerine yazılmaz; bu yollar sürüm dışıdır ve dağıtım kapsamına alınamaz.

## Kabul kapısı

- [ ] `php -r 'echo PHP_VERSION;'` çıktısı `8.4.27`; değişen tüm PHP dosyaları `php -l` ile hatasız.
- [ ] `php -i | grep -E 'session.use_strict_mode|session.cookie_samesite|session.cookie_httponly'` zorunlu değerleri gösterir.
- [ ] `curl -sI https://<alan>/login` yanıtı `Strict-Transport-Security`, `Content-Security-Policy` ve `X-Content-Type-Options: nosniff` başlıklarını taşır.
- [ ] `tailwindcss-windows-x64.exe -i assets/css/kaynak.css -o assets/css/app.css --minify` hatasız; `gzip -c assets/css/app.css | wc -c` ≤ 30720.
- [ ] `gzip -c js/app.js | wc -c` ≤ 61440 ve `git ls-files assets/css/app.css` çıktısı boş değil.
- [ ] `grep -R '@latest\|cdn\.\|iconify' --include='*.php' --include='*.html' --include='*.css' --include='*.js' .` hiçbir eşleşme üretmez.
- [ ] htmx script etiketi `integrity=` özniteliği içerir ve dosya kendi alan adımızdan gelir.
- [ ] `curl` ile ardışık giriş isteği testinde eşik aşımı 429 döner ve denetim kaydı aynı isteği listeler.
- [ ] TTFB p95 ≤ 500 ms, API p95 ≤ 300 ms ve LCP p75 ≤ 2,5 s ölçüm kaydı mevcuttur.
- [ ] Son dağıtım `git merge --ff-only` ile birleştirilmiş ve rollback commit kimliği kayıtlıdır.
- [ ] `grep -R 'password\|token' log/` yalnız `[MASKELI]` içeren satırlar döner.

## Kaynaklar

1. PHP 8.4 sürüm verisi — https://www.php.net/releases/index.php?json&version=8.4
2. PHP oturum yapılandırması — https://www.php.net/manual/en/session.configuration.php
3. Tailwind CSS standalone CLI — https://tailwindcss.com/docs/installation/tailwind-cli
4. Tailwind standalone derleme komutu — https://tailwindcss.com/blog/standalone-cli
5. htmx olayları (`htmx:configRequest`) — https://htmx.org/events/
6. Python asyncio görev ve thread köprüleri — https://docs.python.org/3/library/asyncio-task.html

Erişim: 2026-10-27
