#Commands to do at the start of any terminal 
export SUDO_EDITOR=nvim

# Use Bash-like word movement
autoload -U select-word-style
select-word-style bash

# Ctrl+Left / Ctrl+Right word jump
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word


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

# play (song name) searches and plys in mpv gui (needs mpv and yt-dlp)
play() {
  yt-dlp --default-search "ytsearch" -f ba -g "$1" | xargs mpv --player-operation-mode=pseudo-gui
}

