# WEB SİTESİ — MİMARİ ANAYASASI

> Kapsam: Herkese açık, SEO ve satış odaklı tanıtım sitelerinin barındırma, kaynak, performans, SEO ve güvenlik mimarisi.
> Öncelik: `AGENTS.md` > bu anayasa > proje içi belgeler
> Doğrulama: 2026-10-27 · context7 + resmî belgeler (bkz. Kaynaklar)

## 1. KAPSAM VE ÖNCELİK

1.1.1. Bu anayasa oturumsuz ve panelsiz herkese açık tanıtım sitelerini bağlar; oturum, panel veya kullanıcı hesabı içeren siteler kapsam dışıdır ve ayrı anayasaya tabidir.
1.2.1. `AGENTS.md` hükümleri bu anayasadan üstündür; çelişki durumunda `AGENTS.md` uygulanır ve proje içi çelişen belge aynı değişiklikte düzeltilmek zorundadır.
1.3.1. Bu anayasaya aykırı mimari karar, gerekçesi ne olursa olsun üretime alınamaz.

## 2. BARINDIRMA VE ÇALIŞMA ZAMANI

2.1.1. Site cPanel/LiteSpeed üzerinde tek web köküyle yayınlanır; web kökü dışına yazılan çalışma zamanı dosyası yasaktır.
2.2.1. PHP 8.4.27 veya üzeri zorunludur; barındırıcı destekliyorsa 8.5.x kullanılır ve 8.4 altı PHP sürümüyle yayın yasaktır.
2.3.1. PHP yalnız ortak parça dahil etme ve form uçları için kullanılır; framework, Composer ve ORM zorunlu değildir ve gerekçesiz eklenemez.
2.4.1. Tüm çalışma zamanı sürümleri sabitlenir ve doğrulanmamış API, sürüm veya yapılandırma anahtarı üretime giremez; `@latest` ve dinamik sürüm belirteci yasaktır.
2.5.1. Sunucu HTTP/2 sunmak ve yanıtları Brotli, desteklenmiyorsa gzip ile sıkıştırmak zorundadır.

## 3. STATİK ÖNCE VE VARLIK MİMARİSİ

3.1.1. Site HTML, CSS ve JavaScript ile statik inşa edilir; Node.js tabanlı derleme ve frontend paket yöneticisi yasaktır, Composer yalnız gerekçeli sunucu bağımlılığı için kullanılabilir.
3.2.1. Tailwind CSS, Play CDN veya herhangi bir CSS derleyici kullanılamaz; tek stil kaynağı elle yazılmış `assets/css/site.css` dosyasıdır.
3.3.1. Tasarım token'ları `:root` altında CSS değişkeni olarak tanımlanır; renk, boşluk ve tipografi değerleri yalnız bu token'lardan okunmak zorundadır.
3.4.1. Ortak HTML parçaları `parcalar/` altında include-only tutulur ve bu dizine doğrudan HTTP erişimi yasaktır.
3.5.1. İçerik sayfaları sunucuda tam HTML olarak üretilir; ana içeriğin istemcide JavaScript ile oluşturulması yasaktır.
3.6.1. Hash'li varlıklar `Cache-Control: public, max-age=31536000, immutable` ile sunulur ve HTML yanıtı kısa ömürlü (`max-age=300`) önbelleklenir.
3.7.1. `.htaccess` ile `parcalar/`, `veri/` ve `log/` dizinleri doğrudan isteğe kapatılır; yapılandırma dışı dosya erişimi yasaktır.

## 4. JAVASCRIPT, FONT VE GÖRSEL BÜTÇESİ

4.1.1. JavaScript vanilla ve `defer` ile yüklenir; sayfa başına toplam JavaScript 30 KB gzip sınırını aşamaz ve aşan sürüm kabul edilmez.
4.2.1. React, Vue, Svelte, jQuery ve SPA yönlendirici gibi çerçeve veya kütüphaneler yasaktır; üçüncü taraf betik CDN'i açılamaz.
4.3.1. Varsayılan tipografi sistem font yığınıdır; marka fontu zorunluysa yalnız self-host woff2 alt kümesi kullanılır ve en fazla 2 dosya yüklenir.
4.4.1. Her font dosyası `preload` ve `font-display: swap` ile yüklenir; harici font CDN'i ve CSS `@import` yasaktır.
4.5.1. Görseller AVIF veya WebP olarak sunulur ve desteklemeyen tarayıcı için `<picture>` içinde geri dönüş biçimi bulunur.
4.6.1. Her `<img>` etiketinde `width` ve `height` zorunludur; en-boy oranı belirtilmeyen görsel kabul edilmez.
4.7.1. LCP görseli `fetchpriority="high"` ve `preload` ile yüklenir; katlanma altı görseller `loading="lazy"` taşır.
4.8.1. Hero video `poster` ile başlar, `preload="none"`, `muted` ve `playsinline` özniteliklerini taşır ve otomatik sesle oynatılamaz; mobilde video yerine statik görsel sunulur.

## 5. ÇEKİRDEK WEB VİTALLERİ

5.1.1. Sahada p75 mobil değerleri LCP ≤ 2.5 s, INP ≤ 200 ms ve CLS ≤ 0.1 olmak zorundadır; eşikler Google Web Vitals standardıdır (bkz. Kaynaklar).
5.2.1. Eşiği aşan sayfa optimizasyon kanıtlanana kadar yayına alınamaz ve mevcut sürüm geri alınır.
5.3.1. Her sayfanın LCP öğesi tasarım aşamasında belirlenir ve render-blocking kaynakla geciktirilemez.
5.4.1. CLS'yi tetikleyen geç yüklenen font, görsel veya reklam yerleşimi yasaktır; yer tutucu alan ayrılmadan dinamik içerik eklenemez.

## 6. SEO VE İNDEKSLEME

6.1.1. Her sayfa semantik HTML ile sunulur; başlık hiyerarşisi atlanamaz ve sayfada tam olarak bir `<h1>` bulunur.
6.2.1. Her sayfa kendi kalıcı adresini gösteren `rel="canonical"` bağlantısı taşımak zorundadır ve meta etiket seti tek ortak parçadan üretilir, sayfalarda elle çoğaltılamaz.
6.3.1. Open Graph ve Twitter Card etiketleri her sayfada zorunludur; başlık, açıklama ve görsel alanı boş bırakılamaz.
6.4.1. JSON-LD ile Organization ve WebSite her sitede, BreadcrumbList her iç sayfada, Product veya FAQPage yalnız uygun sayfalarda zorunludur.
6.5.1. `robots.txt` kökte bulunur ve `sitemap.xml` adresini bildirir; `sitemap.xml` dağıtım sırasında üretilir, sürüm kontrolüne eklenmesi ve elle commit edilmesi yasaktır; `llms.txt` kullanılıyorsa kökte ve aynı üretim kaynağından beslenir.
6.6.1. Kalıcı adres değişikliği 301 haritasıyla yapılır; 302 veya zincirleme yönlendirme SEO kaybı nedeniyle kabul edilmez.
6.7.1. Çok dilli sitede karşılıklı `hreflang` bağlantıları zorunludur; eksik veya tek yönlü hreflang yayına alınamaz.

## 7. ERİŞİLEBİLİRLİK, FORM VE SIR YÖNETİMİ

7.1.1. Her sayfa WCAG 2.2 AA uyumunu sağlamak zorundadır; uyum kanıtlanmadan yayın kabul edilmez.
7.2.1. Kullanıcıya gösterilen hata mesajları Türkçe ve eyleme dönük olmak zorundadır; iç hata ayrıntısı istemciye sızdırılmaz ve teknik ayrıntı yalnız sunucu loguna yazılır.
7.3.1. Her form POST ile sunucu ucuna gönderilir; istemci doğrulaması sunucu doğrulamasının yerine geçmez.
7.4.1. Form ucu CSRF belirteci, hız sınırı, honeypot ve sunucu tarafı alan doğrulaması içermek zorundadır; form verisi saklanacaksa MySQL 8.4 LTS veya MariaDB 10.11+ ile PDO hazırlanmış deyim zorunludur (bkz. veri-tabanı anayasası).
7.5.1. E-posta gönderimi SPF, DKIM ve DMARC kayıtlarıyla kimlik doğrulanmış olmak zorundadır.
7.6.1. Sırlar yalnız `.env` veya secret manager'da tutulur; `.env` sürüm kontrolüne ve web erişimine kapalıdır.
7.7.1. Loglarda parola, token ve kişisel veri maskelenir; form gövdesi ve e-posta içeriği loga yazılamaz.

## 8. GÜVENLİK BAŞLIKLARI VE GİZLİLİK

8.1.1. Tüm HTML yanıtları nonce veya hash tabanlı Content-Security-Policy başlığı taşır; `unsafe-inline` ve `unsafe-eval` yasaktır.
8.2.1. HSTS, `X-Content-Type-Options: nosniff`, Referrer-Policy ve Permissions-Policy başlıkları her yanıtta zorunludur.
8.3.1. HTTPS zorunludur ve HTTP isteği 301 ile HTTPS'e yönlendirilir; üretimde sunucu imza başlıkları kapatılır.
8.4.1. Analitik yalnız çerezsiz veya açık rıza sonrası çalışan, kişisel veri toplamayan ölçüm aracıyla yapılır; üçüncü taraf reklam izleyicisi yasaktır.
8.5.1. KVKK aydınlatma metni yayında olmak zorundadır; lead verisi için amaç, hukuki sebep ve saklama süresi belgelenmeden veri toplanamaz.
8.6.1. Zorunlu olmayan çerez rıza öncesi çalıştırılamaz.

## Kabul kapısı

- [ ] `find . -name "*.php" -exec php -l {} \;` tüm dosyalarda hatasız döner.
- [ ] `grep -RE "@latest|cdn\.tailwindcss|tailwindcss/browser" .` çıktısı boştur.
- [ ] `test ! -e package.json && test ! -e node_modules` doğrulanır; derleme adımı yoktur.
- [ ] Mobil Lighthouse denetiminde LCP ≤ 2.5 s ve CLS ≤ 0.1 sağlanır; alan verisinde p75 INP ≤ 200 ms'dir.
- [ ] Sayfa başına JavaScript transferi Brotli veya gzip sıkıştırılmış olarak ≤ 30 KB'dir.
- [ ] `curl -sI "$SITE_URL/"` yanıtı HTTP/2 ve HSTS, CSP, nosniff, Referrer-Policy, Permissions-Policy başlıklarını içerir.
- [ ] `robots.txt` 200 döner ve sitemap adresini bildirir; `sitemap.xml` dağıtım sonrası 200 döner ve `git ls-files sitemap.xml` boştur.
- [ ] Her sayfada tek `<h1>`, canonical, Open Graph/Twitter ve JSON-LD blokları bulunur; form ucu CSRF'siz isteği ve honeypot doldurulmuş gönderimi reddeder.
- [ ] `git ls-files | grep -E "^\.env$|\.sql$|^sitemap\.xml$"` boştur ve WCAG 2.2 AA elle kontrol listesi tamamlanmıştır.

## Kaynaklar

1. https://www.php.net/supported-versions.php — PHP 8.4 ve 8.5 dallarının destek takvimi.
2. https://endoflife.date/php — PHP 8.4.27 ve 8.5.12 güncel yama sürümleri.
3. https://endoflife.date/mysql — MySQL 8.4.13 LTS ve MySQL 8.0 için 2026-04-30 EOL tarihi.
4. https://web.dev/articles/vitals — LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1 (p75) eşikleri.
5. https://www.w3.org/TR/WCAG22/ — WCAG 2.2 AA başarı ölçütleri.
6. https://cheatsheetseries.owasp.org/cheatsheets/HTTP_Headers_Cheat_Sheet.html — HSTS, CSP, nosniff, Referrer-Policy ve Permissions-Policy başlıkları.

Erişim: 2026-10-27
