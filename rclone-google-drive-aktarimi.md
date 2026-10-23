# rclone ile Google Drive'a Klasör Yapısıyla Aktarım Rehberi (400+ GB / 4 Klasör)

> Kaynak: rclone resmî belgeleri — `https://rclone.org/drive/` ve `https://rclone.org/remote_setup/` (Context7 `/rclone/rclone` üzerinden 2026-10-23 tarihinde doğrulandı). Komutlar, rclone_gui konteynerinin Portainer konsolunda (`/data #` istemi) çalıştırılacak şekilde hazırlanmıştır.

## 1. Bu Belge Ne Zaman Kullanılır?

| Amacınız | Doğru Rehber |
|---|---|
| Klasör/dizin ağacını **birebir koruyarak**, her dosya türünü kabul eden, **kaybı olmayan** bir bulut arşivi oluşturmak | **Bu belge** |
| Fotoğrafları **albüm olarak** Google Fotoğraflar uygulamasında gezmek | `rclone-google-fotograflar-aktarimi.md` |

400+ GB'lık bir fotoğraf arşivinin tek kopyasını bulutta tutmak istiyorsanız, geri indirmede çözünürlük kaybı olmaması nedeniyle **Drive doğru hedeftir**.

## 2. Başlamadan Önce Kritik Gerçekler

1. **Günlük 750 GiB yükleme limiti:** Google Drive, resmî olarak belgelenmemiş bir kurala göre günde en fazla **750 GiB** veri yüklemeye izin verir. Limit aşılırsa Google farklı bir hata iletisi döndürür; `--drive-stop-on-upload-limit` bayrağı bu hatayı **ölümcül** yaparak aktarımı orada durdurur. rclone bu tespiti hata iletisi metin eşleştirmesiyle yaptığını belirtir; Google ileti metnini değiştirirse tespit çalışmayabilir. 400+ GB'lık aktarım tek günde biter; yine de limite takılma ihtimaline karşı sürdürme adımı bölüm 6'dadır.
2. **Hedef hesapta yeterli depolama:** 400+ GB için Google One aboneliği gerekir; ücretsiz 15 GB yetersizdir. Alan biterse aktarım `storageQuotaExceeded` hatasıyla durur.
3. **Kendi OAuth Client ID'niz:** rclone'un paylaşılan Drive client_id'si **2026 içinde kullanımdan kaldırılıyor**; resmî belge kendi anahtarınızı oluşturmanızı şiddetle öneriyor. Ayrıntılı adımlar: `https://rclone.org/drive/#making-your-own-client-id`
4. **Kayıpsız geri indirme:** Drive, dosyaları değiştirmez; ileride `rclone copy ikinci_hesap:Fotograflar /geri_yukleme` ile birebir geri indirilir. (Fotoğraflar backend'indeki çözünürlük/EXIF kısıtı Drive için söz konusu değildir.)
5. **`sync` hedefi temizler:** `rclone sync`, hedefte kaynakta bulunmayan dosyaları siler. Drive'da silme varsayılan olarak **çöp kutusuna** gönderir (`--drive-use-trash`, varsayılan `true`); yine de yeni ve boş bir hedef hesapta çalıştırmak en güvenlisidir.
6. **Her dosya türü kabul edilir:** Metin, arşiv, RAW gibi türler sorun çıkarmaz.

## 3. Ön Koşullar

1. Google Cloud Console'dan OAuth istemci kimliği (Masaüstü uygulaması türü) + Drive API etkin (bkz. bölüm 2.3).
2. Hedef hesapta ≥400 GB boş alan.
3. `rclone version` ile konteynerdeki sürümün güncelliğini kontrol edin.
4. Kaynak yolların teyidi: komutlardaki `/nas_dosyalarim/Klasor1..4` örnek yollarını kendi ortamınıza göre değiştirin (`ls /nas_dosyalarim`).

## 4. Adım 1 — İkinci Google Hesabını Tanıtma (`rclone config`)

Portainer konsolunda (`/data #`):

```sh
rclone config
```

Menü akışı:

1. `n` → **New remote**.
2. `name>` → `ikinci_hesap`
3. `Storage>` → **`drive`** yazın.
4. `client_id>` / `client_secret>` → kendi anahtarlarınız (önerilir). Boş bırakırsanız paylaşılan kimlik uyarısı alırsınız; `Continue using the shared client_id anyway?` → `n` seçip kendi anahtarlarınızı girin.
5. `scope>` → **`1`** (`drive` — tam erişim).
6. `service_account_file>` → boş bırakın (Enter).
7. `Edit advanced config? (y/n)` → `n`.
8. `Use web browser to automatically authenticate rclone with remote?` → **kesinlikle `n`** (konteynerde tarayıcı yok).
9. Konsolun verdiği `rclone authorize "drive" ...` komutunu **kendi bilgisayarınızda** çalıştırın; tarayıcıda yeni Google hesabıyla oturum açıp onaylayın (yerel makinede `http://127.0.0.1:53682/` kullanılır). Çıktıdaki `Paste the following into your remote machine --->` token blokunu kopyalayıp konteyner konsolundaki `config_token>` istemine yapıştırın.
10. `Configure this as a Shared Drive (Team Drive)?` → `n`.
11. `Keep this "ikinci_hesap" remote?` → `y`, ardından `q` ile çıkın.

Doğrulama:

```sh
rclone about ikinci_hesap:
```

Hesabın toplam/boş alanını listeler; hem kimlik doğrulamayı hem de 400 GB kapasite ön koşulunu tek komutta teyit etmiş olursunuz.

## 5. Adım 2 — 4 Klasörü Klasör Yapısıyla Aktarma

Önce prova (hiçbir şey yüklemez):

```sh
rclone sync /nas_dosyalarim/Klasor1 ikinci_hesap:Fotograflar/Klasor1 --exclude "#Recycle/**" --exclude ".@**" --exclude "@**" --drive-stop-on-upload-limit --dry-run -v
```

Gerçek aktarım — dört klasör sırayla, tek zincirde:

```sh
rclone sync /nas_dosyalarim/Klasor1 ikinci_hesap:Fotograflar/Klasor1 --exclude "#Recycle/**" --exclude ".@**" --exclude "@**" --drive-stop-on-upload-limit --log-file=/data/drive_aktarim.log -v && \
rclone sync /nas_dosyalarim/Klasor2 ikinci_hesap:Fotograflar/Klasor2 --exclude "#Recycle/**" --exclude ".@**" --exclude "@**" --drive-stop-on-upload-limit --log-file=/data/drive_aktarim.log -v && \
rclone sync /nas_dosyalarim/Klasor3 ikinci_hesap:Fotograflar/Klasor3 --exclude "#Recycle/**" --exclude ".@**" --exclude "@**" --drive-stop-on-upload-limit --log-file=/data/drive_aktarim.log -v && \
rclone sync /nas_dosyalarim/Klasor4 ikinci_hesap:Fotograflar/Klasor4 --exclude "#Recycle/**" --exclude ".@**" --exclude "@**" --drive-stop-on-upload-limit --log-file=/data/drive_aktarim.log -v
```

Portainer konsol penceresini kapatmak işlemi öldürebileceği için ya konsolu açık tutun ya da `nohup` ile bağlantı kesilmesine karşı koruyun:

```sh
nohup sh -c 'rclone sync /nas_dosyalarim/Klasor1 ikinci_hesap:Fotograflar/Klasor1 --exclude "#Recycle/**" --exclude ".@**" --exclude "@**" --drive-stop-on-upload-limit --log-file=/data/drive_aktarim.log -v && rclone sync /nas_dosyalarim/Klasor2 ikinci_hesap:Fotograflar/Klasor2 --exclude "#Recycle/**" --exclude ".@**" --exclude "@**" --drive-stop-on-upload-limit --log-file=/data/drive_aktarim.log -v && rclone sync /nas_dosyalarim/Klasor3 ikinci_hesap:Fotograflar/Klasor3 --exclude "#Recycle/**" --exclude ".@**" --exclude "@**" --drive-stop-on-upload-limit --log-file=/data/drive_aktarim.log -v && rclone sync /nas_dosyalarim/Klasor4 ikinci_hesap:Fotograflar/Klasor4 --exclude "#Recycle/**" --exclude ".@**" --exclude "@**" --drive-stop-on-upload-limit --log-file=/data/drive_aktarim.log -v' >/data/aktarim_zinciri.log 2>&1 &
```

### Bayrakların Gerekçesi

| Bayrak | Görevi |
|---|---|
| `--drive-stop-on-upload-limit` | 750 GiB/gün limiti aşılınca aktarımı ölümcül hatayla durdurur; logda net iz bırakır |
| `--exclude "#Recycle/**" --exclude ".@**" --exclude "@**"` | NAS'a özgü geri dönüşüm ve gizli sistem dosyalarını dışarıda bırakır |
| `--log-file=... -v` | İlerlemeyi dosyaya yazar; konsol kopsa bile kayıt kalır |
| `--dry-run` | Prova modu; listeler, yüklemez |

## 6. İzleme, Kesinti ve Sürdürme

- **Canlı izleme:** `tail -f /data/drive_aktarim.log`
- **Kesilirse:** Aynı `sync` komutunu yeniden çalıştırın. Drive modtime desteği nedeniyle `sync` tekrar çalıştırmaya dayanıklıdır; yüklenmiş dosyalar atlanır, eksikler tamamlanır.
- **750 GiB limitine takıldıysa:** Aktarım ölümcül hatayla durur. Limit genellikle Pasifik saatiyle gece yarısı sıfırlanır (doğrulanmalı); en güvenlisi 24 saat bekleyip aynı zinciri yeniden çalıştırmaktır.
- **Doğrulama (aktarım sonrası):**

```sh
rclone check /nas_dosyalarim/Klasor1 ikinci_hesap:Fotograflar/Klasor1 --exclude "#Recycle/**" --exclude ".@**" --exclude "@**" --log-file=/data/kontrol.log -v
rclone lsd ikinci_hesap:Fotograflar
```

`rclone check`, kaynak ve hedef arasındaki dosya/boyut farklarını raporlar; dört klasör için de "0 differences" sonucu alınca aktarım tamamdır.

## 7. Sık Karşılaşılan Hatalar

| Belirti | Neden | Çözüm |
|---|---|---|
| `Google drive: Upload limit reached` (ölümcül) | 750 GiB/gün limiti doldu | 24 saat bekleyip aynı zinciri yeniden çalıştırın; kaldığı yerden devam eder |
| 403 `userRateLimitExceeded` | API hız limiti (paylaşılan client_id'de günlük kota çok düşüktür; kendi kimliğinizde yüksektir) | Kendi client_id'niz yoksa oluşturun; `--tpslimit 10` ekleyip yeniden deneyin |
| `storageQuotaExceeded` | Hedef hesabın alanı doldu | Google One alanını büyütün |
| `invalid_grant` / token hatası | Kimlik doğrulama süresi doldu veya hesap erişimi kaldırıldı | `rclone config` → `e` (edit) ile `ikinci_hesap`'ı seçip `y` ile yeniden kimlik doğrulayın |
| `rclone about` bağlanamıyor | Config'te yanlış scope veya eksik token | Adım 1'i baştan uygulayın; `rclone config show ikinci_hesap` ile ayarları inceleyin |
