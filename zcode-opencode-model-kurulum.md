# ZCode + OpenCode Model Kurulum Notu

> Kaynak: `zcode-opencode-model-kurulum.md` (metin belgesi, içerik eksiksiz aktarıldı)

İki ayrı katman var, birbirini etkilemez:

| Katman | Model listesini okuduğu yer |
| --- | --- |
| OpenCode CLI | `~/.cache/opencode/models.json` |
| ZCode Desktop | `~/.zcode/v2/provider_config.json` |

Windows'ta `~` = `C:\Users\<kullanıcı>`.

---

## 1) OpenCode CLI: Yeni Model Listede Yoksa

Önce desteklenen tazeleme komutunu dene:

```bash
opencode models --refresh
opencode models | grep -i minimax
```

Hâlâ yoksa önbellek dosyasını kenara alıp yeniden oluştur:

```bash
mv ~/.cache/opencode/models.json ~/.cache/opencode/models.json.bak-$(date +%s)
opencode models
```

Doğrulama:

```bash
opencode run -m opencode-go/minimax-m3.1-flash-free --variant max "Sadece OK yaz"
```

Notlar:

- `opencode models` yalnızca `status != deprecated` modelleri listeler. models.dev'de görünüp CLI'de görünmeyen model "eksik" değil, emekliye ayrılmıştır.
- Effort seçimi CLI'da `--variant` iledir (`low`, `medium`, `high`, `xhigh`, `max`).
- Önbellek 7 gün bayat kalabilir; şüphelendiğinde `--refresh` yeterlidir.

---

## 2) ZCode Desktop: Modele Listeye Ekleme

ZCode model üyeliğini `~/.zcode/v2/provider_config.json` içindeki üç yerden okur:

1. `providerRules[].config.personalModelIds`
2. `providerRules[].config.modelOrder`
3. `modelConfigRules.providerModelRules[]` → `config.enabled: true`

Sağlayıcıyı silip yeniden eklemek bu listeyi `C:\Program Files\ZCode\resources\config\provider\zcode-builtin.json` şablonundan yeniden üretir. Şablon eskiyse yeni model gelmez; önceki kişisel ücretsiz modeller de silinir.

### Adımlar

1. **ZCode'u kapat** (açıkken yapılandırmayı geri yazabilir).
2. Aşağıdaki betiği Git Bash'te çalıştır. Yedek alır, üç alanı idempotent biçimde ekler.
3. ZCode'u aç; model **OpenCode Go (Chat)** altında görünür.

```bash
node - <<'NODE'
const fs = require('fs');
const path = require('path');
const os = require('os');

const MODEL     = 'minimax-m3.1-flash-free';
const PROVIDER  = 'opencode-go-chat';
const EFFORT    = ['low', 'medium', 'high', 'xhigh', 'max'];
const MAX_OUTPUT = 512000;

const file = path.join(os.homedir(), '.zcode', 'v2', 'provider_config.json');
if (!fs.existsSync(file)) throw new Error('Bulunamadı: ' + file);

const backup = `${file}.bak-${new Date().toISOString().replace(/[:.]/g, '-')}`;
fs.copyFileSync(file, backup);

const cfg = JSON.parse(fs.readFileSync(file, 'utf8'));
const provider = cfg.config.providerConfigRules.providerRules
  .find(p => p.providerId === PROVIDER);
if (!provider) throw new Error('Sağlayıcı bulunamadı: ' + PROVIDER);

const pc = provider.config;
pc.personalModelIds = Array.isArray(pc.personalModelIds) ? pc.personalModelIds : [];
pc.modelOrder = Array.isArray(pc.modelOrder) ? pc.modelOrder : [];
if (!pc.personalModelIds.includes(MODEL)) pc.personalModelIds.push(MODEL);
if (!pc.modelOrder.includes(MODEL)) pc.modelOrder.push(MODEL);

const rules = cfg.config.modelConfigRules.providerModelRules;
let rule = rules.find(r => r.providerId === PROVIDER && r.modelId === MODEL);
if (!rule) {
  rule = { modelId: MODEL, providerId: PROVIDER, config: {} };
  rules.push(rule);
}
rule.config = {
  ...rule.config,
  enabled: true,
  optionSpecs: {
    ...(rule.config.optionSpecs || {}),
    reasoningLevel: { values: EFFORT },
    maxOutputTokens: { max: MAX_OUTPUT }
  }
};

fs.writeFileSync(file, JSON.stringify(cfg, null, 2) + '\n');
console.log('Tamam:', file);
console.log('Yedek:', backup);
NODE
```

### Anthropic Uç Noktasını Kullanacaksan

Aynı betikte yalnızca `PROVIDER = 'opencode-go-messages'` yap. Bu yol bu makinede test edilmedi; önce Chat sağlayıcısında doğrula.

### Node Yoksa

`provider_config.json` içinde elle üç değişiklik yap:

- `opencode-go-chat` → `personalModelIds` dizisine model kimliğini ekle.
- Aynı sağlayıcının `modelOrder` dizisine ekle.
- `providerModelRules` içine şu kaydı ekle:

```json
{
  "modelId": "minimax-m3.1-flash-free",
  "config": {
    "enabled": true,
    "optionSpecs": {
      "reasoningLevel": { "values": ["low", "medium", "high", "xhigh", "max"] },
      "maxOutputTokens": { "max": 512000 }
    }
  },
  "providerId": "opencode-go-chat"
}
```

---

## 3) Effort Seçici Neden Boştu

ZCode'da akıl yürütme seviyesi `config.optionSpecs.reasoningLevel.values` alanından gelir. Model kaydında bu alan yoksa seçici görünmez.

`minimax-m3.1-flash-free` için doğrulanan değerler:

```text
low, medium, high, xhigh, max
```

- Uç nokta geçerli değerlere **200**, geçersiz değere **400** döndü.
- `maxOutputTokens.max` gerçek sınır olan `512000` yapıldı.
- Değerler modele göre değişir; başka model eklerken models.dev kaydındaki `reasoning_options` listesini kullan.

---

## 4) Kritik Noktalar

- **İki katman ayrı:** OpenCode CLI önbelleğini düzeltmek ZCode listesini düzeltmez; tersi de geçerli.
- **Sağlayıcı silme/ekleme yıkıcıdır:** `personalModelIds` ve `modelOrder` şablondan sıfırlanır. İşlemden sonra betiği yeniden çalıştır.
- **`zcode-builtin.json` düzenleme:** Program Files altındadır, güncellemede ezilir. Kişisel ayarlar yalnızca `provider_config.json`'a yazılır.
- **Şema doğrulaması vardır:** `optionSpecs` yanlış biçimdeyse ZCode `invalid-option-spec` verir. `reasoningLevel` → `{ "values": [...] }` biçiminde kalmalı.
- **Geçersiz effort değeri 400 döndürür:** Uydurma seviye eklemeyin.
- **`x-opencode-session` başlığı:** `https://opencode.ai/zen/go/v1/chat/completions` ham çağrılarında bu başlık yoksa `400 MissingSessionID` gelir. Bu bir model/abonelik hatası değildir; ZCode ve OpenCode bu başlığı kendisi gönderir.
- **API anahtarı:** `provider_config.json` içindeki anahtarı kopyalayıp komut satırına, betiğe veya loga yazmayın; betik anahtarı hiç okumaz.
- **Yedek:** Her düzenlemeden önce `.bak-*` kopyası alın; geri dönüş tek `cp` ile yapılır.
- **Deprecated modeller:** models.dev'de olup CLI'de olmayanlar genellikle `status: deprecated`'tır; peşine düşmeyin.

---

## 5) Geri Alma

```bash
# ZCode
cp ~/.zcode/v2/provider_config.json.bak-YYYYMMDD-HHMMSS ~/.zcode/v2/provider_config.json

# OpenCode CLI
mv ~/.cache/opencode/models.json.bak-<zaman> ~/.cache/opencode/models.json
```

---

## 6) Kontrol Listesi

- [ ] `opencode models | grep minimax` modeli listeliyor.
- [ ] `opencode run ... --variant max "Sadece OK yaz"` çalışıyor.
- [ ] ZCode kapalıyken betik çalıştırıldı, yedek alındı.
- [ ] ZCode yeniden açıldı; model OpenCode Go (Chat) altında görünüyor.
- [ ] Effort menüsünde `low / medium / high / xhigh / max` seçenekleri var.
- [ ] Seçilen seviye oturumda gerçekten uygulanıyor (UI görünürlüğü doğrulanmalı).
