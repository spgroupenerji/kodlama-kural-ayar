# Üretim Skill Mimarisi — Uyulması Gereken Temel Mühendislik Kuralları

> Kaynak: kullanıcı notu (2026-10-28). Üretim (production) seviyesinde eksiksiz, güvenli ve ölçeklenebilir bir Skill (Yetenek) mimarisi kurarken uyulacak temel mühendislik kurallarını madde madde toplar; her bölüm kendi konusunu bağlar.

## 1. Niyet Algılama ve Yönlendirme Kuralları

1.1. Yetenekleri bağlama doğrudan yüklemeyin (Semantic Routing): Binlerce yeteneği doğrudan LLM istemine (prompt) eklemek yerine, kullanıcı girdisini bir embedding modelinden (`text-embedding-3-large` vb.) geçirerek vektöre dönüştürün. Kosinüs benzerliği veya HNSW algoritmasıyla vektör veritabanından yalnızca en alakalı 3-5 yeteneği filtreleyip modele sunun.

1.2. Şema uyumunu matematiksel olarak zorunlu kılın (Constrained Decoding): Modelin uydurma parametre üretmesini engellemek için çıktı katmanında Sonlu Durum Makineleri (FSM) ve Bağlamdan Bağımsız Gramerler (CFG — Outlines, Guidance) kullanın. Logit Bias ile geçersiz token'ları anlık maskeleyerek JSON şemasına %100 uyumu garanti altına alın.

1.3. Geleneksel/sesli sistemlerde deterministik boru hatları kurun: Sesli asistanlarda girdiyi önce ASR ile metne çevirin, ardından BiLSTM-CRF veya BERT tabanlı modellerle BIO etiketlemesi (Beginning, Inside, Outside) yaparak varlık çıkarımı (Slot Filling) uygulayın.

1.4. Belirsizlik durumunda çalıştırmayı durdurun (Disambiguation): Girdi birden fazla yeteneği tetikliyorsa veya güven skoru (Confidence Score) belirlenen eşik değerinin (örneğin 0.75) altındaysa yeteneği doğrudan çalıştırmayın; "Geri Sorarak Netleştirme" (Fallback Clarification) adımına geçin.

## 2. Şema, Sözleşme ve Protokol Kuralları

2.1. Evrensel standart olarak MCP kullanın: Her LLM sağlayıcısı için ayrı entegrasyon yazmak yerine JSON-RPC 2.0 tabanlı Model Bağlam Protokolü (MCP) standardını benimseyin. İstemci-sunucu iletişimini yerel süreçlerde Stdio, uzak sunucularda SSE (Server-Sent Events) üzerinden kurgulayın.

2.2. Sıkı AST doğrulaması uygulayın: Şemalarda yalnızca ilkel veri tipleriyle yetinmeyin; `anyOf`, `oneOf`, `allOf` gibi polimorfik yapıları, düzenli ifadeleri (`pattern: "^[A-Z]{2}[0-9]{4}$"`) ve iç içe geçmiş (nested) dizileri doğrulama katmanına dahil edin.

2.3. Şema içi bilişsel yükü optimize edin: Modelin dikkat dağınıklığını önlemek için parametre açıklamalarına doğrudan olumlu/olumsuz sınırlar ("Şu durumda kullan, şu durumda ASLA kullanma") ve az örnekli istemler (Few-Shot Examples) gömün.

2.4. Geriye dönük uyumluluğu koruyun (Schema Versioning): Yetenek güncellemelerinde Semantic Versioning (v1.2.0) kullanın. Kaldırılacak parametreleri `deprecated: true` olarak işaretleyin ve çalışma zamanında eski çağrıları yeni şemaya dönüştüren bir Adapter Pattern katmanı bulundurun.

## 3. Çalışma Zamanı ve Orkestrasyon Kuralları

3.1. Karmaşık görevleri çizge (graph) olarak modelleyin: Tek bir yeteneğin yetmediği senaryolarda (LangGraph vb.) yetenekleri düğüm (Node), geçiş koşullarını ise kenar (Edge) olarak tanımlayın.

3.2. Paralel ve zincirleme yürütmeyi ayırın: Birbirinden bağımsız yetenekleri `asyncio.gather` veya `Promise.all` ile paralel (Fan-out / Fan-in) tetikleyin; bağımlı işlemlerde ise bir yeteneğin çıktısını diğerinin girdisi yapacak şekilde ardışık zincirleme (Sequential Chaining) kurun.

3.3. Tekrarlanan işlem güvenliği sağlayın (Idempotency): Ağ kopmaları yüzünden kritik işlemlerin (örneğin `para_gonder`) mükerrer çalışmasını önlemek için her çağrıya benzersiz bir `Idempotency-Key` (UUID) atayın. Aynı anahtarla gelen ikinci isteği çalıştırmayıp ilk işlemin önbellekteki sonucunu dönün.

3.4. Soğuk başlangıç (Cold Start) gecikmesini önleyin: Serverless (AWS Lambda vb.) ortamlarda ilk tetikleme gecikmesini ortadan kaldırmak için Provisioned Concurrency (sıcak konteynerler) veya WebAssembly (WASM) / V8 Isolates gibi hafifletilmiş çalışma zamanları tercih edin.

## 4. Durum, Bellek ve Bağlam Kuralları

4.1. Her adımda durumu yedekleyin (Checkpointing): Sunucu çökmelerine karşı işlemin kaldığı yerden devam edebilmesi için her adımda durumu (State) JSON veya Protobuf ile serileştirerek Redis ya da PostgreSQL'e kaydedin.

4.2. Bağlam penceresini aktif yönetin (Context Eviction): Konuşma uzadıkça belleğin taşmasını önlemek için en eski yetenek çıktılarını FIFO (İlk Giren İlk Çıkar) yöntemiyle silin veya küçük bir LLM kullanarak özetleyip (Summarization) sıkıştırın.

4.3. Hassas verileri şemadan gizleyin (Dependency Injection): `user_id`, `session_token` veya `tenant_id` gibi güvenlik verilerini asla LLM'in gördüğü şemaya eklemeyin. Modelin yalnızca iş mantığı parametrelerini üretmesini sağlayın; hassas verileri fonksiyon çalışmadan hemen önce orkestrasyon katmanında pakete enjekte edin.

4.4. Epizodik ve semantik belleği ayırın: Geçmişte hangi yeteneklerin hangi sırayla çağrıldığını ve sonuçlarını tutmak için Epizodik Bellek (Vector DB); kullanıcıya dair kalıcı gerçekleri saklamak için Semantik Bellek (Knowledge Graphs — Neo4j) kullanın.

## 5. Güvenlik, İzolasyon ve Yönetişim Kuralları

5.1. Dolaylı istem enjeksiyonuna (Indirect Prompt Injection) karşı filtreleme yapın: Dış dünyadan (web sayfası, belge vb.) çekilen verileri `untrusted_data` etiketleriyle izole edin ve ana modele iletmeden önce mutlaka hızlı bir güvenlik modeliyle (Guardrail Model — örn. Llama Guard) tarayın.

5.2. Donanım/çekirdek seviyesinde kum havuzu (Sandboxing) kullanın: Kod çalıştıran yetenekleri konteyner kaçış zafiyetleri nedeniyle standart Docker konteynerlerinde çalıştırmayın; AWS Firecracker (MicroVM), gVisor veya WASM ile izole edin.

5.3. Katı kaynak kısıtlamaları (cgroups) uygulayın: Sonsuz döngüleri ve sistem kilitlenmelerini önlemek için her yeteneğin CPU süresini (örn. maksimum 5 saniye), RAM kullanımını (örn. maksimum 256 MB) ve ağ erişimini (Egress Filtering ile yalnızca izin verilen IP'ler) sınırlandırın.

5.4. Kritik işlemlerde insan onayı (HITL) zorunluluğu koyun: Veri silme, satın alma veya e-posta gönderme gibi kritik yetenekleri şemada `requires_confirmation: true` olarak işaretleyin. Bu bayrak görüldüğünde işlemi duraklatın (Interrupt) ve kullanıcıdan kriptografik olarak imzalanmış onay gelmeden kodu yürütmeyin.

## 6. Hata Yönetimi, Dayanıklılık ve Çıktı İşleme Kuralları

6.1. Kendi kendini düzeltme döngüsü (Self-Correction) kurun: Çalışma sırasında oluşan `ValidationError` veya `SyntaxError` hatalarını doğrudan kullanıcıya göstermeyin. Hata mesajını ve yığın izini (Stack Trace) yakalayıp modele geri besleyerek parametreleri düzeltmesini isteyin ve bunu `max_retries: 3` ile sınırlandırın.

6.2. Devre kesici ve üstel geri çekilme uygulayın: Yanıt vermeyen dış API'ler için rastgele gecikme (Jitter) ekleyerek 1-2-4-8 saniye şeklinde üstel bekleme (Exponential Backoff) yapın. Hata oranı %50'yi aşarsa Circuit Breaker (Devre Kesici) mekanizmasını devreye sokarak istekleri durdurun ve anında yedek (Fallback) yanıt dönün.

6.3. Büyük çıktıları kırpın ve referansla taşıyın (Payload Pruning): Dış API'lerden dönen büyük JSON yanıtlarını JSONPath veya JQ filtreleriyle kırparak yalnızca modelin karar vermesi için gereken kısmı (örn. 50 KB yerine 500 byte) iletin. CSV veya PDF gibi büyük dosyaları modele göndermek yerine nesne depolama alanına (S3) yazıp modele yalnızca `file_id` referansı verin.

## 7. Gözlemlenebilirlik, Test ve Değerlendirme Kuralları

7.1. Uçtan uca dağıtık izleme (Distributed Tracing) kurun: OpenTelemetry standartlarını (LangSmith, Arize Phoenix, Datadog) kullanarak her yetenek çağrısının gecikme süresini (Latency), harcanan token miktarını, maliyetini ve ara adımlarını (Spans) kayıt altına alın.

7.2. Üç katmanlı test stratejisi (Skill Evals) uygulayın:
7.2.1. Deterministik birim testleri: Arka uç kodunu sahte (Mock) API'lerle test edin.
7.2.2. Yönlendirme testleri (Routing Evals): Geniş kullanıcı cümlesi veri setleriyle (örn. 1000 cümle) modelin doğru yeteneği seçme başarısını (Precision & Recall) ölçün.
7.2.3. LLM-as-a-Judge: Üretilen nihai çıktının doğruluğunu, tonunu ve halüsinasyon durumunu üst düzey bir hakem LLM ile puanlayın.

## 8. Platforma Özel Mimari Kurallar

> Bu bölümdeki kurallar yalnızca ilgili platformu bağlar; genel Skill mimarisi kuralları §1–§7'de tanımlıdır.

### 8.1. LLM Ajanları (Tool Calling)

8.1.1. Modelin kodu doğrudan çalıştırmadığını, yalnızca `stop_reason: tool_calls` ile çağrı talebi (JSON) ürettiğini baz alın.
8.1.2. Fonksiyonu istemci/sunucu tarafında yürüttükten sonra çıktıyı `role: tool` mesajı olarak geçmişe ekleyip modeli ikinci kez çağırın.

### 8.2. Oyun Motorları (Unity / Unreal GAS)

8.2.1. Yetenek yaşam döngüsünü CanActivate (koşul kontrolü) → Commit (mana/cooldown) → Execute (animasyon/efekt) → End sırasıyla kurgulayın.
8.2.2. Hasar hesaplamasını tuşa basıldığı an değil, animasyonun ilgili karesindeki AnimNotify olayıyla (Hitbox/Raycast) tetikleyin.
8.2.3. Çok oyunculu senkronizasyonda gecikmeyi önlemek için Client-Side Prediction ve sunucu doğrulaması sonrası Rollback / Reconciliation uygulayın.
8.2.4. Hasar, menzil ve bekleme süresi gibi değerleri koda gömmeyin; ScriptableObjects veya Data Assets içinde veri odaklı tutun.

### 8.3. Sesli Asistanlar ve Botlar

8.3.1. Gecikmeyi düşürmek için ses paketlerini WebSockets veya gRPC üzerinden Çift Yönlü Akış (Bi-directional Streaming) ile aktarın.
8.3.2. 3-5 saniyeyi aşan işlemlerde sessizliği önlemek için araya mutlaka Progressive Response (İlerici Yanıt) seslendirmesi ekleyin.
8.3.3. Çıktıları ses vurgusu için SSML etiketleri ve ekranlı cihazlar için APL görsel kart şablonlarıyla çok modlu (Multimodal) olarak üretin.
