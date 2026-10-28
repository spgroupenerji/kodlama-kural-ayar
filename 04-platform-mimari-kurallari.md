# Platform — Uyulması Gereken Temel Mimari Kurallar

> Kaynak: kullanıcı notu (2026-10-28). Bu dosya, ilgili platformlarda mimari karar alırken uyulacak bağlayıcı kuralları madde madde toplar; her bölüm yalnız kendi platformunu bağlar.

## 1. LLM Ajanları (Tool Calling)

1.1. Modelin kodu doğrudan çalıştırmadığını, yalnızca `stop_reason: tool_calls` ile çağrı talebi (JSON) ürettiğini baz al.
1.2. Fonksiyonu istemci/sunucu tarafında yürüttükten sonra çıktıyı `role: tool` mesajı olarak geçmişe ekleyip modeli ikinci kez çağır.

## 2. Oyun Motorları (Unity / Unreal GAS)

2.1. Yetenek yaşam döngüsünü CanActivate (koşul kontrolü) → Commit (mana/cooldown) → Execute (animasyon/efekt) → End sırasıyla kurgula.
2.2. Hasar hesaplamasını tuşa basıldığı an değil, animasyonun ilgili karesindeki AnimNotify olayıyla (Hitbox/Raycast) tetikle.
2.3. Çok oyunculu senkronizasyonda gecikmeyi önlemek için Client-Side Prediction ve sunucu doğrulaması sonrası Rollback / Reconciliation uygula.
2.4. Hasar, menzil ve bekleme süresi gibi değerleri koda gömme; ScriptableObjects veya Data Assets içinde veri odaklı tut.

## 3. Sesli Asistanlar ve Botlar

3.1. Gecikmeyi düşürmek için ses paketlerini WebSockets veya gRPC üzerinden Çift Yönlü Akış (Bi-directional Streaming) ile aktar.
3.2. 3-5 saniyeyi aşan işlemlerde sessizliği önlemek için araya mutlaka Progressive Response (İlerici Yanıt) seslendirmesi ekle.
3.3. Çıktıları ses vurgusu için SSML etiketleri ve ekranlı cihazlar için APL görsel kart şablonlarıyla çok modlu (Multimodal) olarak üret.
