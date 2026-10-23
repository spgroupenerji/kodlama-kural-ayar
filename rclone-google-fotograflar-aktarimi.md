# rclone ile Google Fotoğraflar'a Toplu Aktarım Rehberi (400+ GB / 4 Klasör)

> Kaynak: rclone resmî belgeleri — `https://rclone.org/googlephotos/` ve `https://rclone.org/remote_setup/` (Context7 `/rclone/rclone` üzerinden 2026-10-23 tarihinde doğrulandı). Komutlar, rclone_gui konteynerinin Portainer konsolunda (`/data #` istemi) çalıştırılacak şekilde hazırlanmıştır.

## 1. Bu Belge Ne Zaman Kullanılır?

| Amacınız | Doğru Rehber |
|---|---|
| Fotoğrafları **albüm olarak** Google Fotoğraflar uygulamasında telefon/web üzerinden gezmek | **Bu belge** |
| Klasör/dizin yapısını **birebir koruyarak**, her dosya türünü kabul eden ve kayıpsız geri indirilebilen bir arşiv oluşturmak | `rclone-google-drive-aktarimi.md` |

İkisi aynı anda da kullanılabilir (aynı veri iki kez kota yer); genellikle birinin seçilmesi yeterlidir.

## 2. Başlamadan Önce Kritik Gerçekler

1. **Kotanıza yazılır:** API üzerinden yüklenen her öğe **tam çözünürlükte, orijinal kalitede** saklanır ve Google hesap depolama kotanızdan düşer. API'de "yüksek kalite" (sıkıştırılmış) yükleme modu **yoktur**. Dolayısıyla hedef hesapta en az **400 GB boş alan** (Google One aboneliği) bulunmalıdır; ücretsiz hesabın 15 GB'ı bu aktarım için yetersizdir.
2. **Alt klasörler ayrı albümlere dönüşür:** Google Fotoğraflar gerçek bir dosya sistemi değildir. `rclone copy /kaynak/Klasor1 ikinci_hesap:album/Klasor1` komutunda Klasor1 içindeki `Alt` dizini, **"Klasor1/Alt" adında** ayrı bir albüm olarak oluşur (rclone albüm adlarında `/` karakterini bu şekilde kullanır).
3. **Yalnızca rclone'un oluşturduğu albümlere yazılabilir:** Google Fotoğraflar API kısıtı nedeniyle rclone, yalnızca kendi oluşturduğu albümlere dosya ekleyebilir. Hedef hesapta aynı adlı elle oluşturulmuş bir albüm varsa aktarım hata verir; temiz bir hesapta sorun çıkmaz.
4. **Yalnızca resim ve video kabul edilir:** `.txt`, `.zip`, `.db` veya desteklenmeyen RAW uzantıları reddedilir ve hata olarak kayda geçer.
5. **Geri indirme kısıtı (çok önemli):** Google Fotos API'si, rclone ile geri indirmede **orijinal çözünürlüğü vermez** ve **EXIF konum verisini siler**. Bu bir yedekleme değil, tek yönlü bir "yükleme" olarak değerlendirilmelidir. Orijinal dosyaları geri almanın garantili yolu Google Takeout'tır; yeni rclone sürümlerindeki `--gphotos-proxy` bayrağı tam çözünürlük indirmek için başsız tarayıcı proxy'si sunar (konteynerinizdeki rclone sürümünde mevcut olmayabilir — `rclone version` ile kontrol edin, doğrulanmalı).
6. **Silme kısıtı:** rclone, yalnızca kendi yüklediği dosyaları kendi oluşturduğu albümlerden kaldırabilir. Bu yüzden bu rehberde `sync` (hedefte fazlalığı siler) değil, güvenli olan `copy` kullanılır.

## 3. Ön Koşullar

1. **Kendi OAuth Client ID'niz:** rclone'un paylaşılan client_id'si **2026 içinde kullanımdan kaldırılıyor**; resmî belge artık kendi anahtarınızı oluşturmanızı **şiddetle öneriyor**. Google Cloud Console'da ücretsiz bir proje oluşturun, OAuth istemci kimliği (Masaüstü uygulaması türü) üretin; Photos API'yi etkinleştirin. Ayrıntılı adımlar: `https://rclone.org/googlephotos/#making-your-own-client-id`
2. **Hedef hesapta yeterli depolama:** Aktarım öncesi hesabın kalan alanını kontrol edin (400 GB+).
3. **rclone sürüm kontrolü:** Konteyner konsolunda `rclone version` çalıştırın.
4. **Kaynak yolların teyidi:** Aşağıdaki komutlarda `/nas_dosyalarim/Klasor1..4` örnek yolu kullanılmıştır; kendi ortamınızdaki gerçek yollarla değiştirin (`ls /nas_dosyalarim` ile doğrulayın).

## 4. Adım 1 — İkinci Google Hesabını Tanıtma (`rclone config`)

Portainer konsolunda (`/data #`):

```sh
rclone config
```

Menü akışı:

1. `n` → **New remote** (yeni bağlantı).
2. `name>` → bağlantı adı, örneğin: `ikinci_hesap`
3. `Storage>` → **`google photos`** yazın (sondaki numaralı listeden ilgili numarayı da girebilirsiniz).
4. `client_id>` ve `client_secret>` → kendi oluşturduğunuz anahtarları girin (önerilir; boş bırakırsanız 2026'da emekliye ayrılan paylaşılan kimlik kullanılır ve `Continue using the shared client_id anyway?` sorusuna `n` cevabı vermeniz istenir).
5. `read_only>` → `false` (varsayılan; yazma için gerekli).
6. `Edit advanced config? (y/n)` → `n`.
7. `Use web browser to automatically authenticate rclone with remote?` sorusuna **kesinlikle `n`** cevabı verin (konteyner içinde tarayıcı açılamaz).
8. Konsol size `rclone authorize "google photos" ...` biçiminde tam bir komut verecektir. **Kendi bilgisayarınızda** (tarayıcılı makinede, aynı rclone sürümü önerilir) bu komutu birebir çalıştırın:
   - Tarayıcıda Google hesabıyla oturum açıp onaylayın; yerel makinede `http://127.0.0.1:53682/` üzerinden kod toplanır (yerel güvenlik duvarı engelliyorsa geçici izin verin).
   - Komut çıktısındaki `Paste the following into your remote machine --->` ile işaretli token blokunu kopyalayın.
9. Konteyner konsolundaki `config_token>` istemine bu bloku yapıştırın.
10. `Keep this "ikinci_hesap" remote?` → `y` ile kaydedin, ardından `q` ile çıkın.

Doğrulama:

```sh
rclone lsd ikinci_hesap:album
```

Yeni hesapta albüm yoksa boş döner; komut hata vermiyorsa kimlik doğrulama çalışıyor demektir.

## 5. Adım 2 — 4 Klasörü Albüm Olarak Aktarma

Önce provayı yapın (hiçbir şey yüklemez, ne yapılacağını listeler):

```sh
rclone copy /nas_dosyalarim/Klasor1 ikinci_hesap:album/Klasor1 --tpslimit 3 --transfers 2 --dry-run -v
```

Gerçek aktarım — dört klasör sırayla, tek zincirde:

```sh
rclone copy /nas_dosyalarim/Klasor1 ikinci_hesap:album/Klasor1 --tpslimit 3 --transfers 2 --log-file=/data/foto_aktarim.log -v && \
rclone copy /nas_dosyalarim/Klasor2 ikinci_hesap:album/Klasor2 --tpslimit 3 --transfers 2 --log-file=/data/foto_aktarim.log -v && \
rclone copy /nas_dosyalarim/Klasor3 ikinci_hesap:album/Klasor3 --tpslimit 3 --transfers 2 --log-file=/data/foto_aktarim.log -v && \
rclone copy /nas_dosyalarim/Klasor4 ikinci_hesap:album/Klasor4 --tpslimit 3 --transfers 2 --log-file=/data/foto_aktarim.log -v
```

Sondaki `&` ile arka plana almak mümkündür; ancak Portainer konsol penceresini kapatmak işlemi öldürebileceği için ya konsolu açık tutun ya da bağlantı kesilmesine karşı `nohup` kullanın:

```sh
nohup sh -c 'rclone copy /nas_dosyalarim/Klasor1 ikinci_hesap:album/Klasor1 --tpslimit 3 --transfers 2 --log-file=/data/foto_aktarim.log -v && rclone copy /nas_dosyalarim/Klasor2 ikinci_hesap:album/Klasor2 --tpslimit 3 --transfers 2 --log-file=/data/foto_aktarim.log -v && rclone copy /nas_dosyalarim/Klasor3 ikinci_hesap:album/Klasor3 --tpslimit 3 --transfers 2 --log-file=/data/foto_aktarim.log -v && rclone copy /nas_dosyalarim/Klasor4 ikinci_hesap:album/Klasor4 --tpslimit 3 --transfers 2 --log-file=/data/foto_aktarim.log -v' >/data/aktarim_zinciri.log 2>&1 &
```

### Bayrakların Gerekçesi

| Bayrak | Görevi |
|---|---|
| `--tpslimit 3` | Saniyede en fazla 3 HTTP işlemi; Google'ın kullanıcı başı API hız limitine takılmayı (403 `userRateLimitExceeded`) önler |
| `--transfers 2` | Aynı anda en fazla 2 paralel dosya yükleme; hız limitine çift güvence |
| `--log-file=... -v` | Tüm ilerlemeyi dosyaya yazar; konsol kopsa bile kayıt kalır |
| `--dry-run` | Prova modu; listeler, yüklemez |

## 6. İzleme, Kesinti ve Sürdürme

- **Canlı izleme:** `tail -f /data/foto_aktarim.log`
- **Kesilirse:** Zinciri kaldığı klasörden başlatarak yeniden çalıştırın. `rclone copy` hedefte aynı ad/boyuttaki öğeleri atlayıp kalanı yükler; devam etmeden önce `--dry-run` ile nelerin yükleneceğini kontrol edebilirsiniz.
- **Doğrulama (aktarım sonrası):**

```sh
rclone size /nas_dosyalarim/Klasor1
rclone size ikinci_hesap:album/Klasor1
rclone lsd ikinci_hesap:album
```

Kaynak ve hedef boyut/fiş sayıları örtüşmeli, albüm listesinde dört kök albüm görünmelidir. Reddedilen desteklenmeyen dosyalar (bkz. bölüm 2.4) logda hata olarak listelenir; sayısal fark varsa önce logu inceleyin.

## 7. Sık Karşılaşılan Hatalar

| Belirti | Neden | Çözüm |
|---|---|---|
| 403 `userRateLimitExceeded` / `rateLimitExceeded` | API hız limiti aşıldı | `--tpslimit` değerini 2'ye veya 1'e düşürün; işlemi bir süre sonra yeniden çalıştırın |
| `Upload error: ... unsupported` | Dosya türü resim/video değil (`.txt`, `.zip`, `.db`, bazı RAW'lar) | Bu dosyalar için Google Drive rehberini kullanın (`rclone-google-drive-aktarimi.md`) |
| `Quota exceeded` / `storageQuotaExceeded` | Hedef hesabın depolama alanı doldu | Google One alanını büyütün veya aktarımı bölün |
| Albüme yazma hatası | Albüm rclone dışında (web/uygulama) oluşturulmuş | Albümü silin; rclone kendi oluştursun (bkz. bölüm 2.3) |
| Kimlik doğrulama sırasında tarayıcı açılmıyor | Konteynerde tarayıcı yok | Adım 1.7'deki `n` + `rclone authorize` akışını kullanın; yerel makinede `http://localhost:53682/` yönlendirme adresine izin verin |
