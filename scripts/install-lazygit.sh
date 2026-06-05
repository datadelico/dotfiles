#!/usr/bin/env bash
# =============================================================================
# scripts/install-lazygit.sh — Install lazygit
#
# Downloads the official binary from GitHub Releases and installs it to
# ~/.local/bin. Version is defined in config/versions.sh.
#
# Official releases: https://github.com/jesseduffield/lazygit/releases
# =============================================================================

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/versions.sh"

readonly BINARY="lazygit"
readonly BASE_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}"
readonly ASSET="lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

# Check if already installed at the correct version
if command -v "${BINARY}" &>/dev/null; then
    installed="$(${BINARY} --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
    if [[ "${installed}" == "${LAZYGIT_VERSION}" ]]; then
        echo "    lazygit ${LAZYGIT_VERSION} already installed."
        exit 0
    fi
    echo "    lazygit ${installed} found, upgrading to ${LAZYGIT_VERSION}..."
fi

echo "    Installing lazygit v${LAZYGIT_VERSION}..."

mkdir -p "${INSTALL_BIN_DIR}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

curl -fsSL "${BASE_URL}/${ASSET}" -o "${TMP_DIR}/${ASSET}"

tar xf "${TMP_DIR}/${ASSET}" -C "${TMP_DIR}"
install -m 0755 "${TMP_DIR}/${BINARY}" "${INSTALL_BIN_DIR}/${BINARY}"

echo "    lazygit ${LAZYGIT_VERSION} installed to ${INSTALL_BIN_DIR}/${BINARY}."
