# dotfiles

Linux (TUXEDO OS / KDE Plasma, Wayland) dev setup. Configs are plain files symlinked into place by `install.sh`.

| Path | Goes to | What |
| --- | --- | --- |
| `zsh/.zshrc` | `~/.zshrc` | zsh with no framework. Plugins clone themselves on first run |
| `starship/starship.toml` | `~/.config/starship.toml` | Two-line prompt, Catppuccin Mocha |
| `ghostty/config` | `~/.config/ghostty/config` | Ghostty terminal, plus a drop-down terminal on Ctrl+` |
| `git/.gitconfig` | `~/.gitconfig` | Aliases, delta for diffs |
| `mise/config.toml` | `~/.config/mise/config.toml` | Global tool versions: Node LTS, pnpm |
| `bat/` | `~/.config/bat/` | bat config and Catppuccin theme (delta uses it too) |
| `btop/` | `~/.config/btop/` | btop with Catppuccin, transparent background |
| `plasma/apply.sh` | (run it) | KDE desktop theme, see below |
| `vscode/settings.json` | `~/.config/Code/User/settings.json` | VS Code: JetBrains Mono, Catppuccin Mocha |
| `vscode/extensions.txt` | (installed by `install.sh`) | VS Code extensions |

## Shell
- **Plugins:** fzf-tab (fuzzy Tab completion), zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions. They live in `~/.local/share/zsh/plugins`. Update them with `plugs_update`.
- **History:** atuin on Ctrl-R. Up arrow stays as normal history.
- **fzf:** Ctrl-T finds files, Alt-C jumps to a directory.
- **zoxide:** `z <partial>` jumps to a directory you've visited.
- **Node/pnpm:** via [mise](https://mise.jdx.dev). Global versions live in `mise/config.toml`. In a project, `mise use node@22` writes a `mise.toml`, and mise also reads `.nvmrc`.
- Machine-specific or secret settings go in `~/.zshrc.local`, which is not tracked.

## Desktop (KDE Plasma 6)
`plasma/apply.sh` sets up the desktop. Everything installs per-user, so it needs no sudo and is safe to rerun:
- Catppuccin Mocha colour scheme with a Lavender accent. Change `FLAVOUR` and `ACCENT` at the top of the script.
- Inter for the interface, JetBrains Mono Nerd Font for fixed-width text
- Papirus-Dark icons with Catppuccin folders, and the Catppuccin cursor
- Catppuccin splash screen, and the same wallpaper on every screen and the lock screen
- KWin: blur on, animations at half length, Night Light on
- Panel: 40px, with the pager and show-desktop button removed
- Login starts an empty session, and clipboard history keeps 100 items
- Hides unused startup items (xbindkeys, Spice vdagent, KDE Connect, Kup) and removes broken autostart links

KDE's own config files aren't tracked, because they change constantly. The script is the record of what's set.

## Tips
- Ghostty has no title bar. Hold Meta and drag to move a window, or Meta + right-drag to resize.

## Install

```bash
# apt packages (Ghostty from the community PPA)
sudo add-apt-repository -y ppa:mkasberg/ghostty-ubuntu
sudo apt update && sudo apt install -y zsh ghostty eza bat fd-find git-delta btop zoxide

# Font: JetBrains Mono Nerd Font (nerd-fonts release JetBrainsMono.tar.xz) into ~/.local/share/fonts, then fc-cache -f

# Not packaged, or too old in Ubuntu 24.04: grab the release binaries into ~/.local/bin
#   starship, atuin, fzf (needs >= 0.48 for `fzf --zsh`), lazygit, mise
# e.g. gh release download -R starship/starship -p 'starship-x86_64-unknown-linux-musl.tar.gz'

git clone git@github.com:shan8851/dotfiles.git ~/shan/dotfiles
~/shan/dotfiles/install.sh
~/shan/dotfiles/plasma/apply.sh
mise install                  # Node + pnpm from mise/config.toml
chsh -s "$(command -v zsh)"   # then log out and back in
```
