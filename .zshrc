if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode auto      # update automatically without asking

zstyle ':omz:update' frequency 13

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
  git
  zsh-completions
  zsh-autosuggestions
  autojump
  zsh-syntax-highlighting
)
setopt correct
setopt share_history
autoload -Uz compinit && compinit

source $ZSH/oh-my-zsh.sh

# LSD override ls
alias ls='lsd --group-dirs first --icon=always --classify --color always'
alias ll='ls -l'
alias la='ls -la'

# Navigate to nika mono directory
alias nika="cd ~/shan/nika/nika-mono"

#upgrade
alias upgrade="sudo apt update && sudo apt upgrade -y"

# Kitty
alias kittyconf="code ~/.config/kitty/kitty.conf"

alias clock="tty-clock -s -c -C 6"


# get machine's ip address
alias ip="hostname -I | awk '{print $1}'"
# edit global zsh configuration
alias zshconfig="vim ~/.zshrc"
# reload zsh configuration
alias zshsource="source ~/.zshrc"
# reload zsh configuration
alias ohmyzsh="cd ~/.oh-my-zsh"
# navigate to global ssh directory
alias sshhome="cd ~/.ssh"
# edit global ssh configuration
alias sshconfig="vim ~/.ssh/config"
# edit global git configuration
alias gitconfig="vim ~/.gitconfig"
# update system
alias update="sudo apt update && sudo apt upgrade -y"
# bat
alias bat="batcat"

:r $VIMRUNTIME/vimrc_example.vim

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load nvm bash_completion
export PATH=$HOME/.local/bin:$PATH

# bun completions
[ -s "/home/shan/.bun/_bun" ] && source "/home/shan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# cargo
export PATH="$HOME/.cargo/bin:$PATH"
