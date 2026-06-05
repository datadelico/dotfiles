#!/usr/bin/env bash
# =============================================================================
# install/03-fonts.sh — Install HackGen Nerd Font
# =============================================================================

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "==> [03-fonts] Installing fonts..."

bash "${REPO_ROOT}/scripts/install-fonts.sh"

echo "==> [03-fonts] Done."
