HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt share_history

setopt rm_star_silent
setopt NULL_GLOB

export PATH="$HOME/bin:$PATH"
export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER='nvim +Man!'

function zvm_config() {
    # Normal mode default for lines with zsh-vi-mode
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
    ZVM_SYSTEM_CLIPBOARD_ENABLED=true
    ZVM_CLIPBOARD_USE_OSC52=true
}
if [[ -f ~/.zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh ]]; then
    source ~/.zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh
elif [[ -f /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
fi

[[ -d /opt/nvim-linux-x86_64/bin ]] && export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# The following lines were added by compinstall
zstyle :compinstall filename '/home/kenneth/.zshrc'
autoload -Uz compinit && compinit

[[ -o interactive ]] && fastfetch

eval "$(starship init zsh)"
