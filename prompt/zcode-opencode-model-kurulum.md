# ZCode + OpenCode Model Kurulum Notu

> Kaynak: bu depoda bizzat doğrulanan kurulum ve models.dev canlı kataloğu (`opencode models --refresh`, 2026-10-24).

İki ayrı katman var, birbirini etkilemez:

| Katman | Model listesini okuduğu yer |
| --- | --- |
| OpenCode CLI | `~/.cache/opencode/models.json` |
| ZCode Desktop | `~/.zcode/v2/provider_config.json` |

Windows'ta `~` = `C:\Users\<kullanıcı>`.

---

## 1) Kurulu Modeller (2026-10-24)

Hepsi `opencode-go-chat` (OpenCode Go · Chat) sağlayıcısı altında, üç alanı da eksiksiz:

| Model | Effort | maxOutputTokens | Bağlam / Çıktı |
| --- | --- | --- | --- |
| `minimax-m3.1-flash` | low, medium, high, xhigh, max | 512.000 | 1M / 512K |
| `beam-free` | low, medium, high, xhigh, max | 131.072 | 1M / 128K |
| `deepseek-v4.1-flash` | low, high, max (medium yok!) | 384.000 | 1M / 384K |

Ders: model yalnızca `modelOrder` dizisinde duruyorsa "ekli" değildir; `personalModelIds` + etkin `providerModelRules` kaydı olmadan effort seçicisi boş kalır (`deepseek-v4.1-flash` bir hafta böyle yarım durdu).

---

## 2) Model Ekleme Betiği

ZCode'u **tamamen kapat** (açıkken yapılandırmayı geri yazabilir), Git Bash'te çalıştır. Betik yedek alır, birden çok modeli üç alana da idempotent yazar:

```bash
node - <<'NODE'
const fs=require('fs'),os=require('os'),path=require('path');

const PROVIDER='opencode-go-chat';
const ADD=[
  {id:'minimax-m3.1-flash',effort:['low','medium','high','xhigh','max'],maxOut:512000},
  {id:'beam-free',effort:['low','medium','high','xhigh','max'],maxOut:131072},
];
const REMOVE=[];

const file=path.join(os.homedir(),'.zcode','v2','provider_config.json');
const backup=`${file}.bak-${new Date().toISOString().replace(/[:.]/g,'-')}`;
fs.copyFileSync(file,backup);

const cfg=JSON.parse(fs.readFileSync(file,'utf8'));
const pc=cfg.config.providerConfigRules.providerRules.find(p=>p.providerId===PROVIDER).config;
pc.personalModelIds=pc.personalModelIds||[]; pc.modelOrder=pc.modelOrder||[];
pc.personalModelIds=pc.personalModelIds.filter(x=>!REMOVE.includes(x));
pc.modelOrder=pc.modelOrder.filter(x=>!REMOVE.includes(x));
for(const m of ADD){
  if(!pc.personalModelIds.includes(m.id)) pc.personalModelIds.push(m.id);
  if(!pc.modelOrder.includes(m.id)) pc.modelOrder.push(m.id);
}

const rules=cfg.config.modelConfigRules.providerModelRules;
for(let i=rules.length-1;i>=0;i--){
  const r=rules[i];
  if(r.providerId===PROVIDER&&REMOVE.includes(r.modelId)) rules.splice(i,1);
}
for(const m of ADD){
  let rule=rules.find(r=>r.providerId===PROVIDER&&r.modelId===m.id);
  if(!rule){rule={modelId:m.id,providerId:PROVIDER,config:{}};rules.push(rule);}
  rule.config={...rule.config,enabled:true,optionSpecs:{
    ...(rule.config.optionSpecs||{}),
    reasoningLevel:{values:m.effort},
    maxOutputTokens:{max:m.maxOut},
  }};
}

fs.writeFileSync(file,JSON.stringify(cfg,null,2)+'\n');
console.log('Yedek:',backup);
NODE
```

Değerlerin kaynağı:

- **Effort:** models.dev kaydındaki `reasoning_options` → `effort.values` listesi. Modelde effort yoksa (`reasoning_options: []`) `reasoningLevel` bloğunu hiç yazma; uydurma değer uç noktadan 400 döner.
- **maxOutputTokens:** models.dev `limit.output` değeri.
- **Uç nokta değişimi:** Anthropic protokolü için `PROVIDER='opencode-go-messages'`, Responses için `'opencode-go-responses'` (bu ikisi bu makinede test edilmedi).

Doğrulandıktan sonra `.bak-*` dosyasını sil; birikip kafa karışıklığı yaratmasın.

---

## 3) Uç Nokta Seçimi

ZCode yerleşik şablonu her modele bir protokol atar (kaynak: `C:\Program Files\ZCode\resources\config\provider\zcode-builtin.json`):

- **chat** (`opencode-go-chat`): glm, kimi, deepseek, mimo, hy serileri
- **messages** (`opencode-go-messages`): minimax-m3, qwen serileri
- **responses** (`opencode-go-responses`): gpt-5.6-luna, grok serileri

Şablonda olmayan yeni kimlikte önce **chat**'i dene; 404/400 gelirse responses, sonra messages.

---

## 4) Eklenebilir Modeller — Go (29 aktif, 2026-10-24)

✔ = uç noktada bizzat test edildi.

| Model | Bağlam / Çıktı | Effort | Uç nokta |
| --- | --- | --- | --- |
| `beam-free` ✔ | 1M / 128K | low, medium, high, xhigh, max | chat |
| `claude-haiku-5-5` | 1M / 128K | low, medium, high, xhigh, max | test |
| `deepseek-v4-pro` | 1M / 384K | high, max | chat |
| `deepseek-v4.1-flash` ✔ | 1M / 384K | low, high, max | chat |
| `gemini-4-argon-contributor` | 1M / 64K | low, medium, high | test |
| `glm-5.2` | 1M / 128K | high, max | chat |
| `glm-5.3` | 1M / 128K | low, high, max | chat |
| `glm-5.3-flash` | 1M / 128K | low, high, max | chat |
| `gpt-5.6-luna` | 1M / 128K | none, low, medium, high, xhigh, max | responses |
| `gpt-6-luna` ✔ | 1M / 128K | none, low, medium, high, xhigh, max | test |
| `grok-4.7` | 500K / 500K | low, medium, high, xhigh | responses |
| `hy3` | 256K / 128K | none, low, high | chat |
| `hy4-preview` | 1M / 64K | none, high | chat |
| `kimi-k2.7-code` | 256K / 256K | — | chat |
| `kimi-k3` | 1M / 128K | max | chat |
| `kimi-k3.1-pro` ✔ | 1M / 128K | low, high, max | test |
| `longcat-2.0` | 1M / 128K | — | test |
| `mimo-v2.5` | 1M / 128K | — | chat |
| `mimo-v2.5-pro` | 1M / 128K | — | chat |
| `mimo-v2.6-flash` | 1M / 128K | — | test |
| `mimo-v2.6-pro` ✔ | 1M / 128K | — | test |
| `minimax-m3` | 1M / 128K | — | messages |
| `minimax-m3.1-flash` ✔ | 1M / 512K | low, medium, high, xhigh, max | chat |
| `muse-spark-1.2-contributor` | 1M / 128K | minimal, low, medium, high, xhigh | test |
| `muse-spark-1.3-contributor` | 1M / 128K | minimal, low, medium, high, xhigh | test |
| `qwen3.7-plus` | 1M / 64K | — | messages |
| `qwen3.8-flash` | 1M / 128K | low, medium, xhigh | messages |
| `qwen3.8-max` | 1M / 128K | low, medium, xhigh | messages |
| `step-5-preview` | 1M / 64K | low, medium, high | test |

"—" = effort yok; `reasoningLevel` yazma.

---

## 5) Eklenemez Modeller

**Go kataloğunda emekli (6):** `minimax-m3.1-flash-free` (2026-10-24'te öldü, uç nokta `Model not found` veriyor), `minimax-m2.7`, `cat-jam-free`, `longcat-2.5-preview-free`, `space-bunny`, `step-5-preview-free`.

**ZCode şablonunda duran ama artık sunulmayan kimlikler (8):** `glm-5.1`, `kimi-k2.6`, `deepseek-v4-flash`, `deepseek-v4-flash-vision-exp`, `minimax-m2.5`, `qwen3.7-max`, `qwen3.6-plus`, `grok-4.6`. Şablon eski olabilir; eklerken ölüm kuralına değil canlı katalog (aşağıda) bak.

**Zen tarafı (Go dışı):** Claude, Gemini, GPT-6-Astra gibi modeller Go aboneliğinde yok; `opencode-zen-*` sağlayıcısı ve ayrı Zen bakiyesi ister. Zen'de aktif ücretsizler: `beam-free`, `big-pickle`, `deepseek-v4.1-flash-free`, `flint-40b-free`, `glm-5.3-flash-free`, `mimo-v2.6-flash-free`, `nemotron-3-ultra-free`, `nemotron-3.5-lightning-free`, `nemotron-3.5-super-vl-free`. Zen'in 130 modelinden 48'i emekli.

**Ölüm kuralı:** `opencode models` yalnızca `status != deprecated` modelleri listeler. models.dev'de görünüp CLI'de görünmeyen model eksik değil, emeklidir; peşine düşme.

---

## 6) Kritik Noktalar

- **İki katman ayrı:** CLI önbelleğini düzeltmek ZCode listesini düzeltmez; tersi de geçerli.
- **Sağlayıcıyı silip yeniden ekleme yıkıcıdır:** `personalModelIds` ve `modelOrder` şablondan sıfırlanır. Sonrasında betiği yeniden çalıştır.
- **Şema doğrulaması:** `optionSpecs` yanlış biçimdeyse ZCode `invalid-option-spec` verir; `reasoningLevel` daima `{ "values": [...] }`.
- **`x-opencode-session` başlığı:** `https://opencode.ai/zen/go/v1/chat/completions` ham çağrılarında yoksa `400 MissingSessionID` gelir; model/abonelik hatası değildir.
- **API anahtarı:** `provider_config.json` içindeki anahtarı komut satırına, betiğe veya loga kopyalama; yukarıdaki betik hiç okumaz.
- **Önbellek bayatlaması:** `models.json` 7 gün bayat kalabilir; şüphelendiğinde `opencode models --refresh`.

---

## 7) Doğrulama ve Geri Alma

```bash
# Canlı katalog (emekliler listelenmez)
opencode models --refresh | grep "opencode-go/"

# Tek model uç nokta testi
opencode run -m opencode-go/<model> "Sadece OK yaz"
```

Kontrol listesi:

- [ ] ZCode kapalıyken betik çalıştı, yedek alındı.
- [ ] ZCode açıldı; model OpenCode Go (Chat) altında görünüyor.
- [ ] Effort menüsünde models.dev'deki değerler (ve yalnızca onlar) var.
- [ ] `opencode run` testi `OK` döndü.
- [ ] Doğrulandıktan sonra `.bak-*` silindi.

Geri alma: betiğin `REMOVE` dizisine istenmeyen modeli yaz, çalıştır; CLI önbelleği için `opencode models --refresh` yeniden üretir.
