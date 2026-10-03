# GÖRSEL DİZAYN VE ARAYÜZ STANDARTLARI TEKNİK ANAYASASI

1.1.1. İstemci tarafında hiçbir derleme (build-step) ve paketleme sürecine ihtiyaç duymadan; Tailwind CDN ve standart tasarım token'ları aracılığıyla kararlı, ultra hızlı, tutarlı ve sürdürülebilir bir arayüz mimarisi tesis etmektir.
1.2.1. Bu anayasa metninde yer alan tüm hükümler; uygulamanın son kullanıcıya sunulan istisnasız tüm interaktif web arayüzü sayfalarını (Dashboard, SCADA kontrol panelleri, form ekranları, veri tabloları, modal pencereler, gezinme çubukları ve operasyonel modüller) doğrudan ve tavizsiz bağlar.
1.3.1. Sunucu Taraflı PDF Motorları: TCPDF, DOMPDF, mPDF veya eşdeğer kütüphaneler ile işlenen ve doğrudan dosya çıktısı üreten şablonlar (`destek/*_pdf.php` vb.), kendi inline stil ve tablo hiyerarşilerinde anayasa kısıtlamalarından muaftır.
1.3.2. E-posta İstemci Şablonları: Çapraz e-posta istemcilerinin (Outlook, Gmail vb.) teknik yetersizlikleri sebebiyle; HTML e-posta çıktıları içindeki satır içi `style="..."` öznitelikleri ve e-postaya özel `<style>` blokları kısıtlamalardan muaftır.
1.3.3. Dinamik Grafik ve Harita Tuvali (Canvas/WebGL): Leaflet, Chart.js ve Three.js (3D Canvas) gibi harici kütüphanelerin çalışması için zorunlu olan CSS/JS varlıkları ile dinamik tuval render işlemleri anayasa sınırlamalarına tabi değildir.
1.3.4. Bağımsız Giriş Ekranı (`login.php`): Kullanıcı kimlik doğrulama sayfası (`login.php`), mimari izolasyon ve sıfır dış bağımlılık ilkesi gereğince harici hiçbir CSS dosyasına veya harici stil kaynağına bağımlı değildir; ihtiyaç duyduğu tüm CSS ve stil kurallarını tamamen kendi bünyesinde (self-contained) barındırır.
2.1.1. Node.js, Webpack, Vite, PostCSS, Gulp veya benzeri hiçbir yerel/sunucu taraflı derleme, ön işlemci veya paketleme aracı kullanılamaz.
2.1.2. Tüm arayüz stilleri, münhasıran tarayıcı çalışma zamanında (client runtime) işlenmek ve Tailwind motoru tarafından yerinde çözümlenmek zorundadır.
2.2.1. Tailwind CSS ve ilgili istemci kütüphaneleri çalışma anında CDN üzerinden çağrılır.
2.2.2. Çalışma zamanı kırılmalarını ve beklenmeyen sürüm uyuşmazlıklarını önlemek amacıyla CDN bağlantılarında `@latest` veya dinamik sürüm etiketleri yasaktır; sabitlenmiş sürüm etiketi (version pinned) kullanımı mecburidir.
2.3.1. Standart arayüz bileşenleri için bağımsız `.css` dosyaları oluşturulması ve projeye dâhil edilmesi kesinlikle yasaktır.
2.3.2. Sayfa şablonları içerisinde serbest HTML `<style>` blokları açılamaz.
2.3.3. İstisna: Yalnızca Tailwind v4 `@theme` token tanımlamaları, özel WebKit kaydırma çubukları (scrollbar) ve `@page` yazdırma yönergeleri için sayfa başlığında tek bir `<style type="text/tailwindcss">` bloğu açılmasına izin verilir.
2.3.4. Kütüphane İstisnası: Harita ve benzeri bileşenlerin render bütünlüğü için zorunlu olan harici stil sayfaları (`leaflet.css` vb.) yalnızca ilgili modül sayfalarında izole olarak çağrılabilir.
2.4.1. Statik görsel düzenleme, konumlandırma ve boşluk amaçlı `style="display:flex; margin:10px;"` gibi tüm satır içi kullanımlar kesinlikle yasaktır.
2.4.2. Satır içi `style="..."` kullanımı; yalnızca çalışma anında JavaScript tarafından dinamik hesaplanan mutlak koordinatlar (ör: `style="left: ${x}px; top: ${y}px;"`), anlık genişlik/yükseklik yüzdeleri ve matematiksel SVG hesaplamaları ile sınırlıdır.
3.1.1. Rastgele, kontrolsüz ve birden fazla Google Fonts bağlantısının (Inter, Roboto, Montserrat vb. fontların aynı anda çağrılması) projeye eklenmesi yasaktır.
3.1.2. Performans ve görsel sadelik adına işletim sistemi font yığını (`font-sans`) esastır.
3.1.3. Özel bir font gereksiniminde yalnızca tek bir web font ailesi (örn: Inter) seçilmeli ve bu tanım merkezi `@theme` bloğunda `font-arayuz` token'ı olarak tek elden tanımlanmalıdır.
3.2.1. Yoğun veri, mühendislik ve operasyonel SCADA ekranlarında bilgi yoğunluğunu korumak ve bileşen taşmalarını engellemek amacıyla varsayılan taban arayüz gövde boyutu 13px / 14px (`text-sm`) olarak uygulanır.
3.2.2. Standart arayüz metinleri genel web alışkanlıklarıyla zorla 16px (`text-base`) boyutuna genişletilemez.
3.3.1. Keyfi piksel tanımlamaları (`text-[6.5px]`, `text-[11px]`, `text-[13px]`) kesinlikle tasfiye edilecek; yalnızca Tailwind CSS standart baremi (`text-xs`, `text-sm`, `text-base`, `text-lg`, `text-xl` vb.) kullanılacaktır.
4.1.1. Dolgu (padding), kenar payı (margin) ve elemanlar arası boşluk (gap) tanımlarında Tailwind'in resmi 4px baremi (`0.5`, `1`, `1.5`, `2`, `2.5`, `3`, `4`, `6`, `8`...) bağlayıcıdır.
4.1.2. `px-[7px]`, `py-[3px]`, `p-[5px]` gibi keyfi ve tekil piksel tanımlamaları kesinlikle yasaktır; bu değerler en yakın standart adıma (`px-1.5`, `py-1`, `p-1.5` vb.) yuvarlanmak zorundadır.
4.2.1. Butonlar, form girdileri (input, select) ve liste satırlarında `pt-2 pb-3.5` gibi asimetrik ve hiyerarşiyi bozan dikey dolgular kullanılamaz.
4.2.2. Dikey aks üzerinde optik dengeyi sağlamak için simetrik sınıflar (`py-1`, `py-1.5`, `py-2`) kullanılması esastır.
5.1.1. HTML veya şablon dosyaları içerisinde rastgele ham Hex kodları (`bg-[#7f9db9]`, `text-[#3b6fb5]` vb.) doğrudan kullanılamaz.
5.1.2. Tüm renk hiyerarşisi standart Tailwind renk aileleri (`bg-slate-800`, `text-teal-600`, `border-emerald-500` vb.) üzerinden kurgulanır.
5.2.1. Sayfa veya bileşen bazında keyfi durum rengi seçilemez.
5.2.2. Sistem durumları kurumsal semantik renklerle eşleştirilir (başarı: `emerald`/`green`, uyarı: `amber`/`yellow`, hata: `rose`/`red`, bilgi: `sky`/`blue`).
6.1.1. Arayüz genelinde tek yetkili ikon sağlayıcı Iconify Web Component (`<iconify-icon>`) altyapısıdır.
6.1.2. Proje genelinde görsel tutarlılık adına tek bir ikon seti öneki (örn: `lucide:` veya `solar:`) seçilmeli; farklı ikon setlerinin aynı projede kontrolsüzce harmanlanması engellenmelidir.
6.2.1. İkonlar istemci çalışma anında doğrudan resmi Iconify API üzerinden çekilir ve tarayıcı yerel önbelleğinde saklanır.
6.2.2. Yerel SVG dosyaları barındırmak, ikon fontları (`font-awesome` vb.) yüklemek, SVG sprite yapıları kurmak veya stillere base64 SVG gömmek kesinlikle yasaktır. İlk yüklemedeki mikrosaniyelik ağ gecikmesi kabul edilir.
6.2.3. Dinamik Çizim Muafiyeti: `pvsGrafik`, akış şemaları veya matematiksel algoritma çıktıları gibi kod tarafından anlık üretilen dinamik vektörel grafikler ikon kısıtlamasından muaftır.
7.1.1. JavaScript ile dinamik DOM elemanı üretilirken (`innerHTML`, template strings), elementlere satır içi CSS (`style="..."`) yazılamaz.
7.1.2. Tüm görsel özellikler saf Tailwind sınıfları atanarak tanımlanmalıdır (`class="flex items-center gap-2 py-1.5 px-2 text-sm"`).
7.2.1. Sekme, modal, accordion veya butonların aktiflik/pasiflik durumları için özel ham CSS sınıfları (ör: `.my-custom-active { ... }`) üretilemez.
7.2.2. Aktif ve pasif durumlar, Tailwind utility sınıflarının dinamik olarak değiştirilmesiyle yönetilmelidir (ör: aktif için `bg-teal-600 text-white`, pasif için `bg-transparent text-slate-500 hover:bg-slate-100`).
8.1.1. Kullanıcının doğrudan ve yazılı olarak verdiği açık tasarım direktifleri bu anayasaya otomatik olarak eklenir ve doğrudan bağlayıcılık kazanır.
8.1.2. Herhangi bir kural çelişkisi halinde; kullanıcının en güncel yazılı onayı ve talimatı en üstün bağlayıcı kaynaktır.
8.2.1. Başta Tailwind CSS sözdizimi ve Iconify bileşen tanımları olmak üzere, mimaride kullanılan tüm yöntem ve sürümler Context7 üzerinden doğrulanmak zorundadır.
8.2.2. Doğrulanmamış, varsayımsal veya deneysel yöntem ve sözdizimleri üretim ortamına ve sayfa kodlarına dâhil edilemez.