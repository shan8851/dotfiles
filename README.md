# dotfiles

My personal dotfiles for Linux (Tuxedo OS / KDE Plasma).

This repo contains my core configuration files for my development environment.
Feel free to use as inspiration, but always check for secrets and edit for your own setup.

## Included Files

- `.zshrc` — Zsh shell configuration (Oh My Zsh + Powerlevel10k)
- `.p10k.zsh` — Powerlevel10k prompt config
- `.gitconfig` — Git configuration (with SSH signing)
- `kitty.conf` — Kitty terminal configuration (IBM Plex Mono, classic green theme)
- `.xbindkeysrc` — Mouse button shortcuts
- `autostart/keyboard-remap.desktop` — Swap Ctrl/Super for Mac-like shortcuts
- `vscode-settings.json` — VSCode user settings
- `CLAUDE.md` — Claude Code AI preferences and coding conventions

## Key Features

- **Mac-like keyboard shortcuts** via Ctrl↔Super swap
- **fzf** for fuzzy finding (Ctrl+R for history, Ctrl+T for files)
- **zoxide** for smart directory jumping (`z <partial>`)
- **lsd** aliased to `ls` for icons and colors
- **Classic green terminal** theme in Kitty (IBM Plex Mono font)

## Installation

```bash
# Clone the repo
git clone git@github.com:shan8851/dotfiles.git ~/shan/dotfiles

# Symlink configs (adjust paths as needed)
ln -sf ~/shan/dotfiles/.zshrc ~/.zshrc
ln -sf ~/shan/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/shan/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/shan/dotfiles/.xbindkeysrc ~/.xbindkeysrc
ln -sf ~/shan/dotfiles/kitty.conf ~/.config/kitty/kitty.conf
cp ~/shan/dotfiles/autostart/* ~/.config/autostart/
mkdir -p ~/.claude && ln -sf ~/shan/dotfiles/CLAUDE.md ~/.claude/CLAUDE.md
```

## Dependencies

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [fzf](https://github.com/junegunn/fzf)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [lsd](https://github.com/lsd-rs/lsd)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [xbindkeys](https://www.nongnu.org/xbindkeys/)
