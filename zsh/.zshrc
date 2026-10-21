# ~/.zshrc: no framework. Plugins clone themselves on first run.

# --- PATH ---------------------------------------------------------------
typeset -U path
# pnpm global installs (pnpm i -g): same folder `pnpm setup` adds in .bashrc.
export PNPM_HOME=~/.local/share/pnpm
path=(~/.local/bin $PNPM_HOME/bin $path)

# --- History ------------------------------------------------------------
# atuin handles search (Ctrl-R); this file is the plain fallback.
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history hist_ignore_all_dups hist_ignore_space extended_history

setopt auto_cd interactive_comments no_beep

# --- Plugins ------------------------------------------------------------
ZPLUGDIR=${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins
plug_get() { [[ -d $ZPLUGDIR/${1:t} ]] || git clone -q --depth 1 https://github.com/$1 $ZPLUGDIR/${1:t} }
plug() { plug_get $1 && source $ZPLUGDIR/${1:t}/${1:t}.plugin.zsh }
plugs_update() { for d in $ZPLUGDIR/*(/); do git -C $d pull -q --ff-only && echo "updated ${d:t}"; done }

plug_get zsh-users/zsh-completions
fpath=($ZPLUGDIR/zsh-completions/src $fpath)

# --- Completion ---------------------------------------------------------
mkdir -p ${XDG_CACHE_HOME:-$HOME/.cache}/zsh
autoload -Uz compinit && compinit -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no                           # fzf-tab takes over
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'

# Catppuccin Mocha for fzf (and fzf-tab); bg:-1 keeps the terminal's own background
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:-1,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A,border:#6C7086,label:#CDD6F4"
# Order matters: fzf before fzf-tab (so fzf-tab owns Tab), syntax highlighting last.
(( $+commands[fzf] ))      && source <(fzf --zsh)               # Ctrl-T files, Alt-C dirs
plug Aloxaf/fzf-tab
plug zsh-users/zsh-autosuggestions
plug zsh-users/zsh-syntax-highlighting

# --- Tools --------------------------------------------------------------
(( $+commands[atuin] ))    && eval "$(atuin init zsh --disable-up-arrow)"  # Ctrl-R (after fzf so it wins)
(( $+commands[zoxide] ))   && eval "$(zoxide init zsh)"         # z <partial>
(( $+commands[mise] ))     && eval "$(mise activate zsh)"           # node, pnpm etc. per project
(( $+commands[starship] )) && eval "$(starship init zsh)"

# --- Aliases ------------------------------------------------------------
# Ubuntu renames these two
(( $+commands[batcat] )) && alias bat=batcat
(( $+commands[fdfind] )) && alias fd=fdfind

if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first --icons=auto'
  alias ll='ls -l --git'
  alias la='ls -la --git'
  alias lt='eza --tree --level=2 --icons=auto'
fi

alias g=git
alias gs='git status -sb'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gsw='git switch'
alias gp='git push'
alias gl='git pull'
alias glog='git lg'
alias lg=lazygit

alias dots='cd ~/shan/dotfiles'
alias zshrc='${EDITOR:-code} ~/.zshrc'
alias reload='exec zsh'
alias myip="hostname -I | awk '{print \$1}'"
alias update='sudo apt update && sudo apt upgrade -y && flatpak update -y'

# --- Poker VM (Windows 11 under KVM, see ~/vms/README.md) ----------------
export LIBVIRT_DEFAULT_URI=qemu:///system   # virsh/virt-viewer use the system VMs
poker-up() {
  [[ $(virsh domstate win11-poker) == running ]] || virsh start win11-poker >/dev/null
  virt-viewer --wait --reconnect win11-poker &>/dev/null &!
}
poker-down() { virsh shutdown win11-poker >/dev/null && echo "Shutting down win11-poker" }

# Machine-specific or secret bits live outside the repo
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
