#!/usr/bin/env bash
# SP GROUP cPanel/CloudLinux ortam envanteri — Python dağıtım hazırlığı.
# Kullanım:  bash docs/ortam_envanteri.sh   (betik <uygulama kökü>/docs/ içindeyse kök otomatik)
#            KOK=/home/kullanici/alanadi bash docs/ortam_envanteri.sh
# Çıktı:     betiğin dizinindeki ortam_envanteri.txt (umask 077, 600 izin)
# Sır politikası: .env dosyalarından yalnız ANAHTAR adları; crontab kimlik parametreleri maskelenir.
# cPanel mekanikleri docs.cpanel.net "How to Install a Python WSGI Application" ile doğrulandı:
#   passenger_wsgi.py içindeki INTERP satırı venv python'ını işaret eder; yayına alma
#   uygulama kökündeki tmp/restart.txt dokunma dosyasıyladır (mod_passenger).
# Windows'tan taşınırsa dos2unix uygula (*.sh eol=lf).
set -uo pipefail
shopt -s nullglob

BETIK_DIZINI="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
KOK="${KOK:-$(dirname -- "$BETIK_DIZINI")}"
KULLANICI="$(id -un 2>/dev/null || whoami)"
CIKTI="$BETIK_DIZINI/ortam_envanteri.txt"

PHP_BIN=""
SISTEM_PYTHON_ADAY=""
SAGLIKLI_VENV_PYTHON=""
REQ_DOSYA=""
MODUL_KAYNAK=""
MODUL_DOSYASI=""

bolum() { printf '\n===== %s =====\n' "$1"; }

modul_adi_cevir() {
    case "$1" in
        python-dotenv)   echo dotenv ;;
        pyyaml)          echo yaml ;;
        beautifulsoup4)  echo bs4 ;;
        pillow)          echo PIL ;;
        scikit-learn)    echo sklearn ;;
        scikit-image)    echo skimage ;;
        *)               echo "$1" ;;
    esac
}

requirements_adlari() {
    awk '{split($0,a,"#"); s=a[1]; sub(/\[.*/,"",s); sub(/[<>=!~; \t].*/,"",s);
          gsub(/^[ \t]+|[ \t]+$/,"",s); if (s!="") print tolower(s)}' "$1" 2>/dev/null | sort -u
}

modul_listesi_hazirla() {
    MODUL_DOSYASI="$(mktemp 2>/dev/null)" || { echo "mktemp başarısız" >&2; exit 1; }
    local f
    if [ -f "$KOK/requirements.txt" ]; then
        REQ_DOSYA="$KOK/requirements.txt"
    else
        f="$(find "$KOK" -maxdepth 2 -name 'requirements.txt' -type f 2>/dev/null | sort | head -1)"
        [ -n "$f" ] && REQ_DOSYA="$f"
    fi
    if [ -n "$REQ_DOSYA" ]; then
        requirements_adlari "$REQ_DOSYA" > "$MODUL_DOSYASI"
        MODUL_KAYNAK="$REQ_DOSYA"
    else
        printf '%s\n' pandas pyarrow aiomysql pdfplumber aiohttp cryptography dotenv > "$MODUL_DOSYASI"
        MODUL_KAYNAK="(varsayılan liste — requirements.txt bulunamadı)"
    fi
}

denetim_php_sec() {
    local aday
    aday="$(crontab -l 2>/dev/null | tr ' ' '\n' | grep -m1 -E '^/opt/(alt|cpanel)/[^ ]*/php$')"
    if [ -z "$aday" ]; then
        for aday in /opt/alt/php*/usr/bin/php /opt/cpanel/ea-php*/root/usr/bin/php; do
            [ -x "$aday" ] && break
        done
    fi
    if [ -n "$aday" ] && [ -x "$aday" ]; then PHP_BIN="$aday"; fi
}

env_anahtarlari() {
    sed -E 's/^[[:space:]]*(export[[:space:]]+)?//' "$1" 2>/dev/null \
        | grep -oE '^[A-Za-z_][A-Za-z0-9_]*' | sort -u
}

env_bilgisi_yaz() {
    local f=$1 ornek eksik
    echo "-- $f"
    echo "   satır: $(wc -l < "$f" 2>/dev/null || echo 0)"
    printf '   anahtarlar: '
    env_anahtarlari "$f" | tr '\n' ' '
    echo
    ornek="${f}.example"
    if [ -f "$ornek" ]; then
        eksik="$(comm -23 <(env_anahtarlari "$ornek") <(env_anahtarlari "$f") | tr '\n' ' ')"
        if [ -n "$eksik" ]; then
            echo "   örnekte olup .env'te eksik: $eksik"
        else
            echo "   örnek karşılaştırma: eksik anahtar yok"
        fi
    fi
}

python_ikilileri_yaz() {
    local p
    for p in /opt/alt/python3*/bin/python3 /opt/alt/python3*/bin/python3.[0-9] \
             /opt/alt/python3*/bin/python3.[0-9]m /opt/alt/python3*/usr/bin/python3 \
             /opt/alt/python3*/usr/bin/python3.[0-9] \
             /opt/cpanel/ea-python*/root/usr/bin/python3.[0-9] \
             /usr/bin/python3 /usr/bin/python3.[0-9] \
             /usr/local/bin/python3 /usr/local/bin/python3.[0-9]; do
        [ -x "$p" ] || continue
        printf '%s → %s' "$p" "$("$p" -V 2>&1 | head -1)"
        "$p" -m venv --help >/dev/null 2>&1 && printf ' | venv:VAR' || printf ' | venv:YOK'
        "$p" -m ensurepip --version >/dev/null 2>&1 && printf ' | ensurepip:VAR' || printf ' | ensurepip:YOK'
        echo
        [ -z "$SISTEM_PYTHON_ADAY" ] && SISTEM_PYTHON_ADAY="$p"
    done
    if command -v python3 >/dev/null 2>&1; then
        echo "PATH'teki python3: $(command -v python3) → $(python3 -V 2>&1 | head -1)"
    else
        echo "PATH'teki python3: (yok)"
    fi
}

venv_kokleri_bul() {
    { find "$HOME/virtualenv" -maxdepth 4 -name pyvenv.cfg 2>/dev/null
      find "$HOME/venvs"      -maxdepth 3 -name pyvenv.cfg 2>/dev/null
      find "$KOK"             -maxdepth 3 -name pyvenv.cfg 2>/dev/null; } | awk '!seen[$0]++'
}

venv_incele() {
    local v=$1 sp ad kod
    echo "-- $v"
    if [ -x "$v/bin/python" ]; then
        echo "   $( "$v/bin/python" -V 2>&1 | head -1 )"
        "$v/bin/python" -m pip -V 2>&1 | head -1 | sed 's/^/   pip: /'
        [ -z "$SAGLIKLI_VENV_PYTHON" ] && SAGLIKLI_VENV_PYTHON="$v/bin/python"
    else
        echo "   (python ikilisi çalıştırılamadı)"
    fi
    [ -f "$v/pyvenv.cfg" ] && sed 's/^/   cfg: /' "$v/pyvenv.cfg"
    sp="$(ls -d "$v"/lib/python*/site-packages 2>/dev/null | head -1)"
    echo "   site-packages: ${sp:-yok}"
    [ -n "$sp" ] || return 0
    while IFS= read -r ad; do
        [ -n "$ad" ] || continue
        kod="$(modul_adi_cevir "$ad")"
        if [ -d "$sp/$kod" ] || [ -d "$sp/$ad" ]; then
            printf '   %s:VAR' "$ad"
        else
            printf '   %s:YOK' "$ad"
        fi
    done < "$MODUL_DOSYASI"
    echo
}

passenger_envanteri_yaz() {
    local w interp
    while IFS= read -r w; do
        echo "-- $w"
        interp="$(grep -m1 -oE 'INTERP[[:space:]]*=[[:space:]]*"[^"]+"' "$w" 2>/dev/null | sed 's/.*"\(.*\)"/\1/')"
        if [ -n "$interp" ]; then
            if [ -x "$interp" ]; then
                echo "   INTERP: $interp → ÇALIŞIYOR ($("$interp" -V 2>&1 | head -1))"
            else
                echo "   INTERP: $interp → ÇALIŞTIRILAMADI (venv bozuk ya da taşınmış)"
            fi
        else
            echo "   (INTERP satırı yok — Passenger hangi python'ı kullanacağını bilemez)"
        fi
    done < <(find "$KOK" -maxdepth 3 -name passenger_wsgi.py 2>/dev/null)
    if [ -e "$KOK/tmp/restart.txt" ]; then
        echo "restart.txt: VAR ($(date -r "$KOK/tmp/restart.txt" '+%F %T' 2>/dev/null))"
    else
        echo "restart.txt: yok — yayına alma için: mkdir -p '$KOK/tmp' && touch '$KOK/tmp/restart.txt'"
    fi
}

crontab_maskeli_yaz() {
    local mask='s/(token|password|passwd|secret|api[_-]?key|sifre|key)=[^ &"]+/\1=[MASKED]/gI'
    crontab -l 2>/dev/null | sed -E "$mask" | head -40
    [ "${PIPESTATUS[0]:-0}" -ne 0 ] && echo "(crontab okunamadı)"
}

ozet_yaz() {
    local oneri kaynak disk_yuzde
    echo "Uygulama kökü: $KOK"
    echo "Denetim PHP'si: ${PHP_BIN:-(bulunamadı)}"
    if [ -n "$SAGLIKLI_VENV_PYTHON" ]; then
        oneri="$SAGLIKLI_VENV_PYTHON"; kaynak="mevcut venv"
    elif [ -n "$SISTEM_PYTHON_ADAY" ]; then
        oneri="$SISTEM_PYTHON_ADAY"
        kaynak="sistem ikilisi — yeni venv: '$SISTEM_PYTHON_ADAY' -m venv \"\$HOME/venvs/<ad>\""
    else
        oneri=""; kaynak="python bulunamadı"
    fi
    echo "Önerilen Python: ${oneri:-yok} ($kaynak)"
    if [ -n "$oneri" ] && [ -n "$REQ_DOSYA" ]; then
        echo "Kurulum komutu: '$oneri' -m pip install -r '$REQ_DOSYA'"
    fi
    echo "Modül kontrol kaynağı: $MODUL_KAYNAK"
    disk_yuzde="$(df -P /home 2>/dev/null | awk 'NR==2{gsub(/%/,"",$5); print $5}')"
    if [ -n "$disk_yuzde" ] && [ "$disk_yuzde" -ge 90 ]; then
        echo "UYARI: /home doluluğu %${disk_yuzde} — kurulum öncesi yer açılmalı."
    fi
    echo "Yayına alma (Passenger): mkdir -p '$KOK/tmp' && touch '$KOK/tmp/restart.txt'"
}

trap 'rm -f "$MODUL_DOSYASI"' EXIT
modul_listesi_hazirla
denetim_php_sec

umask 077
echo "Envanter yazılıyor: $CIKTI"
exec > "$CIKTI" 2>&1

echo "SP GROUP ORTAM ENVANTERİ — $(date '+%F %T') — kök: $KOK"

bolum "[0] SUNUCU"
hostname
date
uname -srm
cat /etc/redhat-release 2>/dev/null || grep -h '^PRETTY_NAME' /etc/os-release 2>/dev/null || echo "(dağıtım bilgisi okunamadı)"
echo "kullanıcı: $KULLANICI | HOME: $HOME | kabuk: $SHELL"

bolum "[1] CANLI KOD SÜRÜMÜ VE KÖK DİZİN YAPISI"
if git -C "$KOK" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$KOK" log --oneline -1
    git -C "$KOK" status --short | head -10
else
    echo "(git deposu değil — deploy akışı için önce git clone gerekli)"
fi
echo "git: $(git --version 2>&1 || echo '(yok — kurulmalı)')"
echo "-- kök içeriği:"
ls -A "$KOK" 2>/dev/null | head -50
echo "-- üst düzey dizinlerin dosya sayıları (3 düzey):"
for d in "$KOK"/*/; do
    [ -d "$d" ] || continue
    printf '   %s: %s\n' "$(basename "$d")" "$(find "$d" -maxdepth 3 -type f 2>/dev/null | wc -l)"
done

bolum "[2] .ENV ENVANTERİ (yalnız ANAHTAR ADLARI)"
if [ -f "$HOME/.env" ]; then env_bilgisi_yaz "$HOME/.env"; fi
while IFS= read -r f; do
    env_bilgisi_yaz "$f"
done < <(find "$KOK" -maxdepth 2 -name '.env' -type f 2>/dev/null | sort)
echo "(değerler güvenlik için asla yazılmaz)"

bolum "[3] PHP İKİLİLERİ VE WEB PHP KAYDI"
for p in /opt/alt/php*/usr/bin/php /opt/cpanel/ea-php*/root/usr/bin/php \
         /usr/local/bin/ea-php* /usr/bin/php /usr/local/bin/php; do
    [ -e "$p" ] || continue
    printf '%s → ' "$p"; "$p" -v 2>&1 | head -1
done
echo "Denetim PHP'si: ${PHP_BIN:-(bulunamadı)}"
echo "-- MultiPHP kaydı (userdata):"
BOLGE="$(basename "$KOK")"
SONUC="$(find /var/cpanel/userdata -maxdepth 2 -name "$BOLGE*" -exec grep -hE 'php[0-9]{2}' {} + 2>/dev/null | head -3)"
[ -n "$SONUC" ] && echo "$SONUC" || echo "(userdata okunamadı — cPanel MultiPHP Manager'dan domainin sürümünü yaz)"
echo "-- crontab'ta kullanılan PHP ikilileri:"
crontab -l 2>/dev/null | tr ' ' '\n' | grep -E '^/opt/.*/php$' | sort -u || echo "(crontab okunamadı veya PHP satırı yok)"

bolum "[4] CLOUDLINUX ARAÇLARI"
for komut in selectorctl cagefsctl; do
    if command -v "$komut" >/dev/null 2>&1; then
        echo "$komut: $(command -v "$komut")"
    else
        echo "$komut: (yok)"
    fi
done
echo "(Python sürüm seçimi cPanel 'Setup Python App' arayüzüyle yapılır; venv'ler ~/virtualenv altına oluşur.)"

bolum "[5] PYTHON İKİLİLERİ (venv/ensurepip yeteneğiyle)"
python_ikilileri_yaz

bolum "[6] SANAL ORTAMLAR (keşif: ~/virtualenv, ~/venvs, uygulama içi)"
VENV_SAYISI=0
while IFS= read -r v; do
    venv_incele "$(dirname -- "$v")"
    VENV_SAYISI=$((VENV_SAYISI + 1))
done < <(venv_kokleri_bul)
[ "$VENV_SAYISI" -eq 0 ] && echo "(pyvenv.cfg bulunamadı)"

bolum "[7] PASSENGER KAYDI (passenger_wsgi.py)"
passenger_envanteri_yaz

bolum "[8] REQUIREMENTS DOSYASI"
if [ -n "$REQ_DOSYA" ]; then
    echo "kaynak: $REQ_DOSYA"
    sed 's/^/   /' "$REQ_DOSYA"
else
    echo "(requirements.txt bulunamadı — modül kontrolü varsayılan listeyle yapıldı)"
fi

bolum "[9] DİSK"
df -h /home 2>/dev/null | tail -1 || echo "(df /home okunamadı)"
df -i /home 2>/dev/null | tail -1
echo "-- uygulama kökü altındaki dizin boyutları:"
du -sh "$KOK"/*/ 2>/dev/null | sort -rh | head -15

bolum "[10] CRONTAB (MASKELİ)"
crontab_maskeli_yaz

bolum "[11] ORTAM DENETİMİ (uygulamanın kendi PHP denetimi)"
if [ -n "$PHP_BIN" ] && [ -f "$KOK/destek/ortam_denetimi.php" ]; then
    echo "-- kurulum planı:"
    (cd "$KOK" && "$PHP_BIN" destek/ortam_denetimi.php --kurulum)
    echo "-- tam denetim:"
    (cd "$KOK" && "$PHP_BIN" destek/ortam_denetimi.php); echo "EXIT=$?"
else
    echo "($KOK/destek/ortam_denetimi.php yok veya PHP ikilisi bulunamadı — atlandı)"
fi

bolum "[12] SONUÇ ÖZETİ VE KURULUM ÖNERİSİ"
ozet_yaz
