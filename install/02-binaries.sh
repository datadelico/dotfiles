#!/usr/bin/env bash
# =============================================================================
# install/02-binaries.sh — Install external tool binaries
#
# Calls individual installer scripts for tools not available in Debian repos.
# Each installer is idempotent (skips if already at the correct version).
# =============================================================================

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "==> [02-binaries] Installing external binaries..."

run_installer() {
    local script="${REPO_ROOT}/scripts/${1}"
    if [[ ! -f "${script}" ]]; then
        echo "ERROR: Installer not found: ${script}" >&2
        exit 1
    fi
    bash "${script}"
}

run_installer "install-starship.sh"
run_installer "install-lazygit.sh"
run_installer "install-lazydocker.sh"
run_installer "install-zellij.sh"

echo "==> [02-binaries] Done."
