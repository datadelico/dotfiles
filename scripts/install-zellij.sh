#!/usr/bin/env bash
# =============================================================================
# scripts/install-zellij.sh — Install Zellij terminal multiplexer
#
# Downloads the official binary from GitHub Releases and installs it to
# ~/.local/bin. Version is defined in config/versions.sh.
#
# Official releases: https://github.com/zellij-org/zellij/releases
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
source "${SCRIPT_DIR}/../config/versions.sh"

readonly BINARY="zellij"
readonly BASE_URL="https://github.com/zellij-org/zellij/releases/download/v${ZELLIJ_VERSION}"
readonly ASSET="zellij-x86_64-unknown-linux-musl.tar.gz"

# Check if already installed at the correct version
if command -v "${BINARY}" &>/dev/null; then
    installed="$(${BINARY} --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
    if [[ "${installed}" == "${ZELLIJ_VERSION}" ]]; then
        echo "    zellij ${ZELLIJ_VERSION} already installed."
        exit 0
    fi
    echo "    zellij ${installed} found, upgrading to ${ZELLIJ_VERSION}..."
fi

echo "    Installing zellij v${ZELLIJ_VERSION}..."

mkdir -p "${INSTALL_BIN_DIR}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

curl -fsSL "${BASE_URL}/${ASSET}" -o "${TMP_DIR}/${ASSET}"

tar xf "${TMP_DIR}/${ASSET}" -C "${TMP_DIR}"
install -m 0755 "${TMP_DIR}/${BINARY}" "${INSTALL_BIN_DIR}/${BINARY}"

echo "    zellij ${ZELLIJ_VERSION} installed to ${INSTALL_BIN_DIR}/${BINARY}."
