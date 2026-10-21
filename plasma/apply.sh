#!/usr/bin/env bash
# Catppuccin desktop for KDE Plasma 6. Everything installs per-user (no sudo).
# Safe to rerun: downloads are cached and settings are just rewritten.
set -euo pipefail

FLAVOUR=Mocha          # Latte, Frappe, Macchiato, Mocha
ACCENT=Lavender        # Blue, Mauve, Pink, Peach, Green, ...
WALLPAPER=landscapes/shaded_landscape.png   # path in zhichaoh/catppuccin-wallpapers
INTER_VERSION=4.1
PAPIRUS_VERSION=20260801

flavour=${FLAVOUR,,} accent=${ACCENT,,}
CACHE=${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles-plasma
DATA=${XDG_DATA_HOME:-$HOME/.local/share}
ICONS=$DATA/icons
mkdir -p "$CACHE" "$ICONS" "$DATA/fonts" "$DATA/color-schemes" "$DATA/wallpapers" "$DATA/plasma/look-and-feel"

get() { # url -> cached file path
  local out="$CACHE/$(basename "$1")"
  [[ -s $out ]] || curl -fsSL -o "$out" "$1"
  echo "$out"
}
kw() { kwriteconfig6 "$@"; }
step() { printf '\n==> %s\n' "$*"; }

step "Colour scheme: Catppuccin $FLAVOUR $ACCENT"
f=$(get "https://github.com/catppuccin/kde/releases/latest/download/$FLAVOUR-color-schemes.tar.gz")
tar -xzf "$f" -C "$DATA/color-schemes" --strip-components=1 "$FLAVOUR-color-schemes/Catppuccin$FLAVOUR$ACCENT.colors"
plasma-apply-colorscheme "Catppuccin$FLAVOUR$ACCENT"

step "Fonts: Inter (UI), JetBrains Mono Nerd Font (fixed width)"
if ! fc-list | grep -q InterVariable; then
  f=$(get "https://github.com/rsms/inter/releases/download/v$INTER_VERSION/Inter-$INTER_VERSION.zip")
  mkdir -p "$DATA/fonts/Inter" && unzip -oqj "$f" 'InterVariable*.ttf' -d "$DATA/fonts/Inter"
fi
if ! fc-list | grep -q "JetBrainsMono Nerd Font"; then
  f=$(get "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz")
  mkdir -p "$DATA/fonts/JetBrainsMonoNerdFont" && tar -xJf "$f" -C "$DATA/fonts/JetBrainsMonoNerdFont" --wildcards '*.ttf'
fi
fc-cache -f "$DATA/fonts" >/dev/null
ui="Inter,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kw --file kdeglobals --group General --key font "$ui"
kw --file kdeglobals --group General --key menuFont "$ui"
kw --file kdeglobals --group General --key toolBarFont "$ui"
kw --file kdeglobals --group General --key smallestReadableFont "Inter,8,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kw --file kdeglobals --group General --key fixed "JetBrainsMono Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
kw --file kdeglobals --group WM --key activeFont "Inter,10,-1,5,600,0,0,0,0,0,0,0,0,0,0,1"

step "Icons: Papirus-Dark with Catppuccin $accent folders"
if [[ ! -d $ICONS/Papirus-Dark ]]; then
  f=$(get "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/refs/tags/$PAPIRUS_VERSION.tar.gz")
  tar -xzf "$f" -C "$ICONS" --strip-components=1 \
    "papirus-icon-theme-$PAPIRUS_VERSION/Papirus" "papirus-icon-theme-$PAPIRUS_VERSION/Papirus-Dark"
fi
if [[ ! -d $CACHE/catppuccin-papirus-folders ]]; then
  git clone -q --depth 1 https://github.com/catppuccin/papirus-folders "$CACHE/catppuccin-papirus-folders"
fi
cp -r "$CACHE/catppuccin-papirus-folders/src/." "$ICONS/Papirus/"
pf=$(get https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders)
bash "$pf" -C "cat-$flavour-$accent" --theme Papirus-Dark >/dev/null
/usr/lib/x86_64-linux-gnu/libexec/plasma-changeicons Papirus-Dark 2>/dev/null \
  || kw --file kdeglobals --group Icons --key Theme Papirus-Dark

step "Cursor: Catppuccin $FLAVOUR $ACCENT"
cursor="catppuccin-$flavour-$accent-cursors"
if [[ ! -d $ICONS/$cursor ]]; then
  f=$(get "https://github.com/catppuccin/cursors/releases/latest/download/$cursor.zip")
  unzip -oq "$f" -d "$ICONS"
fi
XCURSOR_PATH="$ICONS:$HOME/.icons:/usr/share/icons" plasma-apply-cursortheme "$cursor"

step "Splash screen"
f=$(get "https://github.com/catppuccin/kde/releases/latest/download/Catppuccin-$FLAVOUR-Splash.tar.gz")
tar -xzf "$f" -C "$DATA/plasma/look-and-feel"
kw --file ksplashrc --group KSplash --key Theme "Catppuccin-$FLAVOUR-Splash"
kw --file ksplashrc --group KSplash --key Engine KSplashQML

step "Wallpaper (desktop + lock screen)"
wp="$DATA/wallpapers/$(basename "$WALLPAPER")"
[[ -s $wp ]] || curl -fsSL -o "$wp" "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/$WALLPAPER"
qdbus6 org.kde.plasmashell /PlasmaShell evaluateScript "
  desktops().forEach(function (d) {
    d.wallpaperPlugin = 'org.kde.image';
    d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
    d.writeConfig('Image', 'file://$wp');
  });"
kw --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file://$wp"

step "KWin: blur, quicker animations, Night Light"
kw --file kwinrc --group Plugins --key blurEnabled true
kw --file kdeglobals --group KDE --key AnimationDurationFactor 0.5
kw --file kwinrc --group NightColor --key Active true
qdbus6 org.kde.KWin /KWin reconfigure

step "Panel: slimmer, no desktop pager or show-desktop button"
qdbus6 org.kde.plasmashell /PlasmaShell evaluateScript '
  panels().forEach(function (p) {
    p.height = 40;
    p.widgets().forEach(function (w) {
      if (w.type == "org.kde.plasma.pager" || w.type == "org.kde.plasma.showdesktop") w.remove();
    });
  });'

step "Done. Fonts and cursor fully apply to already-open apps after they restart (or log out and in)."
