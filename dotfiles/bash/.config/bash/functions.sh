# shellcheck shell=bash
# =============================================================================
# ~/.config/bash/functions.sh — Bash utility functions
#
# Sourced by ~/.bashrc.
# =============================================================================

# ---------------------------------------------------------------------------
# mkcd — create a directory and cd into it
# Usage: mkcd <dirname>
# ---------------------------------------------------------------------------
mkcd() {
    if [[ -z "${1}" ]]; then
        echo "Usage: mkcd <directory>" >&2
        return 1
    fi
    mkdir -p "${1}" && cd "${1}" || return 1
}

# ---------------------------------------------------------------------------
# extract — extract common archive formats automatically
# Usage: extract <file>
# ---------------------------------------------------------------------------
extract() {
    if [[ -z "${1}" ]]; then
        echo "Usage: extract <file>" >&2
        return 1
    fi
    if [[ ! -f "${1}" ]]; then
        echo "'${1}' is not a valid file." >&2
        return 1
    fi
    case "${1}" in
        *.tar.bz2) tar xjf "${1}" ;;
        *.tar.gz) tar xzf "${1}" ;;
        *.tar.xz) tar xJf "${1}" ;;
        *.tar.zst) tar --zstd -xf "${1}" ;;
        *.tar) tar xf "${1}" ;;
        *.bz2) bunzip2 "${1}" ;;
        *.gz) gunzip "${1}" ;;
        *.tbz2) tar xjf "${1}" ;;
        *.tgz) tar xzf "${1}" ;;
        *.zip) unzip "${1}" ;;
        *.Z) uncompress "${1}" ;;
        *.7z) 7z x "${1}" ;;
        *.xz) unxz "${1}" ;;
        *.zst) zstd -d "${1}" ;;
        *)
            echo "'${1}' cannot be extracted — unknown format." >&2
            return 1
            ;;
    esac
}

# ---------------------------------------------------------------------------
# up — navigate up N directory levels
# Usage: up [n]   (default: 1)
# ---------------------------------------------------------------------------
up() {
    local n="${1:-1}"
    local target=""
    for ((i = 0; i < n; i++)); do
        target="${target}../"
    done
    cd "${target}" || return 1
}

# ---------------------------------------------------------------------------
# fcd — fuzzy cd using fzf
# Usage: fcd [start_dir]
# ---------------------------------------------------------------------------
fcd() {
    if ! command -v fzf &>/dev/null; then
        echo "fzf is not installed." >&2
        return 1
    fi
    local dir
    dir="$(find "${1:-.}" -type d -not -path '*/.git/*' 2>/dev/null |
        fzf --prompt="cd > " --preview='ls -1 {}')"
    [[ -n "${dir}" ]] && cd "${dir}" || return 1
}

# ---------------------------------------------------------------------------
# fopen — open a file using fzf selection
# Usage: fopen [start_dir]
# ---------------------------------------------------------------------------
fopen() {
    if ! command -v fzf &>/dev/null; then
        echo "fzf is not installed." >&2
        return 1
    fi
    local file
    file="$(find "${1:-.}" -type f -not -path '*/.git/*' 2>/dev/null |
        fzf --prompt="open > " --preview='cat {}')"
    if [[ -n "${file}" ]]; then
        "${EDITOR:-nano}" "${file}"
    fi
}

# ---------------------------------------------------------------------------
# hist — fuzzy search command history with fzf
# Usage: hist
# ---------------------------------------------------------------------------
hist() {
    if ! command -v fzf &>/dev/null; then
        echo "fzf is not installed." >&2
        return 1
    fi
    local cmd
    cmd="$(history | sort -rn | awk '{$1=""; sub(/^ /, ""); print}' |
        awk '!seen[$0]++' |
        fzf --prompt="history > " --no-sort)"
    if [[ -n "${cmd}" ]]; then
        history -s "${cmd}"
        eval "${cmd}"
    fi
}

# ---------------------------------------------------------------------------
# mkenv — create a .env file with a template
# Usage: mkenv
# ---------------------------------------------------------------------------
mkenv() {
    if [[ -f ".env" ]]; then
        echo ".env already exists." >&2
        return 1
    fi
    cat >.env <<'EOF'
# Environment variables — do NOT commit this file
# APP_ENV=development
# APP_PORT=8080
# DATABASE_URL=
# SECRET_KEY=
EOF
    echo ".env created."
}

# ---------------------------------------------------------------------------
# sshkey — generate an Ed25519 SSH key
# Usage: sshkey <name> [comment]
# ---------------------------------------------------------------------------
sshkey() {
    if [[ -z "${1}" ]]; then
        echo "Usage: sshkey <name> [comment]" >&2
        return 1
    fi
    local keyfile="${HOME}/.ssh/${1}"
    local comment="${2:-${USER}@$(hostname)}"
    if [[ -f "${keyfile}" ]]; then
        echo "Key already exists: ${keyfile}" >&2
        return 1
    fi
    mkdir -p "${HOME}/.ssh"
    chmod 700 "${HOME}/.ssh"
    ssh-keygen -t ed25519 -C "${comment}" -f "${keyfile}"
    echo ""
    echo "Public key:"
    cat "${keyfile}.pub"
}

# ---------------------------------------------------------------------------
# denter — enter a running Docker container interactively
# Usage: denter [container_name_filter]
# ---------------------------------------------------------------------------
denter() {
    if ! command -v docker &>/dev/null; then
        echo "Docker is not installed." >&2
        return 1
    fi
    local container
    if [[ -n "${1:-}" ]]; then
        container="$(docker ps --format '{{.Names}}' | grep "${1}" | head -1)"
    else
        if command -v fzf &>/dev/null; then
            container="$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}' |
                fzf --prompt="container > " | awk '{print $1}')"
        else
            docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'
            echo "Usage: denter <container_name>" >&2
            return 1
        fi
    fi
    if [[ -z "${container}" ]]; then
        echo "No matching container found." >&2
        return 1
    fi
    docker exec -it "${container}" /bin/bash 2>/dev/null ||
        docker exec -it "${container}" /bin/sh
}

# ---------------------------------------------------------------------------
# confirm — prompt the user for a yes/no answer
# Usage: confirm "Are you sure?" && rm -rf ...
# ---------------------------------------------------------------------------
confirm() {
    local prompt="${1:-Are you sure?}"
    local reply
    read -r -p "${prompt} [y/N] " reply
    case "${reply}" in
        [Yy][Ee][Ss] | [Yy]) return 0 ;;
        *) return 1 ;;
    esac
}
