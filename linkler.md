# Linkler — Ajan Araçları ve Kaynaklar

> **Doğrulama:** 17 Ekim 2026 — bu dosyadaki tüm GitHub depoları HTTP 200 döndü, yönlendirme (rename) yok. Yıldız sayıları GitHub API'den o günkü değerlerdir; sıralama değil, olgunluk göstergesidir.

## 1. Metodoloji ve Disiplin

| Araç | Depo | Ne yapar |
|---|---|---|
| Superpowers | [obra/superpowers](https://github.com/obra/superpowers) | Ajanın hemen koda girmesini engelleyip beyin fırtınası, şartname, planlama ve TDD adımlarını uygulatan metodoloji çerçevesi. |
| Ponytail | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | Üçüncü parti paketler yerine yerel özellikleri tercih ettirerek aşırı mühendisliği ve kod kalabalığını önleyen YAGNI aracı. |
| Simplify Codebase | [tt-a1i/simplify-codebase](https://github.com/tt-a1i/simplify-codebase) | Kod tabanındaki gereksiz soyutlamaları, karmaşıklığı ve ölü yapıları davranış bozmadan temizleyen analiz becerisi. |
| Be Ambitious | [DannyMac180/skills](https://github.com/DannyMac180/skills/tree/main/be-ambitious) | Bir görevi büyütmeden derinleştiren prompt yeniden yazıcı: uzmanın sormadığın ham maddeyi, yöntemi ve dış doğrulama ölçütünü çıkarır. |

## 2. Kod Zekâsı ve Bağlam Grafiği

| Araç | Depo | Ne yapar |
|---|---|---|
| GitNexus | [abhigyanpatwari/GitNexus](https://github.com/abhigyanpatwari/GitNexus) | Kod tabanını yerel bilgi grafiğine dönüştürerek bağımlılıkları ve etki alanlarını "blast radius" MCP ile sorgulatan sunucusuz motor. |
| Codegraph | [colbymchenry/codegraph](https://github.com/colbymchenry/codegraph) | SQLite tabanlı yerel bilgi grafiğiyle ilişkili sembol ve akışları MCP üzerinden sunarak kör dosya okumalarını önler. |
| Trail Code | [trailhq/Trail-Code](https://github.com/trailhq/Trail-Code) | Projeyi Markdown bağlantı grafiğine dönüştürerek ajanın kod keşif maliyetini ve token tüketimini düşürür; kod tabanına özgü bağlam anlayışı verir. |
| Graphify | [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) | Kod, doküman ve şemaları bilgi grafiğine dönüştürüp ajanın ilişkisel harita üzerinden akıl yürütmesini sağlar. |
| Context7 | [upstash/context7](https://github.com/upstash/context7) | Kütüphane/framework dokümantasyonunu sürüm bazlı MCP üzerinden verir; uydurma API kullanımını engeller. |
| Context Mode | [mksglu/context-mode](https://github.com/mksglu/context-mode) | Sandbox filtrelemesiyle %98 token tasarrufu ve yerel oturum hafızası sağlayan otomatik MCP aracı. |
| MarkItDown | [microsoft/markitdown](https://github.com/microsoft/markitdown) | Dosyaları Markdown'a çevirerek okuma token maliyetini düşürür. |
| Headroom | [headroomlabs-ai/headroom](https://github.com/headroomlabs-ai/headroom) | Denenmedi — kısaca ara yönetici (context broker). |

## 3. Arayüz, Tasarım ve Tarayıcı

| Araç | Depo | Ne yapar |
|---|---|---|
| Chrome DevTools MCP | [ChromeDevTools/chrome-devtools-mcp](https://github.com/ChromeDevTools/chrome-devtools-mcp) | Ajanların Chrome'u MCP üzerinden kontrol etmesini, DOM/ağ trafiğini denetlemesini sağlayan resmî Google aracı. |
| UI/UX Pro Max | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | 79 arayüz stili, renk paleti ve tipografi kuralıyla ajanın profesyonel tasarım sistemleri üretmesini sağlar. |
| Impeccable | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | Ajanların ürettiği basmakalıp "AI slop" tasarımları 61 kural ile denetleyerek kaliteyi yükselten tasarım kılavuzu. |
| Awesome Design MD | [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) | Apple, Stripe gibi markaların tasarım dillerini içeren `DESIGN.md` arşivi; ajanın bu standartlarda UI üretmesini sağlar. |
| Canvas UI | [DavidHDev/canvas-ui](https://github.com/DavidHDev/canvas-ui) | Canlı HTML öğelerine WebGL/WebGPU tabanlı akışkan, cam ve kırılma efektleri uygulayan bileşen kütüphanesi. |
| Taste Skill | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | Kodlama ajanlarına "zevk" kazandıran skill'ler: sanat yönetimi, referans görsel ve tarayıcı kontrolü — jenerik AI sayfası yerine. |
| Frontend Design (Anthropic) | [anthropics/claude-code — frontend-design](https://github.com/anthropics/claude-code/blob/main/plugins/frontend-design/skills/frontend-design/SKILL.md) | Claude Code'un resmî `frontend-design` skill'i: arayüz tasarımı kuralları ve estetik kararlar. |

## 4. İnceleme ve CLI Dönüşümü

| Araç | Depo | Ne yapar |
|---|---|---|
| Open Code Review | [alibaba/open-code-review](https://github.com/alibaba/open-code-review) | Kural bazlı filtreler ile LLM'leri birleştirerek satır bazlı hata ve güvenlik açıklarını tespit eden hibrit inceleme aracı. |
| CLI-Anything | [HKUDS/CLI-Anything](https://github.com/HKUDS/CLI-Anything) | Grafik arayüzlü (GUI) yazılımların kodunu analiz ederek ajanların doğrudan kullanabileceği CLI araçlarına dönüştürür. |

## 5. Video ve Hareketli Grafik (Motion Design)

Kod ile video üretme hattı üç katmandan oluşur: **render motoru** (Remotion, HyperFrames), **animasyon katmanı** (GSAP, Motion) ve **ajan yeteneği** (skill'ler). Alttaki 15 araç bu üç katmana dağılır.

### 5.1 Ajan Yetenekleri (skill paketleri)

| # | Araç | Depo | ★ | Ne yapar |
|---|---|---|---|---|
| 1 | Product Launch Motion | [AbubakrChan/product-launch-motion](https://github.com/AbubakrChan/product-launch-motion) | 300 | Koddan Dribbble seviyesinde ürün lansman videosu üreten Claude Code skill'i; tek şekil hiç kesilmez. |
| 2 | Motion Graphics Skills | [charlie947/motion-graphics-skills](https://github.com/charlie947/motion-graphics-skills) | 309 | Lansman kalitesinde hareketli grafik için 13 Claude Code skill'i; her kare kod, After Effects yok. |
| 3 | Claude Motion Design | [howseen-ai/claude-motion-design](https://github.com/howseen-ai/claude-motion-design) | 556 | Saf kodla motion design: HTML + Playwright + ffmpeg; müzik ritmine duyarlı video. |
| 4 | Herk Edit Kit | [nateherkai/herk-edit-kit](https://github.com/nateherkai/herk-edit-kit) | 1.686 | Codex veya Claude Code ile video, Reels ve YouTube Shorts kurgusu; HyperFrames + GSAP tabanlı. |
| 5 | Motion Graphics | [Barty-Bart/motion-graphics](https://github.com/Barty-Bart/motion-graphics) | 711 | Claude Code ve Codex için motion-graphics skill'leri: konuşmaya senkron B-roll, arka plan izolasyonu. |
| 6 | Animate | [cth9191/animate](https://github.com/cth9191/animate) | 768 | Her stilde (piksel sanatı, kesme kâğıt vb.) prosedürel animasyon: hikâye ve ses içeren tek dosya canvas videoları. |
| 7 | Claude Motion | [whaleyxbt/claude-motion](https://github.com/whaleyxbt/claude-motion) | 449 | Kodlama ajanları için motion design araç kiti; ses motoru ve kare kare kalite kontrol döngüsü. |
| 8 | Claude Remotion Skill | [haidrrrry/claude-remotion-skill](https://github.com/haidrrrry/claude-remotion-skill) | 487 | Claude Code, Claude Desktop ve Claude AI'a Remotion ile B-roll, altyazı ve ses tasarımı üretmeyi öğreten açık kaynak skill. |
| 10 | Motion.dev Skill | [199-biotechnologies/motion-dev-animations-skill](https://github.com/199-biotechnologies/motion-dev-animations-skill) | 188 | Motion.dev için Claude Code skill'i: 120fps web animasyonu, yay fiziği, scroll efekti ve gesture. |
| 13 | Remotion Skills | [remotion-dev/skills](https://github.com/remotion-dev/skills) | 5.259 | Resmî ajan skill'leri: kodlama ajanlarına Remotion kurallarını ve proje yapısını öğretir. |
| 14 | GSAP Skills | [greensock/gsap-skills](https://github.com/greensock/gsap-skills) | 16.516 | GSAP'in resmî AI skill'leri; zaman çizelgesi ve animasyonu doğru API ile kullandırır. |
| 15 | LottieFiles Motion Design | [LottieFiles/motion-design-skill](https://github.com/LottieFiles/motion-design-skill) | 2.263 | Zamanlama, easing, koreografi ve Disney'in 12 animasyon prensibini ajanlara aktaran evrensel prensip deposu. |

### 5.2 Render Motorları ve Animasyon Kütüphaneleri

| # | Araç | Depo | ★ | Ne yapar |
|---|---|---|---|---|
| 9 | Motion | [motiondivision/motion](https://github.com/motiondivision/motion) | 34.220 | React, Vue ve JavaScript için arayüz, buton ve sayfa geçiş animasyonu kütüphanesi (eski adı Framer Motion). |
| 11 | HyperFrames | [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) | 65.481 | HTML ve CSS tasarımlarını doğrudan MP4'e çeviren açık kaynak çatı; ajanlar için tasarlandı. |
| 12 | Remotion | [remotion-dev/remotion](https://github.com/remotion-dev/remotion) | 64.637 | React bileşenleriyle programatik video üretme kütüphanesi. |

### 5.3 Ek Video Araçları

| Araç | Depo | Ne yapar |
|---|---|---|
| OpenMontage | [calesthio/OpenMontage](https://github.com/calesthio/OpenMontage) | Remotion, Piper TTS ve FFmpeg'i orkestre ederek kodlama ajanını otonom video stüdyosuna dönüştürür. |
| OpenCut | [OpenCut-app/OpenCut](https://github.com/OpenCut-app/OpenCut) | Açık kaynak video düzenleyici. |

**Entegrasyon notu:** Bu araçlardan birini projeye alırken iki bilgi gerekir — hangi ajan/editör (Claude Code, Codex, Cursor vb.) ve hedef çıktı (ürün lansmanı, Reels kurgusu, web animasyonu). Kurulum komutu ve şablon bu iki değişkene göre değişir.

## 6. Editör ve CLI Dokümantasyonu

- [antigravity.google/docs](https://antigravity.google/docs/home/)
- [opencode.ai/docs (TR)](https://opencode.ai/docs/tr/)
- [zcode.z.ai/docs](https://zcode.z.ai/en/docs/welcome)
- [docs.cline.bot](https://docs.cline.bot/cline-overview)
- [deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness)

## 7. Kurulum Komutları

```powershell
winget install --id Google.AntigravityCLI
winget install --id Google.AntigravityIDE
winget install --id ZhipuAI.ZCode
winget install --id SST.OpenCodeDesktop
winget install --id SST.opencode

npm list -g --depth=0

npm install -g @deepseek-ai/dsh
npm i -g cline
npm i -g opencode-ai
irm https://antigravity.google/cli/install.ps1 | iex
```

## 8. Windows Sorun Giderme

**npm global binary'leri PATH'te yok** (`%APPDATA%\npm` eksik):

```powershell
$k=[Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SYSTEM\CurrentControlSet\Control\Session Manager\Environment",$true);$p=$k.GetValue("Path","",[Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames);if($p -notlike "*%APPDATA%\npm*"){$k.SetValue("Path","$p;%APPDATA%\npm",[Microsoft.Win32.RegistryValueKind]::ExpandString);Write-Host "Basariyla eklendi!" -ForegroundColor Green}else{Write-Host "Zaten ekli." -ForegroundColor Yellow};$k.Close()
```

**PowerShell script çalıştırma politikası engeli:**

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
```

## 9. Genel Kaynaklar

- [public-apis/public-apis](https://github.com/public-apis/public-apis) — API listesi.
- [sindresorhus/awesome](https://github.com/sindresorhus/awesome) — yazılım, teknoloji ve çeşitli ilgi alanlarına dair en kaliteli kaynakların listesi.

---

Bağlamı gereksiz şişirmeden, odak kaybı olmadan, kararlılığı ve verimliliği olabilecek en üst noktada tutmak için yapılması gerekeni yap.
Bu görev için uygun olan skill, MCP ve plugin araçlarını en etkin şekilde kullan.
