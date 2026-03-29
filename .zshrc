# History settings
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt rm_star_silent

# Vim keybindings
bindkey -v
bindkey -v '^?' backward-delete-char
# Eliminate delay after ESC press
KEYTIMEOUT=1

# Environment variables
export PATH="$HOME/bin:$PATH"
export EDITOR='nvim'

# Aliases
alias vim='nvim'

# Normal mode default for lines with zsh-vi-mode
function zvm_config() {
    ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
}

# zsh vi mode (installed with git)
[[ -f $HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh ]] && source $HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh

# fzf configuration
zvm_after_init_commands+=('[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh')
zvm_after_init_commands+=('[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh')
zvm_after_init_commands+=('[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh')

# Source Cargo environment (Rust's pacman and build system)
[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

# Zsh completion (with caching)
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Welcome message (only in interactive shells)
if [[ -o interactive ]]; then
    fastfetch
fi

# Starship prompt
eval "$(starship init zsh)"

# Zoxide setup
eval "$(zoxide init --cmd cd zsh)"

# Source plugins, syntax highlighting must be at end of .zshrc
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

