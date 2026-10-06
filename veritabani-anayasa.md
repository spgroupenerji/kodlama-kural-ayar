# VERİTABANI MİMARİSİ VE SORGULAMA STANDARTLARI TEKNİK ANAYASASI

1.1.1. Veritabanı mimarisi, şema tasarımı ve sorgulama süreçlerinde; SQL sorgu optimizasyonu, N+1 problem çözümü, cursor-based pagination, transaction ve kilit (lock) yönetimi, geri alınabilir migration disiplini ve repository/DAO mimari organizasyonunda en üst düzey mühendislik ve veri bütünlüğü standartlarını tesis etmektir.
1.2.1. Bu anayasa hükümleri; `sql`, `prisma`, `db`, `migration`, `seed` uzantılı ve ilişkili tüm dosyalarda; şema tasarımı, sorgu performansı, indeksleme stratejileri, bağlantı yönetimi ve veri bütünlüğü gerektiren tüm operasyonlarda doğrudan ve tavizsiz bağlayıcıdır.
1.3.1. Anayasal Öncelik: Ana Anayasa (`AGENTS.md`) hiyerarşik olarak her zaman önceliklidir; bu teknik metin münhasıran veritabanı ve veri katmanına özgü uzmanlık ve uygulama kurallarını tanımlar.
2.1.1. `SELECT *` kullanımı kesinlikle yasaktır; her sorguda yalnızca ihtiyaç duyulan kolonlar (`SELECT id, ad, soyad FROM ...`) açıkça belirtilmek zorundadır.
2.1.2. Sorgularda gereksiz `DISTINCT` ve `ORDER BY` direktifleri kullanılamaz; veritabanı motoruna ek kaynak maliyeti getiren tüm lüzumsuz operasyonlar asgari düzeye indirilmelidir.
2.2.1. İlişkisel sorgularda kontrolsüz alt sorgu (subquery) kullanımı yasaktır; veri ihtiyacına ve tablo ilişkisine göre uygun `INNER JOIN` veya `LEFT JOIN` türleri tercih edilmelidir.
2.2.2. Karmaşık, çoklu birleşimli ve yoğun veri işleyen tüm sorgular `EXPLAIN` veya `EXPLAIN ANALYZE` komutlarıyla analiz edilmek ve execution plan (yürütme planı) doğrulanarak optimize edilmek zorundadır.
2.3.1. `WHERE` koşullarında indeksli kolonların doğrudan kullanımı esastır; indeks mekanizmasını devre dışı bırakan fonksiyon tabanlı filtrelemelerden (`WHERE YEAR(tarih) = ...` vb.) kesinlikle kaçınılmalıdır.
2.3.2. Metin aramalarında baştan jokerli `LIKE '%deger'` kullanımı indeks kullanımını engellediği için yasaktır; bu tür gereksinimlerde tam metin arama (full-text search) mekanizmaları tesis edilmelidir.
3.1.1. Döngü içerisinde ardışık veritabanı sorgusu çalıştırılması (N+1 sorgu problemi) kesinlikle yasaktır.
3.1.2. İlişkisel verilerin çekilmesinde `JOIN` mimarisi esastır; ilişkili tüm veri kümeleri tek bir optimize sorgu üzerinden alınmalıdır.
3.2.1. ORM (Object-Relational Mapping) katmanı kullanılan projelerde ilişkili veriler `eager loading`, `with()` veya `include` direktifleriyle önceden yüklenmek zorundadır.
3.2.2. Sorgu optimizasyon senaryolarına göre `JOIN` yerine `EXISTS` veya `IN` alt sorgu alternatifleri analiz edilmeli ve execution plan maliyetine göre en verimli yöntem seçilmelidir.
3.3.1. Toplu veri ekleme ve güncelleme işlemlerinde her kayıt için tekil sorgu açılması yasaktır; tüm toplu işlemler `batch` mantığıyla (toplu `INSERT` / toplu `UPDATE`) yürütülmelidir.
4.1.1. Büyük veri setlerinin tek bir sorguda sınırsızca çekilmesi kesinlikle yasaktır; tüm listeleme uç noktalarında sayfalama (pagination) zorunludur.
4.1.2. Sonsuz kayıt döndüren kontrolsüz uç noktalar oluşturulamaz; her sorgu için aşılması imkânsız bir maksimum kayıt limiti tanımlanmalıdır.
4.2.1. Büyük veri hacimlerinde performans kaybına yol açan geleneksel offset-based pagination yerine, sabit maliyetli çalışan cursor-based pagination (`WHERE id > cursor LIMIT x`) mimarisi tercih edilmelidir.
4.2.2. Her sayfalama isteğinde toplam kayıt sayısı (`COUNT(*)`) veritabanına anlık olarak yeniden hesaplatılamaz; zorunlu istatistiki durumlarda toplam kayıt verisi önbellek (cache) katmanı üzerinden sunulmalıdır.
5.1.1. Birden fazla tabloyu veya ilişkili çoklu satırları etkileyen tüm yazma operasyonlarında işlem mutlak surette bir `transaction` bloğu kapsamına alınmalıdır; operasyon ya bütünüyle başarılı olmalı ya da tamamen geri alınmalıdır.
5.1.2. Veri bütünlüğünü korumak adına `BEGIN`, `COMMIT` ve `ROLLBACK` yaşam döngüsü eksiksiz işletilmeli; hata anında istisnasız `ROLLBACK` tetiklenmelidir.
5.2.1. Transaction blokları içerisinde harici ağ çağrısı, dosya I/O veya uzun süren iş mantığı yürütülemez; tablo ve satır kilit (lock) süreleri asgari düzeyde tutulmalıdır.
5.2.2. Kilitlenme (deadlock) riskini önlemek amacıyla, tablolara ve satırlara erişim kilit sıralaması tüm servis genelinde tutarlı ve standart bir hiyerarşide işletilmelidir.
5.3.1. Eşzamanlı veri güncellemelerinde veri tutarlılığını sağlamak adına senaryoya göre iyimser kilitleme (optimistic locking - `version` kolonu ile) veya kötümser kilitleme (pessimistic locking) disiplini uygulanmalıdır.
6.1.1. Tüm şema değişiklikleri ve migration dosyaları istisnasız sürüm kontrol sisteminde (Git) takip edilebilir olarak tutulmalıdır.
6.1.2. Her bir migration dosyası yalnızca tek bir yapısal değişikliği içermelidir; birden fazla bağımsız şema değişikliğinin tek migration dosyasında birleştirilmesi yasaktır.
6.2.1. Tüm migration'lar çift yönlü ve geri alınabilir (reversible) olarak tasarlanmalı; `up` ve `down` blokları eksiksiz tanımlanmalıdır.
6.2.2. Bağımlı migration zincirlerinde çalışma sırası mutlak surette korunmalı; sıralama doğruluğu kontrol edilmeden şema yürütülemez.
6.3.1. Canlı ortamda (production) veri kaybına yol açabilecek yıkıcı operasyonlar (`DROP TABLE`, `DROP COLUMN` vb.) doğrudan uygulanamaz; önce veri güvenli bir alana taşınmalı veya dönüştürülmeli, ardından düşürme işlemi uygulanmalıdır.
6.3.2. Veri kaybı riski taşıyan her türlü migrasyon sürecinde işlem öncesinde kullanıcı açıkça uyarılmalı ve kesin onay alınmalıdır.
7.1.1. Veritabanı seviyesinde veri erişim ve sorgulama yetkileri rol tabanlı (role-based) olmalı; her kullanıcı ve servis rolü yalnızca yetkisi dâhilindeki veri kapsamını görebilmelidir.
7.1.2. Hassas verilerin maskelenmesi, loglanması ve veritabanı seviyesinde izole edilmesi süreçleri Ana Anayasa 8.7 hükümlerine tabidir.
7.1.3. Veritabanı bağlantı adresleri, yetki anahtarları ve secret yönetimi Ana Anayasa 8.6 standartlarına göre yönetilir; açık metin secret kullanımı yasaktır.
8.1.1. Sorgulama ve veri erişim mantığı kontrolcülere veya sunum katmanına dağıtılamaz; tüm veri erişimi merkezi Repository veya DAO (Data Access Object) katmanında yapılandırılmalıdır.
8.1.2. ORM kullanılan mimarilerde model tanımları merkezi tek bir kaynakta tanımlanmalı; mükerrer model yapılandırması yapılmamalıdır.
8.2.1. Ham SQL sorguları merkezi dosyalarda veya tip güvenli sorgu oluşturucularla (query builder) yönetilmeli; dinamik SQL üretimleri Ana Anayasa 8.2 maddesinde belirtilen parametrik/hazırlanmış ifade (prepared statement) kuralına kayıtsız şartsız uymalıdır.
8.3.1. Veritabanı bağlantısı uygulama yaşam döngüsünde tek bir örnek (singleton instance / connection pool) olarak yönetilmeli; her işlemde kontrolsüz yeni bağlantı açılması engellenmelidir.
8.3.2. Transaction yönetimi merkezi servis katmanı üzerinden koordine edilmeli; bağımsız alt fonksiyonların kendi başına kontrolsüz transaction açması ve yönetmesi yasaktır.