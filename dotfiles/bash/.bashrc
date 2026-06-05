# =============================================================================
# ~/.bashrc — Interactive shell configuration
#
# Managed by GNU Stow (dotfiles/bash/). Sources modular configuration files
# from ~/.config/bash/:
#   aliases.sh    — command aliases
#   functions.sh  — Bash functions
#   completions.sh — extra completions
#
# Tool initializations (starship, fzf, zoxide) are at the bottom.
# =============================================================================

# Return early for non-interactive shells
case "$-" in
    *i*) ;;
    *) return ;;
esac

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTCONTROL=ignoreboth    # ignore duplicates and lines starting with space
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend       # append to history file, don't overwrite
shopt -s cmdhist          # save multi-line commands as one entry

# ---------------------------------------------------------------------------
# Shell options
# ---------------------------------------------------------------------------
shopt -s checkwinsize     # update LINES and COLUMNS after each command
shopt -s globstar         # enable ** glob pattern
shopt -s autocd           # cd by typing a directory name

# ---------------------------------------------------------------------------
# XDG Base Directory
# ---------------------------------------------------------------------------
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.cache"

# ---------------------------------------------------------------------------
# PATH — ensure ~/.local/bin is always present
# ---------------------------------------------------------------------------
if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
    export PATH="${HOME}/.local/bin:${PATH}"
fi

# ---------------------------------------------------------------------------
# Locale
# ---------------------------------------------------------------------------
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# ---------------------------------------------------------------------------
# Default editor
# ---------------------------------------------------------------------------
if command -v codium &>/dev/null; then
    export EDITOR="codium --wait"
    export VISUAL="codium --wait"
elif command -v nano &>/dev/null; then
    export EDITOR="nano"
    export VISUAL="nano"
fi

# ---------------------------------------------------------------------------
# bat configuration (Debian binary is 'batcat')
# ---------------------------------------------------------------------------
if command -v batcat &>/dev/null; then
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
    export BAT_THEME="Dracula"
fi

# ---------------------------------------------------------------------------
# ripgrep configuration
# ---------------------------------------------------------------------------
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/config"

# ---------------------------------------------------------------------------
# Load modular configuration
# ---------------------------------------------------------------------------
_load_config() {
    local file="${XDG_CONFIG_HOME}/bash/${1}"
    if [[ -f "${file}" ]]; then
        # shellcheck source=/dev/null
        source "${file}"
    fi
}

_load_config "aliases.sh"
_load_config "functions.sh"
_load_config "completions.sh"

# ---------------------------------------------------------------------------
# bash-completion (Debian package)
# ---------------------------------------------------------------------------
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    # shellcheck source=/dev/null
    source /usr/share/bash-completion/bash_completion
fi

# ---------------------------------------------------------------------------
# fzf — fuzzy finder
# ---------------------------------------------------------------------------
# fzf installed via apt on Debian trixie provides these completion scripts
if [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]]; then
    # shellcheck source=/dev/null
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi
if [[ -f /usr/share/doc/fzf/examples/completion.bash ]]; then
    # shellcheck source=/dev/null
    source /usr/share/doc/fzf/examples/completion.bash
fi
# Newer fzf versions also support: eval "$(fzf --bash)"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

# ---------------------------------------------------------------------------
# zoxide — smarter cd
# ---------------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
fi

# ---------------------------------------------------------------------------
# Starship prompt — must be last
# ---------------------------------------------------------------------------
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi
