# İstemci Tarafı Belge Üretimi — PDF/Excel Çıktı Karar Kaydı

> Kaynak: Araştırma çıktısı + uygulama notları (2026-10-23). Nihai uygulamanın gerçek dosyaları (`app.<alanadi>.com/js/`) bu belgeye göre otoratiftir.

## 1) Nihai Karar

Sunucu tarafındaki PHP paketleri (`mpdf`, `phpoffice/phpspreadsheet`, `phpoffice/phpword`) yüksek bellek (RAM) ve işlemci tükettikleri için belge üretimi tarayıcıya (client-side) taşındı: sıfır sunucu yükü, limitsiz ve ücretsiz çıktı, anlık render.

- **Tüm kütüphaneler yerel olarak barındırılır; dış CDN bağımlılığı yoktur.**
- **PDF:** `pdfmake.min.js` — bildirimsel (declarative) JSON şemasıyla vektörel PDF üretir. `vfs_fonts.js`, gömülü Roboto font ailesiyle Türkçe karakterleri (ğ, ü, ş, ı, ö, ç) ve Türk Lirası simgesini (₺) destekler.
- **Excel (.xlsx):** `exceljs.min.js` — hem stillendirilmiş Excel çalışma kitapları üretir hem de kullanıcıdan gelen Excel dosyalarını tarayıcıda parse eder.
- **Word:** Çıktı üretilmez.

## 2) Gerçek Uygulama Mimarisi

Belge üretimi iki aşamalı modüler bir mimariyle çalışır:

1. **Tembel yükleme (app.js):** Ağır kütüphaneler sayfa yüklenirken çağrılmaz. Kullanıcı "PDF İndir" veya "Excel'e Aktar" butonuna tıkladığında `Belgeler` nesnesi üzerinden dinamik olarak yüklenir (`belgekatmaniYukle`).
2. **Merkezi belge motoru (belge.js):**
   - **Kurucular (saf fonksiyonlar):** DOM veya ağ bağımlılığı olmadan, yalnızca gelen veri ve logoları (Base64) alıp PDF/Excel şablon yapısını kurar.
   - **BelgeUretici (tarayıcı sarmalayıcısı):** Gerekli motoru yükler, kurum logolarını Base64 formatına çevirir; PDF'i yeni sekmede önizlemeye açar (popup engellenirse indirir), Excel'i Blob URL üzerinden .xlsx olarak indirir.

## 3) Araştırma Dönemi Karşılaştırması

Araştırma aşamasında PHP paketleri için değerlendirilen JS alternatifleri (lisanslar resmî depolardan doğrulandı, 2026-10-23):

| PHP Paketi | Değerlendirilen JS Alternatifi | Lisans | Resmî Kaynak |
| --- | --- | --- | --- |
| mpdf/mpdf | pdfmake, jsPDF | MIT, MIT | https://github.com/bpampuch/pdfmake (dokümantasyon: https://pdfmake.github.io/docs/) · https://github.com/parallax/jsPDF |
| phpoffice/phpspreadsheet | SheetJS (xlsx) | Apache-2.0 (doğrulanmalı) | https://sheetjs.com — resmî CDN kalıbı: `https://cdn.sheetjs.com/xlsx-0.20.3/package/dist/xlsx.full.min.js` |
| phpoffice/phpword | docx.js (+ FileSaver.js) | MIT, MIT | https://github.com/dolanmiu/docx (site: https://docx.js.org) · https://github.com/eligrey/FileSaver.js |

Not: Araştırma çıktısındaki `https://sheetjs.com`, `https://cloudflare.com` ve `https://unpkg.com` değerleri `<script src>` için çalışan CDN adresleri değildi (placeholder); yukarıdaki adresler resmî kaynaklardan doğrulanarak yazıldı. SheetJS dokümantasyonu kendi CDN'ini "authoritative source" olarak tanımlar ve script'lerin yerel barındırılmasını (vendoring) önerir — nihai karardaki yerel barındırma yaklaşımıyla uyumludur.

## 4) Araştırma → Karar Sapmaları

| Araştırma önerisi | Nihai karar | Gerekçe |
| --- | --- | --- |
| SheetJS | ExcelJS | Stillendirilmiş çalışma kitabı üretimi ve gelen Excel dosyasını parse etme tek kütüphanede birleşiyor |
| jsPDF (HTML'den PDF'e dökme senaryosu) | pdfmake | Bildirimsel JSON şemasıyla vektörel çıktı; `vfs_fonts.js` ile Türkçe karakter garantisi |
| docx.js + FileSaver.js ile Word çıktısı | Word çıktısı tamamen çıkarıldı | İhtiyaç duyulmadı |
| CDN üzerinden yükleme | Yerel barındırma | Dış bağımlılık ve CDN erişim kesintisi riski ortadan kalktı |
