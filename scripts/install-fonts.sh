#!/usr/bin/env bash
# =============================================================================
# scripts/install-fonts.sh — Install HackGen Nerd Font
#
# Downloads HackGen NF from GitHub Releases, extracts the font files, and
# installs them into ~/.local/share/fonts/ for the current user.
#
# Font family name (since v2.7.0): "HackGen Console NF", "HackGen NF"
# Official releases: https://github.com/yuru7/HackGen/releases
# =============================================================================

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../config/versions.sh"

readonly BASE_URL="https://github.com/yuru7/HackGen/releases/download/v${HACKGEN_VERSION}"
readonly ASSET="HackGen_NF_v${HACKGEN_VERSION}.zip"
readonly FONT_FAMILY_DIR="${INSTALL_FONTS_DIR}/HackGenNF"

# Check if already installed by looking for the font directory
if [[ -d "${FONT_FAMILY_DIR}" ]]; then
    echo "    HackGen Nerd Font already installed at ${FONT_FAMILY_DIR}."
    exit 0
fi

echo "    Installing HackGen Nerd Font v${HACKGEN_VERSION}..."

mkdir -p "${INSTALL_FONTS_DIR}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

curl -fsSL "${BASE_URL}/${ASSET}" -o "${TMP_DIR}/${ASSET}"

echo "    Extracting font archive..."
unzip -q "${TMP_DIR}/${ASSET}" -d "${TMP_DIR}/fonts"

# Move font files to user fonts directory
mkdir -p "${FONT_FAMILY_DIR}"
find "${TMP_DIR}/fonts" -name "*.ttf" -exec cp {} "${FONT_FAMILY_DIR}/" \;

# Rebuild font cache
echo "    Updating font cache..."
fc-cache -f "${INSTALL_FONTS_DIR}"

echo "    HackGen Nerd Font v${HACKGEN_VERSION} installed."
echo "    Font files: ${FONT_FAMILY_DIR}"
