# RUST MASAÜSTÜ — VERİ TABANI ANAYASASI

> Kapsam: Gömülü SQLite kullanan Rust masaüstü uygulamalarının motor, bağlantı, eşzamanlılık, şema, sorgu ve gizlilik hükümleri.
> Öncelik: `AGENTS.md` > bu anayasa > proje içi belgeler
> Doğrulama: 2026-10-27 · context7 + resmî belgeler (bkz. Kaynaklar)

## 1. BAĞLAYICILIK VE SAHİPLİK
1.1.1. SQLite gömülü tek veritabanı motorudur; istemci-sunucu veritabanı, harici veritabanı servisi veya bulut veritabanı kullanmak yasaktır.
1.1.2. Veritabanı erişimi yalnız `depo/` katmanından yapılır; `ui/` ve `domain/` katmanları `rusqlite` tiplerini içe aktaramaz.
1.1.3. Bu anayasa `AGENTS.md` ve mimari anayasasının altındadır; çelişkide ana anayasa ve mimari hükümleri uygulanmak zorundadır.

## 2. MOTOR VE SÜRÜM SABİTLEME
2.1.1. `rusqlite = "=0.41.0"` sürümü `bundled` özelliğiyle kullanılır; sistem SQLite kütüphanesine bağlanmak yasaktır.
2.1.2. Şema göçleri `rusqlite_migration = "=2.6.0"` ile kod içinde tanımlanır; harici CLI veya elle çalıştırılan SQL betiği yasaktır.
2.1.3. Sürümler tam numarayla sabitlenir ve `Cargo.lock` commit edilir; `--locked` olmadan yapılan derleme veritabanı içeren artefakt üretemez.
2.1.4. Doğrulanmamış pragma ve sorgu biçimi üretime giremez; her SQL hükmü resmî SQLite belgesine dayanmak ve incelemede kaynağıyla gösterilmek zorundadır.
2.1.5. Veritabanı yolu platform veri dizininden çözülür, koda mutlak yol yazmak yasaktır ve dosya izinleri yalnız geçerli kullanıcıya okuma-yazma vermek zorundadır.

## 3. BAĞLANTI, WAL VE YAZICI DİSİPLİNİ
3.1.1. Veritabanı WAL kipinde açılır; açılışta `PRAGMA journal_mode=WAL;` uygulanmak ve seçilen kip testte doğrulanmak zorundadır.
3.1.2. `PRAGMA foreign_keys=ON;` açılışta açıkça uygulanır; SQLite varsayılanı kapalı olduğu için bu pragmayı atlamak yasaktır.
3.1.3. `PRAGMA busy_timeout` sıfırdan büyük tek bir sabit değere ayarlanır ve bu değer `depo/` modülünde tanımlanmak zorundadır.
3.1.4. WAL kipinde `PRAGMA synchronous=NORMAL;` kullanılır; `FULL` yalnız güç kesintisi dayanımı zorunlu senaryoda yazılı gerekçeyle seçilir.
3.2.1. Tek yazıcı ilkesi geçerlidir; tüm yazmalar tek arka plan yürütücüsünden sırayla geçmek zorundadır ve ikinci yazıcı açmak yasaktır.
3.2.2. UI iş parçacığında veritabanı çağrısı yapmak yasaktır; sorgu sonucu UI'ye sınırlı kapasiteli kanal üzerinden iletilir.
3.2.3. WAL dosyası ağ paylaşımında veya eşzamanlanan klasörde açılamaz; veritabanı yalnız yerel diskte tutulmak zorundadır.
3.2.4. Transaction içinde ağ çağrısı, dosya G/Ç ve uzun hesaplama yapmak yasaktır; işlem yalnız veritabanı değişikliklerini kapsar.
3.2.5. Kullanıcı onayı bekleyen transaction açık bırakmak yasaktır; her transaction en kısa sürede kapanmak zorundadır.

## 4. ŞEMA VE GÖÇ
4.1.1. Her göç tek bir şema değişikliği içerir; birden fazla bağımsız değişikliği tek göçte birleştirmek yasaktır.
4.1.2. Göçler uygulama açılışında `to_latest` ile atomik uygulanır; yarıda kalan göç sonrası uygulama açılamaz ve hata Türkçe raporlanmak zorundadır.
4.1.3. Göç zinciri testte `validate()` ile doğrulanmak zorundadır; doğrulanmamış göç yayına giremez.
4.2.1. Şema sürümü `PRAGMA user_version` ile izlenir ve bu değer göç kütüphanesi dışında değiştirilemez.
4.2.2. Yıkıcı göç (tablo veya kolon düşürme, veri daraltma) öncesi dosya yedeği alınmak ve yedek `quick_check` ile doğrulanmak zorundadır.
4.2.3. Her göçte geri alma betiği yazmak zorunlu değildir; geri dönüş gereksinimi yıkıcı değişiklik öncesi alınan dosya yedeğiyle karşılanmak zorundadır.
4.3.1. Zaman damgaları UTC unix milisaniye `INTEGER` olarak saklanır; büyük ikili içerik veritabanına gömülmez, dosya yolu referansı tutulur.
4.2.4. Veri kaybı riski taşıyan göç öncesi kullanıcıya Türkçe uyarı gösterilmek ve açık onay alınmak zorundadır; onay yoksa göç uygulanamaz.

## 5. SORGULAMA KURALLARI
5.1.1. Tüm sorgular hazırlanmış ifadeyle çalıştırılır; değerleri metin birleştirmeyle SQL'e gömmek yasaktır.
5.2.1. `SELECT *` yasaktır; yalnız ihtiyaç duyulan kolonlar açıkça yazılmak zorundadır.
5.2.2. Her listeleme sorgusu zorunlu `LIMIT` taşır; sınırsız sonuç kümesi döndürmek yasaktır.
5.2.3. Döngü içinde sorgu çalıştırmak (N+1) yasaktır; ilişkili veri tek sorguda veya toplu `IN` listesiyle alınmak zorundadır.
5.2.4. Toplu yazma tek transaction içinde toplu `INSERT` veya `execute_batch` ile yapılır; kayıt başına transaction açmak yasaktır.
5.3.1. Filtre veya sıralama kullanan sorgu için gerekli indeks tanımlanmak ve plan `EXPLAIN QUERY PLAN` ile doğrulanmak zorundadır.
5.3.2. İndeksi devre dışı bırakan fonksiyon sarmalı ve baştan jokerli `LIKE '%...'` filtresi yasaktır.
5.3.3. Sayfalama `LIMIT` ve imleç (son kimlik) ile yapılır; büyük tabloda derin `OFFSET` kullanmak yasaktır.

## 6. BÜTÜNLÜK, GİZLİLİK VE HATA
6.1.1. Açılışta `PRAGMA quick_check;` çalıştırılır ve `ok` dışındaki sonuçla çalışmaya devam etmek yasaktır.
6.1.2. Yedek, açık bağlantı üzerinden tutarlı kopya alınarak üretilir; `-wal` ve `-shm` dosyalarını el ile kopyalamak yasaktır.
6.2.1. Kişisel veri içeren kolonlar açıkça işaretlenir ve loglara yazılmaz; zorunlu logda maskeleme uygulanmak zorundadır.
6.2.2. Parola ve token gibi sırlar veritabanında saklanamaz; saklanması zorunluysa secret manager'da tutulur ve veritabanına yalnız referans yazılır.
6.3.1. Veritabanı hatası kullanıcıya Türkçe ve eyleme dönük mesajla gösterilir; SQL metni, dosya yolu ve sürücü ayrıntısı istemciye sızdırılamaz.
6.3.2. Hata durumunda transaction geri alınır ve yarım durum bırakılmaz; hatayı sessizce yutmak yasaktır.
6.3.3. Bağlantı ve yazma hataları yapısal logda `ERROR` düzeyinde kaydedilir; log kaydına parola veya kişisel veri yazmak yasaktır.

## Kabul kapısı
- [ ] `cargo tree -i rusqlite` tek sürüm (0.41.0) döndürür; `cargo tree -e features -i libsqlite3-sys` çıktısında `bundled` görünür.
- [ ] Açılış testi `PRAGMA journal_mode` için `wal` değerini doğrular.
- [ ] Açılış testi `PRAGMA foreign_keys` için `1` değerini doğrular.
- [ ] Göç testi: boş veritabanı `to_latest` sonrası beklenen `user_version` değerine ulaşır ve `validate()` `Ok` döner.
- [ ] `grep -rn "rusqlite" --include=*.rs .` yalnız `depo/` altında eşleşir.
- [ ] Her yeni sorgu için `EXPLAIN QUERY PLAN` çıktısı incelendi ve büyük tabloda tam tablo taraması yok.
- [ ] Yedek dosyası açılıp `PRAGMA quick_check` ile doğrulandı ve geri yükleme testi başarılı.
- [ ] Yıkıcı göç öncesi yedek dosyası ve `quick_check` kanıtı kayda geçti.

## Kaynaklar
- <https://crates.io/crates/rusqlite> — 0.41.0 sürümü, MIT lisansı ve `bundled` özelliği.
- <https://docs.rs/rusqlite/0.41.0/rusqlite/> — `Connection`, `pragma_update` ve `execute_batch` API'si.
- <https://static.crates.io/readmes/rusqlite_migration/rusqlite_migration-2.6.0.html> — `Migrations`, `to_latest`, `validate` ve `user_version` kullanımı.
- <https://sqlite.org/wal.html> — WAL kipi, tek yazıcı ve okuyucu-yazıcı eşzamanlılığı.
- <https://sqlite.org/pragma.html> — `journal_mode`, `busy_timeout`, `user_version` ve `quick_check` tanımları.
- <https://sqlite.org/foreignkeys.html> — yabancı anahtar zorlamasının varsayılan kapalılığı.
Erişim: 2026-10-27
