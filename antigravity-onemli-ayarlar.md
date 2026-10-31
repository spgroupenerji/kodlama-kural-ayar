# Antigravity Önemli Ayarlar — Terminal Komutları Deny List

> Kaynak: `antigravity önemli ayar.png` · v202610310311

Antigravity IDE'de **Deny List Terminal Commands** ayar ekranı. Ajan, deny listesindeki kurallarla eşleşen terminal komutlarını çalıştırmadan önce izin ister.

## Ayarın İşleyişi

> Agent asks for permission before executing commands matched by a deny list entry. The deny list follows the same matching rules as the allow list and takes precedence over the allow list.

Ekran görüntüsündeki açıklama metninin çevirisi: Ajan, deny list girdisiyle eşleşen komutları çalıştırmadan önce izin ister. Deny list, allow list ile aynı eşleştirme kurallarını izler ve allow list'e göre önceliklidir.

## Tanımlı Girişler

| # | Komut | Amaç |
| --- | --- | --- |
| 1 | `Set-Content` | PowerShell dosya üzerine yazma komutu |
| 2 | `Add-Content` | PowerShell dosyaya ekleme komutu |
| 3 | `Out-File` | PowerShell çıktıyı dosyaya yazma komutu |
| 4 | `>>` | Kabuk çıktı yönlendirme (üzerine yazma) operatörü |
| 5 | `Replace` | Dosya/değişken içerik değiştirme komutu |

Tüm girişler dosya yazma/değiştirme yeteneğine sahip komutlardır; amacın ajanın dosyaları doğrudan üzerine yazmasını/değiştirmesini kısıtlamak, bu işlemlerin elle onaydan geçmesini sağlamak olduğu değerlendiriliyor. Sağ üstte **+ Add** düğmesiyle yeni giriş eklenebilir.

Not: Bu deny list yapılandırması, ajan kaynaklı istenmeyen dosya değişikliklerine karşı pratik bir güvenlik katmanıdır; allow list'ten önce geldiği için güvenilir birincil koruma olarak da kullanılabilir.
