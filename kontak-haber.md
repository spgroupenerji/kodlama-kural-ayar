# Kontak Haber — Haber Çekme ve Yayınlama Kuralları

> Kaynak: kullanıcı notu (2026-10-28). PHP ve Python'un birlikte bulunduğu projelerde haber akışını arka planda toplayıp ön yüze JSON olarak sunmak için uyulacak kuralları, doğrulanmış uç noktaları ve entegrasyon kodlarını madde madde toplar. Aşağıdaki RSS uç noktalarının tamamı 2026-10-28 tarihinde HTTP 200 ve dolu içerik listesiyle doğrulandı; ücretsiz paket kota ve gecikme bilgileri aynı gün sağlayıcıların fiyatlandırma sayfalarından okundu.

## 1. Temel Mimari Kurallar

1.1. CORS'u tarayıcıda aşmaya çalışmayın: Google News ve yayıncı RSS uç noktaları tarayıcıdan doğrudan `fetch` edildiğinde CORS güvenlik engeline takılır. Veriyi sunucu tarafında (PHP veya Python) çekin, ön yüze kendi sunucunuz üzerinden verin.

1.2. Haberleri arka planda toplayın: çekilen veriyi yerel bir JSON dosyasına veya veritabanına kaydedin; ön yüz yalnızca bu hazır dosyayı okusun. Böylece sayfa dış kaynağı beklemeden milisaniyeler içinde açılır.

1.3. Önbellek zorunludur: aynı sorguyu her istekte kaynağa yeniden göndermek hem gecikme hem de kota/rate-limit riski doğurur. Örnek PHP kodunda 15 dakikalık (900 saniye) dosya önbelleği kullanılmıştır.

1.4. Dış veriyi HTML olarak basmayın: RSS başlıkları dış kaynaklı metindir. `innerHTML` ile yazmak XSS'e açık kapı bırakır; `textContent` ve `createElement` kullanın (bkz. 5.3).

1.5. API anahtarlarını istemciye vermeyin: `apikey` / `apiKey` değerleri yalnızca sunucu tarafında (`.env` vb.) tutulmalı; HTML veya JavaScript içine gömülmemelidir.

1.6. Yöntem seçimi: API anahtarı istemiyorsanız Google News veya doğrudan yayıncı RSS'ini; hazır JSON ve zengin alan istiyorsanız ücretsiz haber API'lerinden birini kullanın. Ücretsiz API paketleri geliştirme/test amaçlıdır; yayına alınan ticari projede ücretli plan gerekir.

## 2. Google News Dinamik RSS Kuralları

2.1. Konuya göre arama (API anahtarı gerekmez): `https://news.google.com/rss/search?q={konu}&hl=tr&gl=TR&ceid=TR:tr` — örnek: `q=yapay+zeka` veya `q=kripto+para`.

2.2. Son X saat/gündeki haberler için `when` parametresini kullanın: `https://news.google.com/rss/search?q={konu}+when:1h&hl=tr&gl=TR&ceid=TR:tr` — son 1 saat için `when:1h`, son 7 gün için `when:7d`.

2.3. Belirli bir siteden arama için `site:` işlecini kullanın: `https://news.google.com/rss/search?q=site:{alan-adı}+{konu}&hl=tr&gl=TR&ceid=TR:tr` — örnek: `site:webtekno.com yapay zeka`.

2.4. Kategori bazlı hazır akış: `https://news.google.com/rss/headlines/section/topic/{KONU}?hl=tr&gl=TR&ceid=TR:tr` — teknoloji için `TECHNOLOGY`, bilim için `SCIENCE`.

2.5. Global (İngilizce) arama: `https://news.google.com/rss/search?q={konu}&hl=en-US&gl=US&ceid=US:en`.

2.6. Ortak parametreler: `hl` arayüz dili, `gl` ülke, `ceid` yayın sürümüdür (`TR:tr`, `US:en`). Türkçe içerik için üçünü birlikte `hl=tr&gl=TR&ceid=TR:tr` gönderin; eksik bırakılan parametre farklı dilde sonuç döndürür.

## 3. Doğrudan Yayıncı RSS Kuralları

3.1. Aracısız ve en hızlı yol, yayıncının kendi RSS adresini çekmektir; Google üzerinden geçmediği için başlık ve bağlantılar orijinal kalır.

3.2. Anadolu Ajansı (genel/gündem): `https://www.aa.com.tr/tr/rss/default?cat=guncel`.

3.3. Anadolu Ajansı (bilim/teknoloji): `https://www.aa.com.tr/tr/rss/default?cat=bilim-teknoloji`.

3.4. BBC Türkçe: `https://feeds.bbci.co.uk/turkce/rss.xml`.

3.5. NTV Teknoloji: `https://www.ntv.com.tr/teknoloji.rss`.

3.6. Webtekno: `https://www.webtekno.com/rss.xml`.

3.7. ShiftDelete.Net: `https://shiftdelete.net/feed`.

3.8. DonanımHaber: `https://www.donanimhaber.com/rss/tum/`.

3.9. TechCrunch (yapay zekâ kategorisi): `https://techcrunch.com/category/artificial-intelligence/feed/`.

3.10. The Verge: `https://www.theverge.com/rss/index.xml`.

3.11. MIT Technology Review (yapay zekâ): `https://www.technologyreview.com/topic/artificial-intelligence/feed/`.

3.12. Wired (yapay zekâ): `https://www.wired.com/feed/tag/ai/latest/rss`.

3.13. Ars Technica: `https://feeds.arstechnica.com/arstechnica/index`.

## 4. Ücretsiz Haber API'leri

4.1. GNews API (en pratik alternatif): kayıt `https://gnews.io`, dokümantasyon `https://docs.gnews.io/`. Ücretsiz paket günde 100 istek, istek başına en fazla 10 haber, 12 saat gecikme ve yalnızca ticari olmayan kullanım sunar. İstek yapısı: `https://gnews.io/api/v4/search?q={konu}&lang=tr&country=tr&max=10&apikey={ANAHTAR}`.

4.2. NewsData.io: kayıt `https://newsdata.io`, dokümantasyon `https://newsdata.io/documentation`. Ücretsiz paket günde 200 kredi, son 48 saatlik veri ve 12 saat gecikme sunar. İstek yapısı: `https://newsdata.io/api/1/latest?apikey={ANAHTAR}&q={konu}&language=tr`; anahtar `X-ACCESS-KEY` başlığıyla da gönderilebilir.

4.3. NewsAPI.org: kayıt `https://newsapi.org`, dokümantasyon `https://newsapi.org/docs`. Developer paketi ücretsizdir (günde 100 istek, 24 saat gecikme, bir aylık arşiv) ve yalnızca geliştirme/test içindir; yayın ortamında ücretli plan gerekir. İstek yapısı: `https://newsapi.org/v2/everything?q={konu}&language=tr&apiKey={ANAHTAR}`.

4.4. Ortak kural: ücretsiz kotalar 2026-10-28 itibarıyla yukarıdaki gibidir; sağlayıcılar kotayı haber vermeden değiştirebilir, yayına almadan önce fiyatlandırma sayfasını yeniden kontrol edin.

## 5. Entegrasyon Kodları

5.1. PHP ile çekip JSON olarak sunma (`api.php`): dosyayı sunucuya bu adla kaydedin. 15 dakikalık önbellek içerir; önbellek tazeyse kaynağa hiç gitmez.

```php
<?php
declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');

const CACHE_SURESI = 900;

$konu = trim((string)($_GET['q'] ?? ''));
$konu = $konu !== '' ? $konu : 'yapay zeka';
$sorgu = rawurlencode($konu);
$cacheDosyasi = __DIR__ . '/cache_haber_' . md5($sorgu) . '.json';

if (is_file($cacheDosyasi) && (time() - filemtime($cacheDosyasi)) < CACHE_SURESI) {
    readfile($cacheDosyasi);
    exit;
}

$rssUrl = 'https://news.google.com/rss/search?q=' . $sorgu . '&hl=tr&gl=TR&ceid=TR:tr';
$xml = @simplexml_load_file($rssUrl, SimpleXMLElement::class, LIBXML_NOCDATA);
$haberler = [];

if ($xml !== false) {
    foreach ($xml->channel->item as $item) {
        $haberler[] = [
            'baslik' => (string)$item->title,
            'link'   => (string)$item->link,
            'tarih'  => (string)$item->pubDate,
            'kaynak' => (string)$item->source,
        ];
    }
}

$jsonCikti = json_encode($haberler, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
file_put_contents($cacheDosyasi, $jsonCikti);
echo $jsonCikti;
```

5.2. Python ile arka planda çekip JSON dosyasına yazma (`haber_cek.py`): `pip install feedparser` kurulumu gerekir; çıktı PHP veya JavaScript tarafından doğrudan okunabilir.

```python
import json
import urllib.parse

import feedparser

KONU = "yapay zeka"
EN_FAZLA_HABER = 20

sorgu = urllib.parse.quote(KONU)
rss_url = f"https://news.google.com/rss/search?q={sorgu}&hl=tr&gl=TR&ceid=TR:tr"

besleme = feedparser.parse(rss_url)
haber_listesi = []

for haber in besleme.entries[:EN_FAZLA_HABER]:
    haber_listesi.append({
        "baslik": haber.title,
        "link": haber.link,
        "tarih": haber.get("published", ""),
        "kaynak": haber.source.title if "source" in haber else "Bilinmiyor",
    })

with open("haberler.json", "w", encoding="utf-8") as dosya:
    json.dump(haber_listesi, dosya, ensure_ascii=False, indent=2)
```

5.3. Ön yüzde gösterme (`index.html`): PHP kullanıyorsanız `api.php?q=yapay+zeka`, Python kullanıyorsanız `haberler.json` adresini okutun. Aşağıdaki sürüm dış veriyi `innerHTML` yerine DOM API'siyle yazdığı için XSS'e kapalıdır.

```html
<div id="haber-listesi">Haberler yükleniyor...</div>

<script>
  const kapsayici = document.getElementById("haber-listesi");
  const adres = "api.php?q=yapay+zeka"; // Python çıktısı için: "haberler.json"

  fetch(adres)
    .then((yanit) => {
      if (!yanit.ok) throw new Error("HTTP " + yanit.status);
      return yanit.json();
    })
    .then((haberler) => {
      kapsayici.replaceChildren();
      for (const haber of haberler) {
        const kart = document.createElement("div");
        kart.className = "haber-karti";

        const baslik = document.createElement("h3");
        const baglanti = document.createElement("a");
        baglanti.href = haber.link;
        baglanti.target = "_blank";
        baglanti.rel = "noopener noreferrer";
        baglanti.textContent = haber.baslik;
        baslik.append(baglanti);

        const ayrinti = document.createElement("small");
        ayrinti.textContent = "Kaynak: " + haber.kaynak + " | Tarih: " + haber.tarih;

        kart.append(baslik, ayrinti);
        kapsayici.append(kart);
      }
    })
    .catch((hata) => {
      kapsayici.textContent = "Haberler yüklenemedi.";
      console.error("Haberler çekilemedi:", hata);
    });
</script>
```

## 6. Sonraki Adımlar

6.1. Otomatik haber görselleri (thumbnail): RSS'te görsel standart bir alanda gelmez; `media:content`, `enclosure` ve içerik HTML'indeki `<img>` etiketlerinin ayrı ayrı ayrıştırılması gerekir.

6.2. Veritabanına kayıt: Python tarafında çekilen haberleri MySQL veya SQLite'a yazarken aynı haberin tekrar eklenmesini `link` alanına UNIQUE kısıtı koyarak engelleyin.
