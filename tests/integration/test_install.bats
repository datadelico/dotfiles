#!/usr/bin/env bats
# =============================================================================
# tests/integration/test_install.bats — Verify dotfiles are correctly stowed
#
# Checks that GNU Stow created the expected symlinks in $HOME.
# Runs after 'make install' or 'install/04-stow.sh'.
# =============================================================================

load '../bats/test_helper/bats-support/load'
load '../bats/test_helper/bats-assert/load'

# ---------------------------------------------------------------------------
# Bash dotfiles
# ---------------------------------------------------------------------------
@test "stow: ~/.bashrc exists" {
    assert [ -e "${HOME}/.bashrc" ]
}

@test "stow: ~/.bash_profile exists" {
    assert [ -e "${HOME}/.bash_profile" ]
}

@test "stow: ~/.inputrc exists" {
    assert [ -e "${HOME}/.inputrc" ]
}

@test "stow: ~/.config/bash/aliases.sh exists" {
    assert [ -e "${HOME}/.config/bash/aliases.sh" ]
}

@test "stow: ~/.config/bash/functions.sh exists" {
    assert [ -e "${HOME}/.config/bash/functions.sh" ]
}

@test "stow: ~/.config/bash/completions.sh exists" {
    assert [ -e "${HOME}/.config/bash/completions.sh" ]
}

# ---------------------------------------------------------------------------
# Starship
# ---------------------------------------------------------------------------
@test "stow: ~/.config/starship.toml exists" {
    assert [ -e "${HOME}/.config/starship.toml" ]
}

# ---------------------------------------------------------------------------
# tmux
# ---------------------------------------------------------------------------
@test "stow: ~/.config/tmux/tmux.conf exists" {
    assert [ -e "${HOME}/.config/tmux/tmux.conf" ]
}

# ---------------------------------------------------------------------------
# Zellij
# ---------------------------------------------------------------------------
@test "stow: ~/.config/zellij/config.kdl exists" {
    assert [ -e "${HOME}/.config/zellij/config.kdl" ]
}

# ---------------------------------------------------------------------------
# Alacritty
# ---------------------------------------------------------------------------
@test "stow: ~/.config/alacritty/alacritty.toml exists" {
    assert [ -e "${HOME}/.config/alacritty/alacritty.toml" ]
}

# ---------------------------------------------------------------------------
# Bash configuration integrity
# ---------------------------------------------------------------------------
@test "bash: .bashrc sources aliases.sh" {
    run grep -c 'aliases.sh' "${HOME}/.bashrc"
    assert_success
    refute_output "0"
}

@test "bash: .bashrc sources functions.sh" {
    run grep -c 'functions.sh' "${HOME}/.bashrc"
    assert_success
    refute_output "0"
}

@test "bash: .bashrc initializes starship" {
    run grep -c 'starship init bash' "${HOME}/.bashrc"
    assert_success
    refute_output "0"
}

@test "bash: .bashrc initializes zoxide" {
    run grep -c 'zoxide init bash' "${HOME}/.bashrc"
    assert_success
    refute_output "0"
}

@test "bash: .bashrc initializes fzf" {
    run grep -c 'fzf' "${HOME}/.bashrc"
    assert_success
    refute_output "0"
}

# ---------------------------------------------------------------------------
# Idempotency: running stow a second time must not fail
# ---------------------------------------------------------------------------
@test "stow: re-running 04-stow.sh is idempotent (exit 0)" {
    local stow_script="${BATS_TEST_DIRNAME}/../../install/04-stow.sh"
    run bash "${stow_script}"
    assert_success
}
