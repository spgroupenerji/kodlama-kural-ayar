# Ajan Araçları Kataloğu

> Bu dosya, ajan oturumunda "hangi işe hangi araç" sorusunu hızlı yanıtlamak için tutulan kişisel bir katalogdur. Bağlantılar 2026-10-28 tarihinde HTTP durum koduyla doğrulandı; 2026-10-30'da eklenen üç bağlantı aynı gün HTTP 200 ile doğrulandı; HTTP 200 dışında yanıt veren giriş ayrıca işaretlendi. Her madde `- URL - açıklama` kalıbındadır; bağlantılar değiştirilmez, güncelliği doğrulanamayan bilgi "doğrulanmalı" etiketi taşır.

## 0. Benim İçin Kritik

Bu üçü, ajan oturumlarında en sık başvurduğum temel araçlar; diğer bölümlerde tekrar edilmez.

- https://github.com/obra/superpowers - Ajanı hemen koda daldırmayıp beyin fırtınası, şartname, planlama ve TDD adımlarından geçiren metodoloji çerçevesi.
- https://github.com/upstash/context7 - Kütüphane ve framework dokümantasyonunu sürüm bazlı MCP üzerinden vererek uydurma API kullanımını engelleyen platform.
- https://github.com/ChromeDevTools/chrome-devtools-mcp - Ajanların Chrome'u MCP üzerinden kontrol etmesini, DOM ve ağ trafiğini denetlemesini sağlayan resmî Chrome DevTools aracı; kurulumda kullanılacak tarayıcı profil dizinini ister.

## 1. Metodoloji ve Süreç

Yeni bir işe başlarken, kodu sadeleştirirken veya bir isteği derinleştirirken buraya bak.

- https://github.com/DietrichGebert/ponytail - Ajanı "odadaki en tembel kıdemli geliştirici" gibi düşündürerek üçüncü parti paket ve aşırı mühendislik yerine en küçük çözümü seçtiren YAGNI becerisi.
- https://github.com/tt-a1i/simplify-codebase - Kod tabanındaki gereksiz soyutlama ve karmaşıklığı davranışı bozmadan kanıtlayıp temizleyen analiz becerisi.
- https://github.com/DannyMac180/skills/tree/main/be-ambitious - Bir görevi büyütmeden derinleştiren prompt yeniden yazıcı: uzmanın sormadığın ham maddeyi, yöntemi ve dış doğrulama ölçütünü çıkarır.

## 2. Kod Zekâsı ve Etki Analizi

Bir sembolü değiştirmeden önce bağımlılıkları, çağrı yollarını ve etki alanını çıkarmak için buraya bak.

- https://github.com/abhigyanpatwari/GitNexus - Kod tabanını yerel bilgi grafiğine çıkarıp bağımlılık ve "blast radius" sorgularını MCP/CLI üzerinden yanıtlayan, sunucu kurulumu gerektirmeyen motor.
- https://github.com/colbymchenry/codegraph - SQLite tabanlı yerel bilgi grafiğini kod değiştikçe otomatik senkronize ederek sembol ve akış sorgularını MCP'den sunan, tamamen yerel motor.
- https://github.com/trailhq/Trail-Code - Kod tabanının haritasını çıkarıp ekip kararlarını (öğrenimleri) bu haritaya bağlayan, MCP ve hook'larla ajan istemine doğru dosya ve fonksiyonları enjekte eden bağlam katmanı (eski adı graft).
- https://github.com/Graphify-Labs/graphify - Kod, doküman, SQL şeması ve PDF'leri yerel AST ayrıştırmasıyla sorgulanabilir bilgi grafiğine çeviren, her kenarı açıklayan, vektör deposu kullanmayan beceri/MCP.

## 3. Dokümantasyon, Sıkıştırma ve Hafıza

Büyük araç çıktısını küçültürken, belgeyi okunabilir hâle getirirken veya oturumlar arası bağlam taşırken buraya bak; güncel kütüphane dokümantasyonunun kendisi için 0. bölümdeki Context7.

- https://github.com/mksglu/context-mode - Araç çıktısını sandbox'ta filtreleyip oturum hafızasını kalıcılaştıran, MCP ve hook'larla platformlar arası yönlendirme yapan bağlam penceresi iyileştiricisi (üretici iddiası: %98'e varan azaltma).
- https://github.com/microsoft/markitdown - Dosya ve ofis belgelerini Markdown'a çevirerek okuma token maliyetini düşüren resmî Microsoft aracı.
- https://github.com/thedotmack/claude-mem - Oturum gözlemlerini yakalayıp semantik olarak sıkıştıran ve ilgili bağlamı sonraki oturumlara enjekte eden kalıcı hafıza sistemi.

## 4. Arayüz ve Tasarım

Web arayüzü üretirken estetik kararlar, tasarım sistemi veya canvas efektleri gerektiğinde buraya bak; tarayıcı otomasyonu ve DOM denetimi için 0. bölümdeki Chrome DevTools MCP.

- https://github.com/nextlevelbuilder/ui-ux-pro-max-skill - 79 aranabilir arayüz stili, renk paleti ve tipografi kuralıyla ajanın profesyonel tasarım sistemleri üretmesini sağlayan beceri.
- https://github.com/pbakaus/impeccable - Ajanın ürettiği jenerik "AI slop" tasarımı 62 deterministik dedektör kuralıyla yakalayan, tarayıcıda canlı yineleme yaptıran tasarım kılavuzu.
- https://github.com/VoltAgent/awesome-design-md - Apple, Stripe gibi markaların tasarım dillerini `DESIGN.md` olarak toplayan arşiv; projeye bırakıldığında ajan o standartta arayüz üretir.
- https://github.com/DavidHDev/canvas-ui - Canlı DOM'u canvas dokusuna çevirip akışkan simülasyon, gölgelendirici ve cam/kırılma efektleri uygulayan 35 bileşenlik WebGL/WebGPU kütüphanesi.
- https://github.com/Leonxlnx/taste-skill - Kodlama ajanına sanat yönetimi, referans görsel ve tarayıcı kontrolü kazandırarak jenerik AI sayfası yerine özgün arayüz ürettiren beceri.
- https://github.com/emilkowalski/skills - Vercel ve Linear deneyimine dayanan tasarım ve animasyon becerileri; easing, gölge ve native his kararlarını iyileştirir.
- https://github.com/anthropics/claude-code/blob/main/plugins/frontend-design/skills/frontend-design/SKILL.md - Claude Code'un resmî `frontend-design` becerisi: arayüz tasarımı kuralları ve estetik kararlar (bağlantı 2026-10-28 itibarıyla 404 döndü; beceri `anthropics/skills` deposuna taşınmış görünüyor — doğrulanmalı).
- https://github.com/meticsmedia/10k-websites - ChatGPT/Codex için uçtan uca web sitesi becerisi: kaydırmayla oynayan açılış filmi, OpenArt ile görsel/video üretimi ve Hostinger'a tek adımda yayın.
- https://github.com/nutlope/hallmark - Together AI'nin tasarım becerisi: 50 temalı malzeme kataloğundan üç tema seçip sayfayı ziyaretçinin işine göre kurar, sonucu gerçek tarayıcıda makine üretimi izlerine karşı lint eder.

## 5. İnceleme ve Tersine Mühendislik

Kod incelemesi veya ikili/uygulama çözümlemesi gerektiğinde buraya bak.

- https://github.com/alibaba/open-code-review - Deterministik kurallar ile LLM ajanını birleştirerek satır bazlı hata ve güvenlik açığı (NPE, thread-safety, XSS, SQL injection) tespit eden inceleme aracı.
- https://github.com/morluto/rea - İkili dosya, uygulama ve çalışma zamanı davranışını yerelde analiz eden, Ghidra/JADX/apktool/binwalk gibi araçları tek MCP altında toplayan tersine mühendislik sunucusu.
- https://github.com/aicodeking/leanrea - REA'nın MCP katmanını atıp 8 KB'lık tek `SKILL.md` ile ajana hedef türüne göre en hızlı komutu (otool, jadx, binwalk vb.) seçtiren alternatif.

## 6. Video ve Hareketli Grafik

Kodla video üretirken üç katman: ajan becerisi (6.1), altta çalışan motor (6.2), uçtan uca hat veya örnek koleksiyonu (6.3).

### 6.1 Ajan Yetenekleri

- https://github.com/AbubakrChan/product-launch-motion - Koddan Dribbble seviyesinde ürün lansman videosu üreten Claude Code becerisi; tek şekil hiç kesilmez, imleç değişimi sürükler, ses efektleri ritme oturur.
- https://github.com/charlie947/motion-graphics-skills - Lansman kalitesinde hareketli grafik için 13 Claude Code becerisi; her kare kod, After Effects yok.
- https://github.com/howseen-ai/claude-motion-design - Saf kodla motion design: HTML + Playwright + ffmpeg; After Effects ve Remotion lisansı olmadan video üretir.
- https://github.com/nateherkai/herk-edit-kit - Codex veya Claude Code ile video, Reels ve YouTube Shorts kurgusu; HyperFrames + GSAP tabanlı, 15 beceri ve 406 motion-graphics kartı.
- https://github.com/Barty-Bart/motion-graphics - Claude Code için ücretsiz video kurgu becerileri: konuşmaya senkron B-roll ve arka plan izolasyonu; her beceri tek iş yapar.
- https://github.com/cth9191/animate - Her stilde (piksel sanatı, kesme kâğıt vb.) prosedürel animasyon: hikâye, görsel ve storyboard kontrolleri içeren tek dosya canvas videoları.
- https://github.com/whaleyxbt/claude-motion - Kodlama ajanına Remotion API'sinin ötesinde zevk, kendi karelerini denetleme ve ses motoru kazandıran motion tasarım araç kiti; simülasyonları 60 fps videoya çevirir.
- https://github.com/haidrrrry/claude-remotion-skill - Claude Code, Claude Desktop ve Claude AI'a Remotion ile B-roll, altyazı ve ses tasarımı üretmeyi öğreten açık kaynak beceri.
- https://github.com/199-biotechnologies/motion-dev-animations-skill - Motion.dev için Claude Code becerisi: 120fps web animasyonu, yay fiziği, scroll efekti ve gesture.
- https://github.com/remotion-dev/skills - Resmî ajan becerileri: kodlama ajanlarına Remotion kurallarını ve proje yapısını öğretir.
- https://github.com/greensock/gsap-skills - GSAP'in resmî AI becerileri; zaman çizelgesi ve animasyonu doğru API ile kullandırır.
- https://github.com/LottieFiles/motion-design-skill - Zamanlama, easing, koreografi ve Disney'in 12 animasyon prensibini ajanlara aktaran evrensel prensip deposu.

### 6.2 Render Motorları ve Animasyon Kütüphaneleri

- https://github.com/motiondivision/motion - React, Vue ve JavaScript için gesture, yay, layout geçişi ve scroll bağlantılı animasyon kütüphanesi (eski adı Framer Motion).
- https://github.com/heygen-com/hyperframes - HTML, CSS ve medyayı deterministik MP4'e çeviren açık kaynak çatı; CLI, ajan becerileri ve barındırılan iş akışları için tasarlandı.
- https://github.com/remotion-dev/remotion - React bileşenleriyle programatik video üretme kütüphanesi.

### 6.3 Üretim Hattı ve Koleksiyonlar

- https://github.com/calesthio/OpenMontage - Ajanı otonom video stüdyosuna çeviren açık kaynak sistem: Remotion, FFmpeg ve yapay zekâ video/ses modellerini (Veo, Kling, TTS) 12 üretim hattında orkestre eder.
- https://prompt-motion.com - Claude Opus 5.5 ile üretilmiş motion videolarının prompt ve becerilerini kategorilere ayıran koleksiyon sitesi (ürün arayüzü, kinetik tipografi, partikül, grafik, müzik vb.).

## 7. 3B Modelleme ve Sahne

Görselden veya Blender'dan kod tabanlı 3B model ve sahne üretirken buraya bak.

- https://github.com/img2threejs/img2threejs - Referans görseldeki nesneyi fotogrametri veya hazır varlık kullanmadan, kalite kapılı ve animasyona hazır prosedürel Three.js koduyla yeniden inşa eden beceri.
- https://github.com/ahujasid/mcp-for-blender - Blender'ı MCP üzerinden ajana bağlayan sunucu ve eklenti: istemli 3B modelleme, sahne kurma ve manipülasyon (eski adı blender-mcp).
