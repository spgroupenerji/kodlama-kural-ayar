# Rust Masaüstü Arayüzü — GPUI + GPUI Kit (macOS / Linux)

> Doğrulama: 2026-10-25 · Kaynaklar: crates.io API, gpui-kit.com, gpui-kit 0.8.0 crate kaynakları.

## Karar

WebView barındırmayan, GPU hızlandırmalı, ticari kullanıma tamamen açık (Apache-2.0) hedef için seçim: **`gpui-kit`** (GPUI + gpui-base + gpui-component + Lucide ikonları tek pakette).

| Katman | Sürüm | Lisans | Sağladığı |
| --- | --- | --- | --- |
| `gpui-kit` | 0.8.0 | Apache-2.0 | Tek bağımlılık; hepsini yeniden dışa aktarır |
| `gpui-component` | 0.8.0 | Apache-2.0 | 75+ stilli bileşen (tablo, dock, grafik, editör, form, diyalog) |
| `gpui-pre` | 0.3.9 (sabit) | Apache-2.0 | Zed'in GPUI anlık görüntüsü; macOS Metal, Linux wgpu→Vulkan |
| `gpui-kit-assets` | 0.8.0 | Apache-2.0 | 1830 ikonluk Lucide + GPUI Kit seti, varsayılan asset kaynağı |

- **Platform:** macOS 15+, Linux (Wayland ve X11). Windows da desteklenir; bu belgenin hedefi değil.
- **Erişilebilirlik:** AccessKit (`accesskit` 0.24; Linux'ta `accesskit_unix`, macOS'ta `accesskit_macos`).
- **WebView:** Varsayılan değil. Ayrı `gpui-webview` paketi (Wry tabanlı) isteğe bağlıdır; `gpui-kit` varsayılan özellikleri `component` + `assets`'tir.

Tek tuzak: `gpui-kit`, GPUI'yi crates.io'daki `gpui` 0.2.2'den değil, **sürümü sabitlenmiş `gpui-pre` 0.3.9** anlık görüntüsünden alır. İki paket aynı uygulamada karıştırılmamalı.

## Neden diğerleri değil — 2026-10 durumu

| Seçenek | Sürüm | Lisans | Elenme nedeni |
| --- | --- | --- | --- |
| **GPUI Kit** | 0.8.0 | Apache-2.0 | Seçim |
| Slint | 1.18.1 | GPL-3.0 / ticari / Royalty-free 2.0 | MIT/Apache değil. Royalty-free lisansı "Hakkında" ekranında `AboutSlint` veya "Made with Slint" rozetiyle **atıf** şartı koyar |
| Floem | 0.2.0 (2024-11) | MIT | Kararlı sürüm hâlâ 0.2.0; erişilebilirlik/bileşen katmanı GPUI Kit seviyesinde değil (doğrulanmalı) |
| Xilem | 0.4.0 | Apache-2.0 | README kendisini "experimental" olarak tanımlıyor; Vello/wgpu tabanlı |
| Vizia | 0.4.0 | MIT | Skia (`skia-safe` 0.93) derleme yükü; bileşen kataloğu GPUI Kit kadar geniş değil (doğrulanmalı) |
| Freya | 0.5.0-rc.10 | MIT | RC aşamasında; Skia bağımlılığı |
| Dioxus / Blitz | 0.8.0-alpha.3 / 0.3.0-beta.4 | MIT OR Apache-2.0 | Alfa/beta; karmaşık masaüstü bileşenlerinde üretim için erken |

## Kurulum

Rust 1.92+ gerekir.

```toml
[dependencies]
gpui-kit = "0.8.0"
```

```rust
use gpui_kit::*;

struct Uygulama;

impl Render for Uygulama {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div().size_full().child("Merhaba")
    }
}

fn main() {
    application()
        .with_assets(assets::Assets)
        .run(|cx| {
            init(cx);
            open_window(WindowOptions::default(), cx, |_, cx| cx.new(|_| Uygulama))
                .expect("pencere açılamadı");
        });
}
```

## Sistem gereksinimleri

| Platform | Gereksinim |
| --- | --- |
| macOS 15+ | Xcode Command Line Tools (`xcode-select --install`). `gpui-kit` metin çizimi için gereken `font-kit` özelliğini kendisi açar |
| Ubuntu 24.04 (Wayland/X11) | `gcc g++ clang libfontconfig-dev libwayland-dev libwebkit2gtk-4.1-dev libxkbcommon-x11-dev libx11-xcb-dev libssl-dev libzstd-dev libasound2-dev vulkan-validationlayers libvulkan1` ve çalışan bir Vulkan sürücüsü |

`libwebkit2gtk-4.1-dev` yalnızca isteğe bağlı WebView bileşeni içindir; WebView'siz uygulamada gerekmez (kurulum listesi depo örneklerini de kapsar).

## Kart örneği (doğrulanmış API)

```rust
use gpui_kit::component::button::{Button, ButtonVariants as _};
use gpui_kit::component::label::Label;
use gpui_kit::component::{ActiveTheme as _, Icon, IconName, StyledExt as _, h_flex, v_flex};
use gpui_kit::*;

struct Panel;

impl Render for Panel {
    fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        let theme = cx.theme();

        v_flex()
            .size_full()
            .items_center()
            .justify_center()
            .bg(theme.background)
            .child(
                v_flex()
                    .w(px(380.))
                    .p_6()
                    .gap_4()
                    .bg(theme.popover)
                    .border_1()
                    .border_color(theme.border)
                    .rounded(px(12.))
                    .shadow_lg()
                    .child(
                        h_flex()
                            .items_center()
                            .justify_between()
                            .child(
                                h_flex()
                                    .items_center()
                                    .gap_3()
                                    .child(Icon::new(IconName::ChartPie).text_color(theme.primary))
                                    .child(Label::new("Sistem Performansı").text_lg()),
                            )
                            .child(Icon::new(IconName::Ellipsis).text_color(theme.muted_foreground)),
                    )
                    .child(
                        div()
                            .text_sm()
                            .text_color(theme.muted_foreground)
                            .child("macOS (Metal) ve Linux (Vulkan) üzerinde GPU hızlandırmalı arayüz."),
                    )
                    .child(
                        Button::new("analiz")
                            .primary()
                            .label("Analizi Görüntüle")
                            .icon(IconName::ArrowRight)
                            .w_full()
                            .on_click(|_, _, _| println!("Analiz açıldı")),
                    ),
            )
    }
}
```

- `cx.theme()` için `ActiveTheme`, `font_semibold` gibi yardımcılar için `StyledExt` kapsamda olmalı.
- `IconName` varsayılan ikon setidir; 1830 ikonluk tam katalog `gpui_kit::assets::IconName` altındadır.
- 0.8'de `theme.card` alanı yok: kart yüzeyi `theme.popover` (veya `theme.group_box`), kenarlık `theme.border`.

## CI (GitHub Actions, Linux + macOS)

```yaml
name: ci
on: [push, pull_request]

jobs:
  build:
    strategy:
      fail-fast: false
      matrix:
        os: [macos-latest, ubuntu-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - name: Linux sistem bağımlılıkları
        if: runner.os == 'Linux'
        run: |
          sudo apt-get update
          sudo apt-get install -y gcc g++ clang libfontconfig-dev libwayland-dev \
            libwebkit2gtk-4.1-dev libxkbcommon-x11-dev libx11-xcb-dev libssl-dev \
            libzstd-dev libasound2-dev vulkan-validationlayers libvulkan1
      - uses: actions-rust-lang/setup-rust-toolchain@v1
      - run: cargo build --release --locked
      - run: cargo test --locked
```

Paketleme (dmg / AppImage / deb) ayrı bir konudur: <https://gpui-kit.com/docs/packaging>

## Sınırlar (doğrulanmalı)

- Ekran okuyucu (VoiceOver/Orca) ve IME davranışı AccessKit/gpui-pre katmanında mevcut; uçtan uca kullanıcı testi şart.
- "120 FPS" bir hedeftir, garanti değil; ölçüm için gpui-kit FPS Monitor aracı kullanılmalı.
- macOS paket imzalama/notarization ve Linux dağıtım formatları bu belgenin kapsamı dışında.

## Kaynaklar

- crates.io: <https://crates.io/crates/gpui-kit> · <https://crates.io/crates/gpui-component> · <https://crates.io/crates/gpui-pre> · <https://crates.io/crates/gpui-webview>
- Belgeler: <https://gpui-kit.com/docs/getting-started> · <https://gpui-kit.com/docs/installation> · <https://gpui-kit.com/docs/comparison>
- Depo: <https://github.com/longbridge/gpui-kit>
- Slint Royalty-free 2.0 lisans metni: <https://github.com/slint-ui/slint/blob/master/LICENSES/LicenseRef-Slint-Royalty-free-2.0.md>
