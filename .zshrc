HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt share_history

setopt rm_star_silent
setopt NULL_GLOB

export PATH="$HOME/bin:$PATH"
export EDITOR='nvim'
export VISUAL='nvim'

if [[ -f ~/.zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh ]]; then
    # Normal mode default for lines with zsh-vi-mode
    function zvm_config() {
        ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    }
    source ~/.zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh
fi

zvm_after_init_commands+=('source <(fzf --zsh)')

[[ -d /opt/nvim-linux-x86_64/bin ]] && export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

# Zsh completion (with caching)
zstyle :compinstall filename '/home/kenneth/.zshrc'
autoload -Uz compinit && compinit

[[ -o interactive ]] && fastfetch

eval "$(starship init zsh)"
