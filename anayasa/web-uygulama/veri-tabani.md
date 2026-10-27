# WEB UYGULAMA — VERİ TABANI ANAYASASI

> Kapsam: Oturumlu panel uygulamalarının MySQL/MariaDB şema tasarımı, sorgulama, işlem, göç ve yedek disiplinini kapsar.
> Öncelik: `AGENTS.md` > bu anayasa > proje içi belgeler
> Doğrulama: 2026-10-27 · context7 + resmî belgeler (bkz. Kaynaklar)

## 1. KAPSAM VE SÜRÜM POLİTİKASI

1.1.1. Bu anayasa, panel uygulamalarının tüm şema, sorgu, göç ve veri erişim süreçlerini bağlar; bu süreçler yalnız DAO katmanında yürütülür ve controller'da SQL bulunamaz.
1.1.2. `AGENTS.md` bu metnin üstündedir; çelişkide Ana Anayasa hükmü uygulanır ve bu metin veri katmanına özgü uzmanlık katmanıdır.
1.1.3. Hedef sunucu MySQL 8.4 LTS'tir ve güncel 8.4 yaması (doğrulama tarihinde 8.4.13) sabitlenir; alt yama sürümüne dönüş ancak yazılı gerekçeyle yapılabilir.
1.1.4. MySQL 8.0 dalı 30 Nisan 2026'da EOL olmuştur ve cPanel sunucusundaki 8.0.45 bu EOL dalındadır; yazılı ve tarihli yükseltme planı olmadan yeni iş yükü 8.0 üzerine kurulamaz.
1.1.5. MariaDB 10.11+ uyumu için şema ve sorgular ortak SQL alt kümesiyle yazılır; sürüme özgü sözdizimi iki motorda test edilmeden üretime giremez.
1.1.6. Doğrulanmamış SQL özelliği, sürüm davranışı veya sürücü parametresi üretim koduna giremez.

## 2. BAĞLANTI, KODLAMA VE SIRLAR

2.1.1. Veritabanı bağlantısı PDO ile kurulur; `ATTR_EMULATE_PREPARES => false`, istisna modu ve sabit `timeout` değeri zorunludur.
2.1.2. Bağlantı karakter kümesi sunucu, şema ve oturum düzeyinde utf8mb4'tür; latin1 veya farklı karakter kümesiyle açılan bağlantı reddedilir.
2.1.3. Türkçe dil duyarlı sıralama gereksinimi yalnız `SHOW COLLATION` çıktısında doğrulanan utf8mb4 kolasyonuyla karşılanır; doğrulanmamış kolasyon adı yapılandırmaya giremez.
2.1.4. Bağlantı bilgileri ve parolalar yalnız `.env` veya secret manager'dan gelir; kod, depo ve loglarda düz metin veritabanı parolası bulunamaz.
2.1.5. Uygulama başına tek PDO örneği kullanılır; sorgu başına yeni bağlantı açılması yasaktır.
2.1.6. Üretim uygulama kullanıcısı yalnız gerekli DML yetkilerine sahiptir; DDL yetkisi göç kullanıcısında ayrı tutulur ve uygulama kullanıcısına `GRANT ALL` verilemez.
2.1.7. Dinamik SQL üretimi yasaktır; her sorgu hazırlanmış deyim ve bağlanmış parametreyle çalışır, değerler SQL metnine birleştirilemez.
2.1.8. Sorgu ve kilit bekleme süreleri oturum düzeyinde üst sınırla tanımlanır; süresiz bekleyen sorgu üretimde çalıştırılamaz.

## 3. ŞEMA VE İNDEKS TASARIMI

3.1.1. Her tabloda birincil anahtar bulunur; birincil anahtarsız tablo ve anlamsız yedek anahtar çoğaltması kabul edilmez.
3.1.2. İlişkiler yabancı anahtar kısıtıyla tanımlanır; uygulama katmanında tutulan ilişki varsayımı kısıt yerine geçemez.
3.1.3. Kolon tipleri en dar ve anlamlı tipte seçilir; metin alanlarında uzunluk sınırsız `TEXT` kullanımı yalnız ölçülmüş gerekçeyle açılabilir, gerekçesiz kullanım yasaktır.
3.2.1. `WHERE`, `JOIN` ve `ORDER BY` içinde kullanılan kolonlar indeksle desteklenmek zorundadır; indekssiz yoğun sorgu üretime giremez ve indeks ayrı göçle eklenir.
3.2.2. İndeksli kolonda fonksiyon, dönüşüm veya ifade kullanımı indeksi devre dışı bıraktığı için yasaktır; gereksinim kolon tipi veya türetilmiş kolonla çözülür.
3.2.3. Baştan jokerli `LIKE '%değer'` araması yasaktır; ihtiyaç tam metin indeksiyle veya önek aramasıyla karşılanır.
3.2.4. Bileşik indeks sırası sorgu desenine göre tanımlanır; aynı kolon kümesini tekrarlayan mükerrer indeks bırakılamaz.

## 4. SORGU DİSİPLİNİ

4.1.1. `SELECT *` yasaktır; her sorguda yalnız ihtiyaç duyulan kolonlar açıkça listelenir.
4.1.2. Döngü içinde ardışık sorgu çalıştırmak (N+1) yasaktır; ilişkili veri tek JOIN veya gruplu IN sorgusuyla çekilir.
4.1.3. Gereksiz `DISTINCT` ve sıralamasız sonuç kümesinde `ORDER BY` kullanımı yasaktır; her ikisi de yalnız ölçülmüş gereksinimle eklenir.
4.1.4. Yeni veya değişen karmaşık sorgu `EXPLAIN` çıktısıyla doğrulanır; büyük tabloda tam tablo taraması gösteren plan kabul edilmez.
4.1.5. Toplu ekleme ve güncelleme tek toplu deyimle yapılır; kayıt başına ayrı deyim açılması yasaktır.
4.1.6. İlişkili veri için JOIN esastır; kontrolsüz alt sorgu yasaktır ve alt sorgu ancak `EXPLAIN` maliyeti JOIN'den düşük çıkarsa kullanılır.
4.2.1. Tüm listeleme uçlarında sayfalama zorunludur; aşılması imkânsız maksimum kayıt limiti tanımlanır.
4.2.2. Büyük hacimlerde sabit maliyetli imleç tabanlı sayfalama (`WHERE id > :imlec LIMIT :adet`) kullanılır.
4.2.3. Her sayfalama isteğinde toplam kayıt sayısı yeniden hesaplanmaz; toplam veri önbellekten sunulur veya sayfalama toplam gerektirmeyecek biçimde tasarlanır.

## 5. İŞLEM, KİLİT VE EŞZAMANLILIK

5.1.1. Birden fazla satırı veya tabloyu etkileyen her yazma işlemi transaction içinde yürütülür; kısmi başarı bırakan işlem kabul edilmez.
5.1.2. Hata anında istisnasız `ROLLBACK` çalışır ve geri alma yapısal loga yazılır.
5.1.3. Transaction içinde harici ağ çağrısı, dosya girdi/çıktısı ve uzun iş mantığı yürütülemez; kilit süresi asgari tutulur.
5.2.1. Eşzamanlı güncellemede sürüm kolonlu iyimser kilitleme veya senaryoya uygun kötümser kilitleme disiplini uygulanır.
5.2.2. Kilit edinme sırası tüm servis genelinde aynı hiyerarşiyle tanımlanır; döngüsel bağımlılık yasaktır.
5.2.3. Kilitlenme (deadlock) hatası sınırlı sayıda, üstel geri çekilmeli yeniden denemeyle karşılanır; sınırsız deneme yasaktır.
5.2.4. Transaction yönetimi merkezi sarmalayıcı işlevde yapılır; alt fonksiyonun kendi başına transaction açması yasaktır.

## 6. GÖÇ (MIGRATION) DİSİPLİNİ

6.1.1. Tüm şema değişiklikleri numaralı göç dosyalarıyla (`goc/0001_*.php` veya `migrations/001_*.php`) sürüm kontrolünde tutulur; elle `ALTER` yasaktır.
6.1.2. Her göç dosyası tek yapısal değişiklik içerir; birden fazla bağımsız değişikliğin tek dosyada birleştirilmesi yasaktır.
6.1.3. Her göç çift yönlüdür; `up` ve `down` blokları eksiksiz tanımlanmadan göç çalıştırılamaz.
6.1.4. Göç sırası korunur ve numara atlaması reddedilir; sıra doğrulanmadan şema yürütülemez.
6.2.1. `DROP TABLE`, `DROP COLUMN` ve geri dönüşsüz dönüşümler yalnız veri güvenli alana alındıktan sonra uygulanır.
6.2.2. Veri kaybı riski taşıyan göç öncesi yedek alınır ve açık onay kayda geçirilir; onaysız yıkıcı göç reddedilir.
6.2.3. Göçler yalnız dağıtım hattından çalıştırılır; uygulama çalışırken elle şema değiştirilemez.

## 7. ERİŞİM, DENETİM VE YEDEK

7.1.1. Veri erişimi rol tabanlıdır ve her rol yalnız yetkisi dâhilindeki veri kapsamını görür; yetki denetimi SQL katmanında da uygulanır.
7.1.2. Denetim kaydı gerektiren okuma ve yazmalar fail-closed çalışır; denetim yazımı başarısızsa işlem tamamlanmaz.
7.1.3. Loglarda parola, token ve kişisel veri `[MASKELI]` olarak maskelenir; maskesiz veritabanı logu güvenlik ihlali sayılır.
7.1.4. Yedekleme politikası yazılıdır ve geri yükleme tatbikatı kayda geçirilmeden politika geçerli sayılamaz.
7.1.5. Yedek dosyaları web'den erişilemez konumda tutulur ve şifrelenir; yedek içinde açık parola bulunamaz.

## Kabul kapısı

- [ ] `mysql -e "SELECT VERSION();"` çıktısı 8.4 dalında ve hedeflenen yama sürümündedir.
- [ ] `mysql -e "SHOW VARIABLES LIKE 'character_set_server';"` değeri `utf8mb4`; bağlantı DSN'i aynı karakter kümesini kullanır.
- [ ] `grep -R 'SELECT \*' destek/ api/ sayfa/` hiçbir eşleşme üretmez.
- [ ] `grep -n 'ATTR_EMULATE_PREPARES' config.php` değeri `false`; tüm sorgular hazırlanmış deyimle çalışır.
- [ ] Yeni/değişen her karmaşık sorgu için `EXPLAIN` çıktısı `docs/` altında kayıtlıdır.
- [ ] `grep -R 'ALTER TABLE\|DROP TABLE\|DROP COLUMN' --include='*.php' .` yalnız göç dosyalarında eşleşir.
- [ ] `ls goc/ migrations/ 2>/dev/null | sort` çıktısında numara boşluğu yok; her dosyada `up` ve `down` blokları mevcut.
- [ ] `mysql -e "SHOW GRANTS FOR '<uygulama_kullanicisi>'@'localhost';"` çıktısında `ALL PRIVILEGES` yok; DDL yetkisi ayrı kullanıcıda.
- [ ] Transaction sarmalayıcısı dışında `BEGIN`/`COMMIT`/`ROLLBACK` çağrısı bulunmaz.
- [ ] MySQL 8.0'dan 8.4'e yükseltme planı tarih ve sorumlu içerir; `git ls-files docs/` çıktısı plan dosyasını ve geri yükleme tatbikatı kaydını gösterir.

## Kaynaklar

1. MySQL 8.4 kolasyon ve Unicode kümeleri — https://dev.mysql.com/doc/refman/8.4/en/charset-unicode-sets.html
2. MySQL sürüm ve EOL çizelgesi — https://endoflife.date/mysql
3. PDO hazırlanmış deyim sabitleri — https://www.php.net/manual/en/pdo.constants.php
4. MariaDB karakter kümesi ve kolasyon belgeleri — https://mariadb.com/kb/en/supported-character-sets-and-collations/
5. MariaDB Server belgeleri — https://mariadb.com/docs/server/

Erişim: 2026-10-27
