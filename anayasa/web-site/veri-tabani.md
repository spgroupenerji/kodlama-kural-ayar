# WEB SİTESİ — VERİ TABANI ANAYASASI

> Kapsam: Herkese açık tanıtım sitesinde form ve lead saklama amacıyla kullanılan ilişkisel veri katmanı.
> Öncelik: `AGENTS.md` > bu anayasa > proje içi belgeler
> Doğrulama: 2026-10-27 · context7 + resmî belgeler (bkz. Kaynaklar)

## 1. KAPSAM VE VARSAYILAN

1.1.1. Tanıtım sitesinde veritabanı varsayılan olarak yoktur ve yalnız form veya lead saklama zorunluluğu doğduğunda açılır.
1.2.1. Veritabanı gerektirmeyen içerik statik HTML olarak tutulur; içerik saklamak için veritabanı açmak yasaktır.
1.3.1. Bu anayasa oturum, kullanıcı hesabı ve panel verisini kapsamaz; oturumlu uygulamalar ayrı anayasaya tabidir.
1.4.1. `AGENTS.md` üstündür ve bu belge yalnız veri katmanına özgü uzmanlık katmanıdır; çelişkide `AGENTS.md` uygulanır.

## 2. MOTOR, SÜRÜM VE BAĞLANTI

2.1.1. Üretimde MySQL 8.4.13 LTS veya MariaDB 10.11 ve üzeri sürüm kullanılmak zorundadır.
2.2.1. MySQL 8.0 ailesi 2026-04-30 itibarıyla destek dışıdır ve mevcut cPanel 8.0.45 kurulumu 8.4 LTS'e yükseltilmeden yeni veri katmanı yayına alınamaz.
2.3.1. Veri erişimi yalnız PDO ile yapılır; `mysqli` ve ham sürücü çağrıları yasaktır.
2.4.1. DSN `charset=utf8mb4` içerir; `PDO::ATTR_EMULATE_PREPARES => false` ve `PDO::ERRMODE_EXCEPTION` zorunludur.
2.5.1. Bağlantı bilgileri yalnız `.env` veya secret manager'da tutulur; uygulama hesabı en az yetkiyle çalışır ve `root` ile bağlanmak yasaktır.

## 3. ŞEMA VE KARAKTER SETİ

3.1.1. Tüm tablolar InnoDB motorunda, `utf8mb4` karakter setinde ve tek proje collation'ında (MySQL 8.4 için `utf8mb4_0900_ai_ci`, MariaDB 10.11+ için `utf8mb4_unicode_ci`) oluşturulur; Türkçe metin karşılaştırması gereken kolonların collation'ı testle doğrulanır.
3.2.1. Tablo ve kolon adları ASCII `snake_case` olur; Türkçe karakter, boşluk veya büyük harf içeren tanımlayıcı yasaktır.
3.3.1. Her tabloda birincil anahtar bulunur; birincil anahtarsız tablo kabul edilmez.
3.4.1. Zorunlu alanlar `NOT NULL` ve varsayılan değerle tanımlanır; zorunluluğu uygulama katmanına bırakmak yasaktır.

## 4. SORGU VE BÜTÜNLÜK

4.1.1. Tüm sorgular hazırlanmış deyimle çalıştırılır; SQL metnine değer birleştirme yasaktır.
4.2.1. `SELECT *` yasaktır; sorguda yalnız kullanılan kolonlar listelenir ve döngü içinde ayrı sorgu (N+1) yazılamaz.
4.3.1. Liste sorgularında `LIMIT` zorunludur; üst sınırı olmayan sorgu yayına alınamaz.
4.4.1. `WHERE` koşulu indeksli kolonda ham değerle kurulur; kolon üzerinde fonksiyon ve baştan jokerli `LIKE` yasaktır; karmaşık sorgu `EXPLAIN` ile doğrulanır.
4.5.1. Birden fazla tabloyu etkileyen yazma işlemi tek transaction içinde yürütülür ve hata durumunda `ROLLBACK` zorunludur.
4.6.1. Transaction içinde ağ çağrısı, dosya işlemi veya e-posta gönderimi yapılamaz; eşzamanlı güncelleme `version` kolonuyla korunur.

## 5. GÖÇLER VE YEDEK

5.1.1. Tüm şema değişiklikleri numaralı göç dosyasıyla ve sürüm kontrolünde yapılır; üretimde elle `ALTER` yasaktır.
5.2.1. Her göç dosyası tek yapısal değişiklik içerir ve geri alma adımını belgeler.
5.3.1. `*.sql` dosyaları depoda izlenmez; şema göçleri `.php` dosyası olarak tutulur ve örnek şema `.sql.example` adıyla saklanır.
5.4.1. Yıkıcı işlem öncesi yedek alınır, geri yükleme bir kez denenerek kanıtlanır ve onay kaydı olmadan yıkıcı göç çalıştırılamaz.

## 6. LEAD VERİSİ, GİZLİLİK VE İZ

6.1.1. Form yalnız amaca gerekli alanları toplar; özel nitelikli kişisel veri ve kart bilgisi tanıtım formunda toplanamaz.
6.2.1. Lead saklama süresi aydınlatma metninde belirtilir ve süre sonunda kayıt silinir veya anonimleştirilir.
6.3.1. PII içeren alanlar loglarda maskelenir; form gövdesi ve e-posta içeriği loga yazılamaz.
6.4.1. Veritabanı erişimi yalnız DAO katmanından yapılır; şablon ve sunum dosyasında SQL bulunamaz ve veritabanı hatası istemciye gösterilemez.

## Kabul kapısı

- [ ] `php -l` tüm form ve göç dosyalarında hatasız döner.
- [ ] Bağlantı DSN'inde `charset=utf8mb4`, `ATTR_EMULATE_PREPARES => false` ve `ERRMODE_EXCEPTION` bulunur.
- [ ] `grep -R "SELECT \*" .` form ve veri katmanında eşleşme üretmez; tüm sorgular hazırlanmış deyimlidir.
- [ ] `EXPLAIN` planında `type: ALL` (tam tablo taraması) kalan sorgu yoktur ve tablolar `utf8mb4` ile tek collation'lıdır.
- [ ] `git ls-files | grep -E "\.sql$"` boştur; göçler `.php` olarak izlenir ve kopya veritabanında denenmiştir.
- [ ] Yedekten geri yükleme bir kez kanıtlanmış, form ucu SQL hatası döndürmemiş ve PII logda maskelenmiştir.

## Kaynaklar

1. https://dev.mysql.com/doc/refman/8.4/en/charset-server.html — `utf8mb4` ve `utf8mb4_0900_ai_ci` varsayılan collation.
2. https://www.php.net/manual/en/pdo.prepared-statements.php — hazırlanmış deyim ve PDO emülasyon davranışı.
3. https://www.php.net/manual/en/ref.pdo-mysql.connection.php — DSN `charset=utf8mb4`, `ATTR_EMULATE_PREPARES => false`, `ERRMODE_EXCEPTION`.
4. https://endoflife.date/mysql — MySQL 8.4.13 LTS ve MySQL 8.0 için 2026-04-30 EOL tarihi.
5. https://www.mevzuat.gov.tr/mevzuat?MevzuatNo=6698&MevzuatTur=1&MevzuatTertip=5 — KVKK 6698 aydınlatma ve saklama yükümlülüğü.

Erişim: 2026-10-27
