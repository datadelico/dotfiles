#!/usr/bin/env bash
# =============================================================================
# scripts/install-lazydocker.sh — Install lazydocker
#
# Downloads the official binary from GitHub Releases and installs it to
# ~/.local/bin. Version is defined in config/versions.sh.
#
# Official releases: https://github.com/jesseduffield/lazydocker/releases
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
source "${SCRIPT_DIR}/../config/versions.sh"

readonly BINARY="lazydocker"
readonly BASE_URL="https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}"
readonly ASSET="lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"

# Check if already installed at the correct version
if command -v "${BINARY}" &>/dev/null; then
    installed="$(${BINARY} --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
    if [[ "${installed}" == "${LAZYDOCKER_VERSION}" ]]; then
        echo "    lazydocker ${LAZYDOCKER_VERSION} already installed."
        exit 0
    fi
    echo "    lazydocker ${installed} found, upgrading to ${LAZYDOCKER_VERSION}..."
fi

echo "    Installing lazydocker v${LAZYDOCKER_VERSION}..."

mkdir -p "${INSTALL_BIN_DIR}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

curl -fsSL "${BASE_URL}/${ASSET}" -o "${TMP_DIR}/${ASSET}"

tar xf "${TMP_DIR}/${ASSET}" -C "${TMP_DIR}"
install -m 0755 "${TMP_DIR}/${BINARY}" "${INSTALL_BIN_DIR}/${BINARY}"

echo "    lazydocker ${LAZYDOCKER_VERSION} installed to ${INSTALL_BIN_DIR}/${BINARY}."
