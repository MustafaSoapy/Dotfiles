#Commands to do at the start of any terminal 
export SUDO_EDITOR=nvim

# Word-jumping with Ctrl + Arrow keys
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word


# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Aliases
alias ls='ls --color=auto'
alias n='nvim'
alias cc='clear'
alias se='sudoedit'
alias la='ls --all --color=auto'
# Completion
autoload -Uz compinit && compinit

# Optional: syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null


# Prompt using starship (if installed)
eval "$(starship init zsh)"


setopt autocd       # just type folder name to cd
setopt correct      # autocorrect small typos
setopt no_beep      # disable terminal beep
