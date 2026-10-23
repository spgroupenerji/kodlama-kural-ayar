## 1. Metodoloji ve Disiplin

- https://github.com/obra/superpowers - Ajanın hemen koda girmesini engelleyip beyin fırtınası, şartname, planlama ve TDD adımlarını uygulatan metodoloji çerçevesi.
- https://github.com/DietrichGebert/ponytail - Üçüncü parti paketler yerine yerel özellikleri tercih ettirerek aşırı mühendisliği ve kod kalabalığını önleyen YAGNI aracı.
- https://github.com/tt-a1i/simplify-codebase - Kod tabanındaki gereksiz soyutlamaları, karmaşıklığı ve ölü yapıları davranış bozmadan temizleyen analiz becerisi.
- https://github.com/DannyMac180/skills/tree/main/be-ambitious - Bir görevi büyütmeden derinleştiren prompt yeniden yazıcı: uzmanın sormadığın ham maddeyi, yöntemi ve dış doğrulama ölçütünü çıkarır.

## 2. Kod Zekâsı ve Bağlam Grafiği

- https://github.com/abhigyanpatwari/GitNexus - Kod tabanını yerel bilgi grafiğine dönüştürerek bağımlılıkları ve etki alanlarını "blast radius" MCP ile sorgulatan sunucusuz motor.
- https://github.com/colbymchenry/codegraph - SQLite tabanlı yerel bilgi grafiğiyle ilişkili sembol ve akışları MCP üzerinden sunarak kör dosya okumalarını önler.
- https://github.com/trailhq/Trail-Code - Projeyi Markdown bağlantı grafiğine dönüştürerek ajanın kod keşif maliyetini ve token tüketimini düşürür; kod tabanına özgü bağlam anlayışı verir.
- https://github.com/Graphify-Labs/graphify - Kod, doküman ve şemaları bilgi grafiğine dönüştürüp ajanın ilişkisel harita üzerinden akıl yürütmesini sağlar.
- https://github.com/upstash/context7 - Kütüphane/framework dokümantasyonunu sürüm bazlı MCP üzerinden verir; uydurma API kullanımını engeller.
- https://github.com/mksglu/context-mode - Sandbox filtrelemesiyle %98 token tasarrufu ve yerel oturum hafızası sağlayan otomatik MCP aracı.
- https://github.com/microsoft/markitdown - Dosyaları Markdown'a çevirerek okuma token maliyetini düşürür.
- https://github.com/headroomlabs-ai/headroom - Denenmedi — kısaca ara yönetici (context broker).

## 3. Arayüz, Tasarım ve Tarayıcı

- https://github.com/ChromeDevTools/chrome-devtools-mcp - Ajanların Chrome'u MCP üzerinden kontrol etmesini, DOM/ağ trafiğini denetlemesini sağlayan resmî Google aracı.
- https://github.com/nextlevelbuilder/ui-ux-pro-max-skill - 79 arayüz stili, renk paleti ve tipografi kuralıyla ajanın profesyonel tasarım sistemleri üretmesini sağlar.
- https://github.com/pbakaus/impeccable - Ajanların ürettiği basmakalıp "AI slop" tasarımları 61 kural ile denetleyerek kaliteyi yükselten tasarım kılavuzu.
- https://github.com/VoltAgent/awesome-design-md - Apple, Stripe gibi markaların tasarım dillerini içeren `DESIGN.md` arşivi; ajanın bu standartlarda UI üretmesini sağlar.
- https://github.com/DavidHDev/canvas-ui - Canlı HTML öğelerine WebGL/WebGPU tabanlı akışkan, cam ve kırılma efektleri uygulayan bileşen kütüphanesi.
- https://github.com/Leonxlnx/taste-skill - Kodlama ajanlarına "zevk" kazandıran skill'ler: sanat yönetimi, referans görsel ve tarayıcı kontrolü — jenerik AI sayfası yerine.
- https://github.com/emilkowalski/skills - Vercel ve Linear deneyimine dayanan tasarım ve animasyon skill'leri; ajanın easing seçimi, gölge kullanımı ve native hissi gibi arayüz kararlarını iyileştirir.
- https://github.com/anthropics/claude-code/blob/main/plugins/frontend-design/skills/frontend-design/SKILL.md - Claude Code'un resmî `frontend-design` skill'i: arayüz tasarımı kuralları ve estetik kararlar.

## 4. İnceleme, Tersine Mühendislik ve CLI Dönüşümü

- https://github.com/alibaba/open-code-review - Kural bazlı filtreler ile LLM'leri birleştirerek satır bazlı hata ve güvenlik açıklarını tespit eden hibrit inceleme aracı.
- https://github.com/HKUDS/CLI-Anything - Grafik arayüzlü (GUI) yazılımların kodunu analiz ederek ajanların doğrudan kullanabileceği CLI araçlarına dönüştürür.
- https://github.com/aicodeking/leanrea - Tersine mühendisliği tek bir 8 KB'lık skill dosyasına indiren yaklaşım; MCP katmanı yerine ajana dosya türüne göre en hızlı komutu (otool, jadx, binwalk vb.) seçtiren düz talimatlar sunar.
- https://github.com/morluto/rea - Kaynak kodu olmayan yazılımları kanıtlarıyla inceleyip bulguları ajana döndüren tersine mühendislik MCP sunucusu ve CLI; ikili dosyalar, APK, WASM, Electron ve .NET hedeflerini yerelde statik analiz eder.
- https://github.com/morluto/awesome-reverse-engineering - İkili dosyalar, uygulamalar, firmware, dosya formatları ve protokolleri anlamak için seçilmiş tersine mühendislik araçları ve öğrenme kaynakları listesi.

## 5. Video ve Hareketli Grafik (Motion Design)

Kod ile video üretme hattı üç katmandan oluşur: **render motoru** (Remotion, HyperFrames), **animasyon katmanı** (GSAP, Motion) ve **ajan yeteneği** (skill'ler). Alttaki araçlar bu üç katmana dağılır.

### 5.1 Ajan Yetenekleri (skill paketleri)

- https://github.com/AbubakrChan/product-launch-motion - Koddan Dribbble seviyesinde ürün lansman videosu üreten Claude Code skill'i; tek şekil hiç kesilmez.
- https://github.com/charlie947/motion-graphics-skills - Lansman kalitesinde hareketli grafik için 13 Claude Code skill'i; her kare kod, After Effects yok.
- https://github.com/howseen-ai/claude-motion-design - Saf kodla motion design: HTML + Playwright + ffmpeg; müzik ritmine duyarlı video.
- https://github.com/nateherkai/herk-edit-kit - Codex veya Claude Code ile video, Reels ve YouTube Shorts kurgusu; HyperFrames + GSAP tabanlı.
- https://github.com/Barty-Bart/motion-graphics - Claude Code ve Codex için motion-graphics skill'leri: konuşmaya senkron B-roll, arka plan izolasyonu.
- https://github.com/cth9191/animate - Her stilde (piksel sanatı, kesme kâğıt vb.) prosedürel animasyon: hikâye ve ses içeren tek dosya canvas videoları.
- https://github.com/whaleyxbt/claude-motion - Kodlama ajanları için motion design araç kiti; ses motoru ve kare kare kalite kontrol döngüsü.
- https://github.com/haidrrrry/claude-remotion-skill - Claude Code, Claude Desktop ve Claude AI'a Remotion ile B-roll, altyazı ve ses tasarımı üretmeyi öğreten açık kaynak skill.
- https://github.com/199-biotechnologies/motion-dev-animations-skill - Motion.dev için Claude Code skill'i: 120fps web animasyonu, yay fiziği, scroll efekti ve gesture.
- https://github.com/remotion-dev/skills - Resmî ajan skill'leri: kodlama ajanlarına Remotion kurallarını ve proje yapısını öğretir.
- https://github.com/greensock/gsap-skills - GSAP'in resmî AI skill'leri; zaman çizelgesi ve animasyonu doğru API ile kullandırır.
- https://github.com/LottieFiles/motion-design-skill - Zamanlama, easing, koreografi ve Disney'in 12 animasyon prensibini ajanlara aktaran evrensel prensip deposu.
- https://prompt-motion.com - Claude ile üretilmiş motion videolarının prompt ve skill'lerini kategorilere ayıran koleksiyon sitesi; kinetik tipografi, partikül ve ürün arayüzü örnekleri.

### 5.2 Render Motorları ve Animasyon Kütüphaneleri

- https://github.com/motiondivision/motion - React, Vue ve JavaScript için arayüz, buton ve sayfa geçiş animasyonu kütüphanesi (eski adı Framer Motion).
- https://github.com/heygen-com/hyperframes - HTML ve CSS tasarımlarını doğrudan MP4'e çeviren açık kaynak çatı; ajanlar için tasarlandı.
- https://github.com/remotion-dev/remotion - React bileşenleriyle programatik video üretme kütüphanesi.

### 5.3 Ek Video Araçları

- https://github.com/calesthio/OpenMontage - Remotion, Piper TTS ve FFmpeg'i orkestre ederek kodlama ajanını otonom video stüdyosuna dönüştürür.
- https://github.com/OpenCut-app/OpenCut - Açık kaynak video düzenleyici.

## 6. Editör ve CLI Dokümantasyonu

- https://antigravity.google/docs/home/
- https://opencode.ai/docs/tr/
- https://zcode.z.ai/en/docs/welcome
- https://docs.cline.bot/cline-overview
- https://github.com/deepseek-ai/deepseek-harness

## 7. Genel Kaynaklar

- https://github.com/public-apis/public-apis - API listesi.
- https://github.com/sindresorhus/awesome - yazılım, teknoloji ve çeşitli ilgi alanlarına dair en kaliteli kaynakların listesi.
- https://github.com/eyaprak/skills - YouTube videolarında gösterilen Claude Code skill'lerinin toplandığı depo; `seo-expert` skill'i buradan indirildi.