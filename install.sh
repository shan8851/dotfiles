#!/usr/bin/env bash
# Symlink dotfiles into place. Existing real files are moved to <file>.bak.
set -euo pipefail
DOTS="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$DOTS/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" && ! -L "$dest" ]]; then mv "$dest" "$dest.bak"; echo "backed up $dest"; fi
  ln -sfn "$src" "$dest"
  echo "linked $dest"
}

link zsh/.zshrc            ~/.zshrc
link git/.gitconfig        ~/.gitconfig
link starship/starship.toml ~/.config/starship.toml
link ghostty/config        ~/.config/ghostty/config
link mise/config.toml      ~/.config/mise/config.toml
link vscode/settings.json  ~/.config/Code/User/settings.json

# VS Code extensions
command -v code >/dev/null && xargs -n1 code --install-extension < "$DOTS/vscode/extensions.txt" >/dev/null && echo "vscode extensions installed"
