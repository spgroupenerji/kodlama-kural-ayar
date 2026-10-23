// web-sayfasi-ekran-goruntusu.mjs
// Web sayfasini headless Chrome + CDP uzerinden yuksek cozunurluklu PNG olarak ceker.
// Gereksinim: Node.js >= 21 (yerlesik WebSocket), Chrome/Edge/Brave.
import { spawn } from 'node:child_process';
import { existsSync, writeFileSync, mkdtempSync, rmSync } from 'node:fs';
import { tmpdir, platform } from 'node:os';
import { join } from 'node:path';
import { createInterface } from 'node:readline/promises';
import { stdin as input, stdout as output } from 'node:process';

// 1. Oran ve Çözünürlük Profilleri
const PROFILLER = {
  '1': { kod: '16:9', ad: '16:9 (Geniş Ekran - Web/Sunum)', width: 1420, height: 784,  mobile: false },
  '2': { kod: '4:3',  ad: '4:3  (Klasik - Tablet/Slayt)',   width: 1200, height: 900,  mobile: false },
  '3': { kod: '1:1',  ad: '1:1  (Kare - Masaüstü Korumalı)',width: 1400, height: 1400, mobile: false },
  '4': { kod: '1:1m', ad: '1:1  (Kare - Standart 1080p)',   width: 1080, height: 1080, mobile: false },
  '5': { kod: '9:16', ad: '9:16 (Dikey - Mobil/Story)',     width: 450,  height: 800,  mobile: true  },
};

// 2. İşletim Sistemine Göre Tarayıcı Adayları
function tarayicilariBul() {
  const os = platform();
  const adaylar = [];

  if (os === 'win32') {
    const pf = process.env['PROGRAMFILES'] || 'C:\\Program Files';
    const pf86 = process.env['PROGRAMFILES(X86)'] || 'C:\\Program Files (x86)';
    const local = process.env['LOCALAPPDATA'] || '';
    adaylar.push(
      { ad: 'Google Chrome', yol: join(pf, 'Google\\Chrome\\Application\\chrome.exe') },
      { ad: 'Google Chrome (x86)', yol: join(pf86, 'Google\\Chrome\\Application\\chrome.exe') },
      { ad: 'Google Chrome (User)', yol: join(local, 'Google\\Chrome\\Application\\chrome.exe') },
      { ad: 'Microsoft Edge', yol: join(pf86, 'Microsoft\\Edge\\Application\\msedge.exe') },
      { ad: 'Microsoft Edge (x64)', yol: join(pf, 'Microsoft\\Edge\\Application\\msedge.exe') },
      { ad: 'Brave Browser', yol: join(pf, 'BraveSoftware\\Brave-Browser\\Application\\brave.exe') }
    );
  } else if (os === 'darwin') {
    adaylar.push(
      { ad: 'Google Chrome', yol: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' },
      { ad: 'Microsoft Edge', yol: '/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge' },
      { ad: 'Brave Browser', yol: '/Applications/Brave Browser.app/Contents/MacOS/Brave Browser' }
    );
  } else {
    adaylar.push(
      { ad: 'Google Chrome', yol: '/usr/bin/google-chrome' },
      { ad: 'Chromium', yol: '/usr/bin/chromium-browser' },
      { ad: 'Microsoft Edge', yol: '/usr/bin/microsoft-edge' },
      { ad: 'Brave Browser', yol: '/usr/bin/brave-browser' }
    );
  }

  return adaylar.filter(t => existsSync(t.yol));
}

const uyu = (ms) => new Promise(r => setTimeout(r, ms));

// 3. CDP Üzerinden Tarayıcı Başlatıcı
async function cdpBaglantisiKur(tarayiciYolu, port, profilDizini) {
  const proc = spawn(tarayiciYolu, [
    '--headless=new',
    '--disable-gpu',
    '--hide-scrollbars',
    '--mute-audio',
    '--no-first-run',
    '--no-default-browser-check',
    `--remote-debugging-port=${port}`,
    `--user-data-dir=${profilDizini}`,
    'about:blank'
  ], { stdio: 'ignore' });

  for (let i = 0; i < 40; i++) {
    try {
      const res = await fetch(`http://127.0.0.1:${port}/json/list`);
      const tabs = await res.json();
      const page = tabs.find(t => t.type === 'page');
      if (page && page.webSocketDebuggerUrl) {
        return { proc, wsUrl: page.webSocketDebuggerUrl };
      }
    } catch {}
    await uyu(200);
  }
  proc.kill();
  throw new Error('Tarayıcı CDP portuna bağlanılamadı.');
}

// 4. Ana Render ve Çekim Motoru
async function renderVeCek({ tarayiciYolu, url, width, height, scale, mobile, beklemeSuresi, ciktiDosyaAdi }) {
  const port = 9200 + Math.floor(Math.random() * 700);
  const profilDizini = mkdtempSync(join(tmpdir(), 'ultra-capture-'));
  let proc = null;
  let ws = null;

  try {
    console.log('\n[1/4] Tarayıcı başlatılıyor...');
    const baglanti = await cdpBaglantisiKur(tarayiciYolu, port, profilDizini);
    proc = baglanti.proc;

    ws = new WebSocket(baglanti.wsUrl);
    let msgId = 0;
    const bekleyenler = new Map();
    const olayDinleyiciler = new Map();

    ws.onmessage = (e) => {
      const data = JSON.parse(e.data);
      if (data.id && bekleyenler.has(data.id)) {
        const { resolve, reject } = bekleyenler.get(data.id);
        bekleyenler.delete(data.id);
        if (data.error) reject(new Error(data.error.message));
        else resolve(data);
      } else if (data.method && olayDinleyiciler.has(data.method)) {
        olayDinleyiciler.get(data.method)(data.params);
      }
    };

    await new Promise((resolve, reject) => {
      ws.onopen = resolve;
      ws.onerror = reject;
    });

    const cdp = (method, params = {}) => new Promise((resolve, reject) => {
      const id = ++msgId;
      bekleyenler.set(id, { resolve, reject });
      ws.send(JSON.stringify({ id, method, params }));
    });

    const olayBekle = (method, timeoutMs = 30000) => new Promise((resolve) => {
      const timer = setTimeout(() => {
        olayDinleyiciler.delete(method);
        resolve(); // Zaman aşımında bile devam et
      }, timeoutMs);
      olayDinleyiciler.set(method, (params) => {
        clearTimeout(timer);
        olayDinleyiciler.delete(method);
        resolve(params);
      });
    });

    await cdp('Page.enable');
    await cdp('Runtime.enable');

    // Çözünürlük ve Piksel Yoğunluğu (Retina/4K) Ayarı
    await cdp('Emulation.setDeviceMetricsOverride', {
      width,
      height,
      deviceScaleFactor: scale,
      mobile
    });

    console.log(`[2/4] Sayfa yükleniyor: ${url}`);
    const yuklemeKilidi = olayBekle('Page.loadEventFired', 30000);
    await cdp('Page.navigate', { url });
    await yuklemeKilidi;

    console.log('[3/4] Fontlar, görseller ve animasyonlar kilitleniyor...');
    await cdp('Runtime.evaluate', {
      expression: `
        (async () => {
          // 1. Fontların yüklenmesini bekle
          if (document.fonts && document.fonts.ready) {
            await document.fonts.ready;
          }

          // 2. Ekrandaki <img> elementlerinin yüklenmesini bekle
          const gorseller = Array.from(document.images);
          await Promise.all(gorseller.map(img => {
            if (img.complete) return Promise.resolve();
            return new Promise(res => {
              img.addEventListener('load', res, { once: true });
              img.addEventListener('error', res, { once: true });
            });
          }));

          // 3. Animasyonları, geçişleri ve imleci dondur
          const stil = document.createElement('style');
          stil.innerHTML = \`
            *, *::before, *::after {
              transition: none !important;
              animation: none !important;
              caret-color: transparent !important;
            }
            ::-webkit-scrollbar { display: none !important; }
          \`;
          document.head.appendChild(stil);

          // 4. Ana kaydırma çubuklarını gizle
          document.documentElement.style.overflow = 'hidden';
          document.body.style.overflow = 'hidden';

          // 5. Çift requestAnimationFrame ile render döngüsünü kilitle
          await new Promise(r => requestAnimationFrame(() => requestAnimationFrame(r)));
        })()
      `,
      awaitPromise: true
    });

    if (beklemeSuresi > 0) {
      await uyu(beklemeSuresi);
    }

    console.log(`[4/4] ${width * scale}x${height * scale} px (${scale}x) ekran görüntüsü alınıyor...`);
    const screenshot = await cdp('Page.captureScreenshot', {
      format: 'png',
      optimizeForSpeed: false,
      fromSurface: true
    });

    writeFileSync(ciktiDosyaAdi, Buffer.from(screenshot.result.data, 'base64'));
    console.log(`\n[BAŞARILI] Görüntü kaydedildi -> ${ciktiDosyaAdi}`);
  } finally {
    if (ws && ws.readyState === WebSocket.OPEN) ws.close();
    if (proc) proc.kill();
    await uyu(300);
    try { rmSync(profilDizini, { recursive: true, force: true }); } catch {}
  }
}

// 5. Etkileşimli Kullanıcı Menüsü (CLI)
async function baslat() {
  if (typeof WebSocket === 'undefined') {
    console.error('HATA: Bu betik yerleşik WebSocket desteği için Node.js v21+ (veya v22+) gerektirir.');
    console.error('Alternatif olarak "node --experimental-websocket studio-capture.mjs" komutuyla çalıştırabilirsiniz.');
    process.exit(1);
  }

  const rl = createInterface({ input, output });

  try {
    console.log('====================================================');
    console.log('   ULTRA-HD (RETINA/4K) WEB EKRAN GÖRÜNTÜSÜ ARACI   ');
    console.log('====================================================\n');

    // A) Tarayıcı Seçimi
    const bulunanlar = tarayicilariBul();
    let secilenTarayiciYolu = '';

    if (bulunanlar.length > 0) {
      console.log('Sistemde Bulunan Tarayıcılar:');
      bulunanlar.forEach((t, idx) => {
        console.log(`  [${idx + 1}] ${t.ad} (${t.yol})`);
      });
      console.log(`  [${bulunanlar.length + 1}] Manuel dosya yolu gir`);

      const secim = (await rl.question(`\nKullanılacak tarayıcıyı seçin [Varsayılan: 1]: `)).trim() || '1';
      const secimIdx = parseInt(secim, 10) - 1;

      if (secimIdx >= 0 && secimIdx < bulunanlar.length) {
        secilenTarayiciYolu = bulunanlar[secimIdx].yol;
      } else {
        secilenTarayiciYolu = (await rl.question('Tarayıcı çalıştırılabilir dosya yolunu (exe/bin) girin: ')).trim();
      }
    } else {
      console.log('Sistemde standart konumda tarayıcı bulunamadı.');
      secilenTarayiciYolu = (await rl.question('Tarayıcı çalıştırılabilir dosya yolunu (exe/bin) girin: ')).trim();
    }

    if (!existsSync(secilenTarayiciYolu)) {
      throw new Error(`Belirtilen yolda tarayıcı bulunamadı: ${secilenTarayiciYolu}`);
    }

    // B) Hedef URL
    let url = (await rl.question('\nÇekilecek Web Adresi [Varsayılan: https://example.com]: ')).trim() || 'https://example.com';
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://' + url;
    }

    // C) Oran / Çözünürlük Profili Seçimi
    console.log('\nHedef Oran ve Layout Boyutu:');
    Object.entries(PROFILLER).forEach(([anahtar, p]) => {
      console.log(`  [${anahtar}] ${p.ad} -> CSS: ${p.width}x${p.height} px`);
    });
    console.log('  [6] Özel boyut gir (Custom)');

    const profilSecim = (await rl.question('\nProfil seçin [Varsayılan: 1 (16:9)]: ')).trim() || '1';
    let width = 1420, height = 784, mobile = false, kod = 'ozel';

    if (PROFILLER[profilSecim]) {
      ({ width, height, mobile, kod } = PROFILLER[profilSecim]);
    } else {
      width = parseInt(await rl.question('CSS Genişliği (px) [Örn: 1440]: '), 10) || 1440;
      height = parseInt(await rl.question('CSS Yüksekliği (px) [Örn: 900]: '), 10) || 900;
    }

    // D) Piksel Yoğunluğu (deviceScaleFactor)
    console.log('\nPiksel Yoğunluğu (Kalite Çarpanı):');
    console.log(`  [1] 1x - Standart (${width}x${height} px)`);
    console.log(`  [2] 2x - Retina Kalitesi (${width * 2}x${height * 2} px) [Önerilen]`);
    console.log(`  [3] 3x - Ultra 4K / Baskı (${width * 3}x${height * 3} px)`);

    const scaleSecim = (await rl.question('\nKalite çarpanı seçin [Varsayılan: 2]: ')).trim() || '2';
    const scale = [1, 2, 3].includes(parseInt(scaleSecim, 10)) ? parseInt(scaleSecim, 10) : 2;

    // E) Ekstra Grafik/Veri Bekleme Süresi
    const beklemeGirdi = (await rl.question('\nSayfa yüklendikten sonra ek bekleme süresi (ms) [Varsayılan: 1500]: ')).trim();
    const beklemeSuresi = beklemeGirdi === '' ? 1500 : parseInt(beklemeGirdi, 10);

    // F) Çıktı Dosya Adı
    const varsayilanDosya = `cekim-${kod.replace(':', 'x')}-${scale}x-${Date.now()}.png`;
    const ciktiDosyaAdi = (await rl.question(`\nÇıktı dosya adı [Varsayılan: ${varsayilanDosya}]: `)).trim() || varsayilanDosya;

    await renderVeCek({
      tarayiciYolu: secilenTarayiciYolu,
      url,
      width,
      height,
      scale,
      mobile,
      beklemeSuresi,
      ciktiDosyaAdi
    });

  } catch (err) {
    console.error(`\n[HATA]: ${err.message}`);
  } finally {
    rl.close();
  }
}

baslat();