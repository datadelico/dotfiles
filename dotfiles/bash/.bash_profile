# =============================================================================
# ~/.bash_profile — Login shell configuration
#
# Sourced by Bash for login shells. Loads .bashrc and ensures ~/.local/bin
# is in PATH. This file is managed by GNU Stow (dotfiles/bash/).
# =============================================================================

# Include user private bin first
if [[ -d "${HOME}/.local/bin" ]]; then
    PATH="${HOME}/.local/bin:${PATH}"
    export PATH
fi

# Set DOCKER_HOST for rootless Docker if the socket exists
_docker_sock="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/docker.sock"
if [[ -S "${_docker_sock}" ]]; then
    export DOCKER_HOST="unix://${_docker_sock}"
fi
unset _docker_sock

# Source .bashrc for interactive login shells
if [[ -f "${HOME}/.bashrc" ]]; then
    # shellcheck source=/dev/null
    source "${HOME}/.bashrc"
fi
