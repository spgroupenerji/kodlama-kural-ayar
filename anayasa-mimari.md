# SİSTEM MİMARİSİ, EŞZAMANLILIK VE KOD STANDARTLARI TEKNİK ANAYASASI

---

## 1. ASENKRON DÖNGÜ (EVENT LOOP) VE TIKANMASIZ İŞLEME (ZERO BLOCKING)

### 1.1. Senkron I/O Mutlak Yasağı
Ana `asyncio` olay döngüsü (Event Loop) üzerinde doğrudan bloklayıcı senkron I/O operasyonlarının (senkron dosya okuma/yazma, `requests` kütüphanesi, senkron DB sürücüleri, bloklayıcı soket çağrıları) yürütülmesi kesinlikle yasaktır. Tüm I/O işlemleri ya yerel asenkron sürücülerle (`aiohttp`, `asyncpg`, `aiofiles` vb.) yürütülmeli ya da thread havuzuna delege edilmelidir.

### 1.2. Bloklayıcı ve CPU-Yoğun İşlemlerin İzolasyonu
Olay döngüsünün tick süresini 10 milisaniyenin üzerine çıkarma potansiyeli olan CPU-yoğun rutinler (büyük JSON/XML/Parquet ayrıştırma, karmaşık regex işlemleri, ağır şifreleme/hashleme ve matematiksel telemetri hesaplamaları) münhasıran `asyncio.to_thread` veya tahsisli worker proses havuzuna (`ProcessPoolExecutor`) devredilmek zorundadır.

### 1.3. Mutlak Zaman Aşımı (Timeout) Zorunluluğu
İstisnasız tüm harici ağ ve I/O çağrıları (Modbus TCP, IEC 104, HTTP/REST, gRPC, veritabanı sorguları, mesaj kuyrukları) aşılması imkânsız, katı bir `timeout` parametresi ile sınırlandırılmalıdır. Zaman aşımı koruması bulunmayan hiçbir harici çağrı üretim kodunda yer alamaz.

### 1.4. Görev (Task) Yaşam Döngüsü ve İptal Güvenliği
Olay döngüsünde başlatılan her `asyncio.Task` için güçlü referans (strong reference) tutulmalı; çöp toplayıcının (Garbage Collector) çalışan görevi habersiz sonlandırması engellenmelidir. Tüm görevler `asyncio.CancelledError` istisnasını düzgün biçimde karşılamalı, iptal anında açık kaynakları (soket, kilit, dosya tanıtıcısı) deterministik olarak serbest bırakmalıdır.

---

## 2. EŞZAMANLILIK, THREAD GÜVENLİĞİ VE YARIŞ DURUMLARI (RACE CONDITIONS)

### 2.1. Paylaşılan Korunmasız Durum Yasağı
Olay döngüsü görevleri (coroutine'ler) ile iş parçacıkları (`threading.Thread`, `to_thread`) arasında paylaşılan korumasız ortak bellek nesnelerinin (global `dict`, `list`, ilkel sayaçlar, mutasyona açık nesneler) doğrudan okunması ve yazılması yasaktır.

### 2.2. Katmanlar Arası Veri Takası Disiplini
- Coroutine sınırları içinde görevler arası veri iletişimi `asyncio.Queue` üzerinden yürütülür.
- Coroutine ile iş parçacığı (thread) sınırları arasındaki veri takası `queue.Queue` veya `asyncio.run_coroutine_threadsafe` köprüleri üzerinden tek yönlü ve atomik olarak sağlanır.

### 2.3. Kilit Hiyerarşisi ve Deadlock Önleme
- Paylaşılan ve güncellenen ortak bellek alanları için bağlama uygun kilit (`asyncio.Lock` veya `threading.Lock`) kullanımı zorunludur.
- Kilit koruması altındayken ağ çağrısı, disk I/O veya uzun süreli hesaplama yapılamaz. Kilit yalnızca durum mutasyonu süresince (en küçük kritik kesitte) tutulur ve derhal serbest bırakılır.
- Kilit edinme sıralaması deterministik olmalıdır; iç içe kilitlenmelerde deadlock oluşturacak döngüsel bağımlılıklar kesinlikle yasaktır.

---

## 3. SIRT BASINCI (BACKPRESSURE), BELLEK GÜVENLİĞİ VE KARARLI RİTİM

### 3.1. Sınırsız Kuyruk ve Tampon Yasağı
Sistem genelinde sınırsız (unbounded) bellek içi kuyruk, arabellek (buffer) veya önbellek kullanımı yasaktır. Tüm kuyruklar (`asyncio.Queue(maxsize=...)`) ve tamponlar öngörülebilir bir tavan kapasiteyle tanımlanmalıdır.

### 3.2. Sırt Basıncı (Backpressure) ve Ritim Eşitleme
Üretici (producer) akış hızının tüketici (consumer) kapasitesini aştığı senaryolarda bellek şişmesini ve OOM (Out Of Memory) çöküşlerini engellemek için geri baskı mekanizması işletilmelidir. Kuyruk dolduğunda üretici `await queue.put()` ile asenkron olarak bekletilmeli, akış hızı tüketim hızına kilitlenmelidir.

### 3.3. Kontrollü Yük Atma (Load Shedding) ve Hız Sınırlama
Kuyruk taşması veya sistemin doygunluğa ulaşması durumunda kontrolsüz çökme yerine deterministik stratejiler (en eski veriyi düşürme - drop oldest, yeni veriyi reddetme - drop newest veya HTTP 429 / 503 ile hız sınırlama) devreye alınmalıdır. Her veri düşürme vakası yapısal bir sayaç metriği ile kayıt altına alınmalıdır.

---

## 4. HATA DİRENÇLİLİĞİ, İSTİSNA YÖNETİMİ VE SESSİZ HATA YASAĞI

### 4.1. Sessiz Hata ve Yutma Yasağı
İstisnaları yutan, iz bırakmayan veya bağlamı temizleyen kör bloklar (`except: pass`, `except Exception: return None`) kesinlikle yasaktır. Yakalanan her istisna, hatanın sınıfı, mesajı, çağrı yığını (traceback) ve tetikleyici parametreleriyle birlikte uygun log seviyesinde (`ERROR` / `CRITICAL`) kaydedilmelidir.

### 4.2. İşlem Geri Alma (Rollback) ve Tutarlılık Garantisi
Veritabanı, dağıtık işlem veya çok adımlı durum güncellemelerinde hata oluştuğunda istisnasız `ROLLBACK` işletilmelidir. Başarısız adımların ardından sistem asla kısmi güncellenmiş (kirli/inconsistent) durumda bırakılamaz; geri alma operasyonu yapısal loglara yazılmalıdır.

### 4.3. Yeniden Deneme (Retry) ve Fırtına Önleme Disiplini
- Geçici dış ağ/servis hatalarında kontrolsüz `while True` döngüleri ve ani toplu yeniden denemeler (retry storm) yasaktır.
- Yeniden deneme mekanizmaları kesin bir tavan deneme sayısına (`max_retries`), üstel geri çekilmeye (`exponential backoff`) ve rastgele sapmaya (`jitter`) sahip olmak zorundadır.
- Sürekli başarısız olan dış bağımlılıklar için Devre Kesici (Circuit Breaker) deseni uygulanarak downstream servislerin boğulması engellenmelidir.

---

## 5. KOD ORGANİZASYONU, YERLEŞİM VE TEMİZLİK STANDARTLARI

### 5.1. Tek Müşterili Kod İlkesi (Single-Consumer Co-location)
Yalnızca tek bir modül, servis veya sınıf tarafından tüketilen özel (private) fonksiyonlar, yardımcılar ve veri yapıları harici/ortak kütüphanelere dağıtılamaz. Bu işlevler doğrudan çağıran modülün kendi dosyasında (inline/private) tutulur; paylaşımlı kod tabanının lüzumsuz şişmesi önlenir.

### 5.2. Çok Müşterili Kod İlkesi (Multi-Consumer Extraction)
İki veya daha fazla bağımsız servis tarafından paylaşılan, genel geçer ve yan etkisiz mantıklar `destek/` (`utils/`, `common/`, `lib/`) dizini altında bağımsız, yüksek uyumlu (high cohesion) kütüphaneler halinde soyutlanır. Ortak kütüphaneler üst katman iş mantığına (business logic) bağımlı olamaz (Ters Bağımlılık Prensibi).

### 5.3. Yorum Satırı Tasfiyesi ve Açıklayıcı Kod
- Kodun kendisi adlandırması, tipleri ve yapısıyla amacını doğrudan açıklamalıdır (Self-Documenting Code).
- Bariz olanı tekrarlayan (`# id değerini atar`, `// veriyi çeker`), geçici (TODO/FIXME), ölü kod veya yoruma alınmış kod blokları üretim kod tabanından tamamen tasfiye edilir.
- Yorum satırlarına yalnızca; standart dışı protokol gereksinimleri, karmaşık matematiksel algoritmalar ve "kodun neden böyle yazılmak zorunda olduğunu" açıklayan mimari zorunluluklarda izin verilir.

---

## 6. TİP GÜVENLİĞİ VE VERİ SÖZLEŞMELERİ (TYPE CONTRACTS)

### 6.1. Tam Tip Belirteci (Strict Type Hinting)
Tüm fonksiyon, metot ve modül arayüzlerinde parametre tipleri ve dönüş tipleri (`return type`) eksiksiz olarak belirtilmelidir. Açıklanamayan veya kaçamak `Any` tipi kullanımı yasaktır; jenerikler (`TypeVar`, `Generic`) ve birlikler (`Union`, `Optional`) açıkça tanımlanmalıdır.

### 6.2. Katı Veri Doğrulama ve Modeller
Sistem sınırlarından (HTTP payload, MQTT iletisi, DB okuması, telemetri paketi) giren tüm yapılandırılmamış veriler katı şemalar (`Pydantic`, `dataclass(frozen=True)` veya `TypedDict`) ile doğrulanmadan iç katmanlara aktarılamaz. İlkel Saplantısı (Primitive Obsession) yerine alan modelleri (Value Objects) tercih edilmelidir.

---

## 7. GÖZLENEBİLİRLİK VE YAPISAL LOGLAMA (STRUCTURED LOGGING)

### 7.1. Yapısal JSON Günlükleme
Üretim ortamında ham metin (string formatlama / f-string) ile loglama yapılamaz. Tüm loglar makine tarafından okunabilir yapısal formatta (JSON) üretilmeli; standart olarak `timestamp`, `level`, `trace_id` / `correlation_id`, `module`, `function` ve bağlamsal metadata alanlarını içermelidir.

### 7.2. Hassas Veri İzolasyonu (Zero Leakage)
Log satırlarına parola, kimlik doğrulama anahtarı (token/API key), kişisel veri (PII) veya ham gizli telemetri verilerinin sızması mutlak surette engellenmelidir. Loglayıcılar bu alanları maskelemekle yükümlüdür.