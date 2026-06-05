#!/usr/bin/env bash
# =============================================================================
# scripts/install-starship.sh — Install Starship prompt
#
# Downloads the official binary from GitHub Releases, verifies the SHA-256
# checksum, and installs it to ~/.local/bin.
#
# Security: binary is verified against the published .sha256 sidecar file
# before installation. No shell piping of remote scripts.
#
# Official releases: https://github.com/starship/starship/releases
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
source "${SCRIPT_DIR}/../config/versions.sh"

readonly BINARY="starship"
readonly BASE_URL="https://github.com/starship/starship/releases/download/v${STARSHIP_VERSION}"
readonly ASSET="starship-x86_64-unknown-linux-musl.tar.gz"
readonly CHECKSUM_FILE="${ASSET}.sha256"

# Check if already installed at the correct version
if command -v "${BINARY}" &>/dev/null; then
    installed="$(${BINARY} --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
    if [[ "${installed}" == "${STARSHIP_VERSION}" ]]; then
        echo "    starship ${STARSHIP_VERSION} already installed."
        exit 0
    fi
    echo "    starship ${installed} found, upgrading to ${STARSHIP_VERSION}..."
fi

echo "    Installing starship v${STARSHIP_VERSION}..."

mkdir -p "${INSTALL_BIN_DIR}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

curl -fsSL "${BASE_URL}/${ASSET}" -o "${TMP_DIR}/${ASSET}"
curl -fsSL "${BASE_URL}/${CHECKSUM_FILE}" -o "${TMP_DIR}/${CHECKSUM_FILE}"

echo "    Verifying SHA-256 checksum..."
expected_hash="$(tr -d '[:space:]' <"${TMP_DIR}/${CHECKSUM_FILE}")"
actual_hash="$(sha256sum "${TMP_DIR}/${ASSET}" | awk '{print $1}')"
if [[ "${expected_hash}" != "${actual_hash}" ]]; then
    echo "ERROR: SHA-256 checksum mismatch for ${ASSET}" >&2
    echo "  Expected: ${expected_hash}" >&2
    echo "  Actual:   ${actual_hash}" >&2
    exit 1
fi
echo "    Checksum verified."

tar xf "${TMP_DIR}/${ASSET}" -C "${TMP_DIR}"
install -m 0755 "${TMP_DIR}/${BINARY}" "${INSTALL_BIN_DIR}/${BINARY}"

echo "    starship ${STARSHIP_VERSION} installed to ${INSTALL_BIN_DIR}/${BINARY}."
