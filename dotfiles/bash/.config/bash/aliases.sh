# =============================================================================
# ~/.config/bash/aliases.sh — Command aliases
#
# Sourced by ~/.bashrc. All aliases check for binary existence before being
# defined, so the file is safe to source on any system.
# =============================================================================

# ---------------------------------------------------------------------------
# Debian-specific binary name normalization
# ---------------------------------------------------------------------------

# bat: Debian package 'bat' installs the binary as 'batcat'
if command -v batcat &>/dev/null; then
    alias bat='batcat'
fi

# fd: Debian package 'fd-find' installs the binary as 'fdfind'
if command -v fdfind &>/dev/null; then
    alias fd='fdfind'
fi

# ---------------------------------------------------------------------------
# ls / directory listing — eza as modern ls replacement
# ---------------------------------------------------------------------------
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza --icons --group-directories-first -lh'
    alias la='eza --icons --group-directories-first -lha'
    alias lt='eza --icons --tree --level=2'
    alias lta='eza --icons --tree --level=2 --all'
    alias l='eza --icons --group-directories-first -1'
else
    alias ls='ls --color=auto'
    alias ll='ls -lh'
    alias la='ls -lha'
fi

# ---------------------------------------------------------------------------
# Navigation
# ---------------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# ---------------------------------------------------------------------------
# Safety guards
# ---------------------------------------------------------------------------
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ln='ln -i'

# ---------------------------------------------------------------------------
# grep — always use color
# ---------------------------------------------------------------------------
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ---------------------------------------------------------------------------
# ripgrep
# ---------------------------------------------------------------------------
if command -v rg &>/dev/null; then
    alias rg='rg --smart-case'
fi

# ---------------------------------------------------------------------------
# Git shortcuts
# ---------------------------------------------------------------------------
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch --all --prune'
alias glog='git log --oneline --graph --decorate --all'
alias gdiff='git diff'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gbr='git branch -vv'

# ---------------------------------------------------------------------------
# lazygit / lazydocker
# ---------------------------------------------------------------------------
if command -v lazygit &>/dev/null; then
    alias lg='lazygit'
fi

if command -v lazydocker &>/dev/null; then
    alias lzd='lazydocker'
fi

# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dimg='docker images'
alias dprune='docker system prune -f'

# ---------------------------------------------------------------------------
# System information
# ---------------------------------------------------------------------------
alias df='df -h'
alias du='du -sh'
alias free='free -h'
alias psg='ps aux | grep -v grep | grep'

# ---------------------------------------------------------------------------
# Network
# ---------------------------------------------------------------------------
alias myip='curl -fsSL https://api.ipify.org && echo'
alias localip="ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '^127'"
alias ports='ss -tulanp'

# ---------------------------------------------------------------------------
# Editors
# ---------------------------------------------------------------------------
alias v='${EDITOR:-nano}'
alias vi='${EDITOR:-nano}'

# ---------------------------------------------------------------------------
# Miscellaneous
# ---------------------------------------------------------------------------
alias cls='clear'
alias reload='source ~/.bashrc && echo "~/.bashrc reloaded."'
alias path='echo -e "${PATH//:/\\n}"'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'

# Human-readable sizes in various tools
alias du1='du -h --max-depth=1 | sort -rh'
