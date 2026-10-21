#!/usr/bin/env bash
# Highlight text anywhere, press Meta+Ctrl+Space, hear it read aloud (Speech Note, offline).
# Needs install.sh first (links bin/read-selection) and wl-clipboard. Safe to rerun.
set -euo pipefail
APP=net.mkiol.SpeechNote
KEY=335544352   # Meta+Ctrl+Space as a Qt key code (Meta 0x10000000 | Ctrl 0x04000000 | Space 0x20)
DESKTOP=net.local.read-selection.desktop

flatpak info "$APP" >/dev/null 2>&1 || flatpak install -y flathub "$APP"

# Start at login: actions only work while the app is running
mkdir -p ~/.config/autostart
cp "/var/lib/flatpak/exports/share/applications/$APP.desktop" ~/.config/autostart/
echo "autostart on"

# Let read-selection send it commands. The app rewrites this file on exit, so only touch it while closed.
conf=~/.var/app/$APP/config/net.mkiol/dsnote/settings.conf
if flatpak ps --columns=application | grep -qx "$APP"; then
  echo "Speech Note is running: tick 'Allow external applications to invoke actions' in its settings yourself"
else
  mkdir -p "$(dirname "$conf")"
  kwriteconfig6 --file "$conf" --group General --key actions_api_enabled true
  echo "external actions enabled"
fi

# Menu entry for the shortcut. Absolute path because KDE's session PATH has no ~/.local/bin.
cat > ~/.local/share/applications/$DESKTOP <<EOF
[Desktop Entry]
Type=Application
Name=Read selection aloud
Exec=$HOME/.local/bin/read-selection
NoDisplay=true
X-KDE-GlobalAccel-CommandShortcut=true
EOF
kbuildsycoca6 >/dev/null 2>&1

# Register with KWin's live shortcut service. Writing kglobalshortcutsrc directly gets overwritten.
# Flags 6 = SetPresent | NoAutoloading: without SetPresent the key is saved but never grabbed.
id="['$DESKTOP','_launch','Read selection aloud','Read selection aloud']"
call() { gdbus call --session --dest org.kde.kglobalaccel --object-path /kglobalaccel --method "org.kde.KGlobalAccel.$1" "${@:2}" >/dev/null; }
call doRegister "$id"
call setShortcut "$id" "[$KEY]" 6
echo "Meta+Ctrl+Space bound"

echo "Left to do by hand: in Speech Note, Languages > English, download a voice (Kokoro 'Heart' is the pick)."
