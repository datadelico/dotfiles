#!/usr/bin/env bats
# =============================================================================
# tests/integration/test_tools.bats — Verify that required tools are installed
#
# Designed to run after 'make install' completes — on the host or inside Docker.
# Skips gracefully when run in environments where GUI tools are unavailable.
# =============================================================================

load '../bats/test_helper/bats-support/load'
load '../bats/test_helper/bats-assert/load'

# ---------------------------------------------------------------------------
# Core system tools
# ---------------------------------------------------------------------------
@test "tools: git is installed" {
    run command -v git
    assert_success
}

@test "tools: curl is installed" {
    run command -v curl
    assert_success
}

@test "tools: jq is installed" {
    run command -v jq
    assert_success
}

@test "tools: gpg is installed" {
    run command -v gpg
    assert_success
}

@test "tools: stow is installed" {
    run command -v stow
    assert_success
}

# ---------------------------------------------------------------------------
# Shell enhancement tools
# ---------------------------------------------------------------------------
@test "tools: fzf is installed" {
    run command -v fzf
    assert_success
}

@test "tools: zoxide is installed" {
    run command -v zoxide
    assert_success
}

@test "tools: eza is installed" {
    run command -v eza
    assert_success
}

@test "tools: bat/batcat is installed (Debian)" {
    # Debian installs bat as 'batcat'
    run bash -c 'command -v batcat || command -v bat'
    assert_success
}

@test "tools: fd/fdfind is installed (Debian)" {
    # Debian installs fd as 'fdfind'
    run bash -c 'command -v fdfind || command -v fd'
    assert_success
}

@test "tools: ripgrep (rg) is installed" {
    run command -v rg
    assert_success
}

@test "tools: tmux is installed" {
    run command -v tmux
    assert_success
}

# ---------------------------------------------------------------------------
# External binaries (installed via scripts/)
# ---------------------------------------------------------------------------
@test "tools: starship is installed" {
    run command -v starship
    assert_success
}

@test "tools: starship responds to --version" {
    run starship --version
    assert_success
    assert_output --partial "starship"
}

@test "tools: lazygit is installed" {
    run command -v lazygit
    assert_success
}

@test "tools: lazygit responds to --version" {
    run lazygit --version
    assert_success
}

@test "tools: lazydocker is installed" {
    run command -v lazydocker
    assert_success
}

@test "tools: lazydocker responds to --version" {
    run lazydocker --version
    assert_success
}

@test "tools: zellij is installed" {
    run command -v zellij
    assert_success
}

@test "tools: zellij responds to --version" {
    run zellij --version
    assert_success
}

# ---------------------------------------------------------------------------
# gh (GitHub CLI)
# ---------------------------------------------------------------------------
@test "tools: gh is installed" {
    run command -v gh
    assert_success
}

@test "tools: gh responds to --version" {
    run gh --version
    assert_success
}

# ---------------------------------------------------------------------------
# Quality tools
# ---------------------------------------------------------------------------
@test "tools: shellcheck is installed" {
    run command -v shellcheck
    assert_success
}

@test "tools: shfmt is installed" {
    run command -v shfmt
    assert_success
}

# ---------------------------------------------------------------------------
# System monitoring
# ---------------------------------------------------------------------------
@test "tools: htop is installed" {
    run command -v htop
    assert_success
}

@test "tools: btop is installed" {
    run command -v btop
    assert_success
}

# ---------------------------------------------------------------------------
# Alacritty — skip on headless/server environments
# ---------------------------------------------------------------------------
@test "tools: alacritty is installed (skip on headless)" {
    if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
        skip "No display server available (headless environment)"
    fi
    run command -v alacritty
    assert_success
}
