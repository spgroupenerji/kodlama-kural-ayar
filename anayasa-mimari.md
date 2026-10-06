# SİSTEM MİMARİSİ, EŞZAMANLILIK VE KOD STANDARTLARI TEKNİK ANAYASASI

1.1.1. Ana `asyncio` olay döngüsünde (Event Loop) bloklayıcı senkron I/O operasyonlarının (`requests`, senkron DB sürücüleri, bloklayıcı soket/dosya çağrıları) yürütülmesi kesinlikle yasaktır; tüm I/O yerel asenkron sürücülerle (`aiohttp`, `asyncpg`, `aiofiles`) veya thread havuzunda yürütülür.
1.2.1. Olay döngüsü tick süresini 10 ms üzerine çıkarma potansiyeli olan CPU-yoğun rutinler (büyük JSON/XML/Parquet ayrıştırma, regex, telemetri matematiği, şifreleme/hashleme) münhasıran `asyncio.to_thread` veya `ProcessPoolExecutor` havuzuna devredilmek zorundadır.
1.3.1. İstisnasız tüm harici ağ ve I/O çağrıları (Modbus TCP, IEC 104, HTTP, gRPC, veritabanı sorguları, mesaj kuyrukları) aşılması imkânsız, katı bir `timeout` parametresi ile sınırlandırılmalıdır; zaman aşımı koruması bulunmayan çağrılar üretim kodunda yer alamaz.
1.4.1. Olay döngüsünde başlatılan her `asyncio.Task` için çöp toplayıcı (GC) tasfiyesini önleyecek güçlü referans (strong reference) tutulmalı; tüm görevler `asyncio.CancelledError` istisnasını yakalayarak açık kaynakları (soket, kilit, dosya tanıtıcısı) deterministik olarak serbest bırakmalıdır.
2.1.1. Olay döngüsü coroutine'leri ile iş parçacıkları (`Thread`, `to_thread`) arasında paylaşılan korumasız bellek nesnelerinin (global `dict`, `list`, ilkel sayaçlar) doğrudan okunması ve yazılması yasaktır.
2.2.1. Coroutine sınırları içinde görevler arası veri iletişimi münhasıran `asyncio.Queue` üzerinden yürütülür.
2.2.2. Coroutine ile thread sınırları arasındaki veri takası `queue.Queue` veya `asyncio.run_coroutine_threadsafe` köprüleri üzerinden tek yönlü ve atomik olarak sağlanır.
2.3.1. Paylaşılan ve mutasyona açık bellek alanları için bağlama uygun kilit (`asyncio.Lock` veya `threading.Lock`) kullanımı zorunludur.
2.3.2. Kilit koruması altındayken ağ çağrısı, disk I/O veya uzun süreli hesaplama yapılamaz; kilit yalnızca en küçük kritik kesitte (durum mutasyonu süresince) tutulur ve derhal bırakılır.
2.3.3. Kilit edinme sıralaması deterministik olmalıdır; iç içe kilitlenmelerde deadlock oluşturacak döngüsel bağımlılıklar kesinlikle yasaktır.
3.1.1. Sistem genelinde sınırsız (unbounded) bellek içi kuyruk, arabellek veya önbellek kullanımı yasaktır; tüm kuyruklar (`asyncio.Queue(maxsize=...)`) öngörülebilir bir tavan kapasiteyle tanımlanmak zorundadır.
3.2.1. Üretici hızı tüketici kapasitesini aştığında bellek şişmesini ve OOM çöküşlerini önlemek için sırt basıncı (backpressure) uygulanır; kuyruk dolduğunda üretici `await queue.put()` ile asenkron bekletilerek veri akışı tüketim hızına kilitlenir.
3.3.1. Doygunluk ve taşma durumlarında kontrolsüz çökme yerine deterministik yük atma (en eskiyi düşürme, en yeniyi reddetme veya HTTP 429/503) işletilmeli; düşürülen her veri yapısal sayaç metriği ile kaydedilmelidir.
4.1.1. İstisnaları yutan veya bağlamı gizleyen kör bloklar (`except: pass`, `except Exception: return None`) kesinlikle yasaktır; yakalanan her istisna sınıfı, mesajı, çağrı yığını (traceback) ve tetikleyici parametreleriyle uygun seviyede (`ERROR`/`CRITICAL`) loglanmalıdır.
4.2.1. Veritabanı ve çok adımlı durum güncellemelerinde hata oluştuğunda istisnasız `ROLLBACK` işletilmeli; sistem asla kısmi/tutarsız durumda bırakılmamalı ve geri alma işlemi yapısal loglara yazılmalıdır.
4.3.1. Geçici ağ ve servis hatalarında kontrolsüz `while True` döngüleri ve fırtınaya (retry storm) yol açacak ani yeniden denemeler yasaktır.
4.3.2. Yeniden deneme mekanizmaları kesin bir tavan deneme sayısı (`max_retries`), üstel geri çekilme (`exponential backoff`) ve rastgele sapma (`jitter`) içermek zorundadır.
4.3.3. Sürekli başarısız olan dış bağımlılıklar için Devre Kesici (Circuit Breaker) deseni uygulanarak downstream servislerin tıkanması engellenmelidir.
5.1.1. Yalnızca tek bir modül veya servis tarafından tüketilen özel (private) fonksiyonlar ve veri yapıları harici kütüphanelere dağıtılamaz; doğrudan çağıran modülün kendi dosyasında (inline/private) tutulur.
5.2.1. İki veya daha fazla bağımsız servis tarafından paylaşılan, genel geçer ve yan etkisiz mantıklar `destek/` (`utils/`, `common/`) altında yüksek uyumlu kütüphaneler halinde soyutlanır; ortak kütüphaneler üst iş mantığına (business logic) bağımlı olamaz.
5.3.1. Kod adlandırması, tipleri ve mimarisiyle amacını doğrudan açıklamalıdır (Self-Documenting Code).
5.3.2. Bariz mantığı tekrarlayan, geçici (TODO/FIXME), ölü veya yoruma alınmış kod blokları üretim kod tabanından tamamen tasfiye edilir.
5.3.3. Yorum satırlarına yalnızca standart dışı protokol gereksinimleri, karmaşık matematiksel algoritmalar ve mimari zorunluluk gerekçelerinde izin verilir.
6.1.1. Tüm fonksiyon, metot ve modül arayüzlerinde parametre ve dönüş tipleri (`return type`) eksiksiz tanımlanmalıdır; gerekçesiz `Any` kullanımı yasaktır, jenerikler (`TypeVar`, `Generic`) ve birlikler (`Union`, `Optional`) açıkça belirtilmelidir.
6.2.1. Sistem sınırlarından (HTTP, MQTT, DB, telemetri) giren tüm yapılandırılmamış veriler katı şemalar (`Pydantic`, dondurulmuş `dataclass` veya `TypedDict`) ile doğrulanmadan iç katmanlara aktarılamaz; ilkel tipler yerine alan modelleri (Value Objects) esastır.
7.1.1. Üretim ortamında string formatlama veya f-string ile loglama yapılamaz; tüm loglar makine tarafından okunabilir yapısal formatta (JSON) ve standart metadata (`timestamp`, `level`, `trace_id`/`correlation_id`, `module`, `function`) alanlarıyla üretilmelidir.
7.2.1. Log satırlarına parola, kimlik doğrulama anahtarı (token/API key), kişisel veri (PII) veya gizli telemetri verilerinin sızması mutlak surette engellenmeli; loglayıcılar bu alanları maskelemekle yükümlüdür.
