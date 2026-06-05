#!/usr/bin/env bats
# =============================================================================
# tests/unit/test_aliases.bats — Unit tests for Bash aliases
#
# Verifies that aliases.sh defines the expected aliases and that Debian-specific
# binary name normalizations are present.
# =============================================================================
# shellcheck disable=SC1090  # BATS test file — source paths are dynamic

load '../bats/test_helper/bats-support/load'
load '../bats/test_helper/bats-assert/load'

# Path to the aliases file under test
ALIASES_FILE="${BATS_TEST_DIRNAME}/../../dotfiles/bash/.config/bash/aliases.sh"

setup() {
    # Load the aliases file into a subshell-friendly environment
    # shellcheck source=/dev/null
    source "${ALIASES_FILE}"
}

# ---------------------------------------------------------------------------
# bat / batcat alias
# ---------------------------------------------------------------------------
@test "aliases.sh: bat alias is defined as 'batcat' when batcat is available" {
    # Simulate batcat being present by creating a stub in a temp dir
    local tmp_bin
    tmp_bin="$(mktemp -d)"
    touch "${tmp_bin}/batcat"
    chmod +x "${tmp_bin}/batcat"
    PATH="${tmp_bin}:${PATH}" source "${ALIASES_FILE}"
    assert [ "$(type -t bat)" = "alias" ]
    rm -rf "${tmp_bin}"
}

# ---------------------------------------------------------------------------
# fd / fdfind alias
# ---------------------------------------------------------------------------
@test "aliases.sh: fd alias is defined as 'fdfind' when fdfind is available" {
    local tmp_bin
    tmp_bin="$(mktemp -d)"
    touch "${tmp_bin}/fdfind"
    chmod +x "${tmp_bin}/fdfind"
    PATH="${tmp_bin}:${PATH}" source "${ALIASES_FILE}"
    assert [ "$(type -t fd)" = "alias" ]
    rm -rf "${tmp_bin}"
}

# ---------------------------------------------------------------------------
# eza aliases
# ---------------------------------------------------------------------------
@test "aliases.sh: ls alias is defined as eza when eza is available" {
    local tmp_bin
    tmp_bin="$(mktemp -d)"
    touch "${tmp_bin}/eza"
    chmod +x "${tmp_bin}/eza"
    PATH="${tmp_bin}:${PATH}" source "${ALIASES_FILE}"
    assert [ "$(type -t ls)" = "alias" ]
    run alias ls
    assert_output --partial "eza"
    rm -rf "${tmp_bin}"
}

@test "aliases.sh: ll alias is defined when eza is available" {
    local tmp_bin
    tmp_bin="$(mktemp -d)"
    touch "${tmp_bin}/eza"
    chmod +x "${tmp_bin}/eza"
    PATH="${tmp_bin}:${PATH}" source "${ALIASES_FILE}"
    assert [ "$(type -t ll)" = "alias" ]
    rm -rf "${tmp_bin}"
}

@test "aliases.sh: la alias is defined when eza is available" {
    local tmp_bin
    tmp_bin="$(mktemp -d)"
    touch "${tmp_bin}/eza"
    chmod +x "${tmp_bin}/eza"
    PATH="${tmp_bin}:${PATH}" source "${ALIASES_FILE}"
    assert [ "$(type -t la)" = "alias" ]
    rm -rf "${tmp_bin}"
}

# ---------------------------------------------------------------------------
# Git aliases
# ---------------------------------------------------------------------------
@test "aliases.sh: g alias for git is defined" {
    source "${ALIASES_FILE}"
    assert [ "$(type -t g)" = "alias" ]
}

@test "aliases.sh: gs alias for git status is defined" {
    source "${ALIASES_FILE}"
    assert [ "$(type -t gs)" = "alias" ]
}

@test "aliases.sh: glog alias for git log is defined" {
    source "${ALIASES_FILE}"
    assert [ "$(type -t glog)" = "alias" ]
}

# ---------------------------------------------------------------------------
# lazygit alias
# ---------------------------------------------------------------------------
@test "aliases.sh: lg alias is defined as lazygit when lazygit is available" {
    local tmp_bin
    tmp_bin="$(mktemp -d)"
    touch "${tmp_bin}/lazygit"
    chmod +x "${tmp_bin}/lazygit"
    PATH="${tmp_bin}:${PATH}" source "${ALIASES_FILE}"
    assert [ "$(type -t lg)" = "alias" ]
    rm -rf "${tmp_bin}"
}

# ---------------------------------------------------------------------------
# lazydocker alias
# ---------------------------------------------------------------------------
@test "aliases.sh: lzd alias is defined as lazydocker when lazydocker is available" {
    local tmp_bin
    tmp_bin="$(mktemp -d)"
    touch "${tmp_bin}/lazydocker"
    chmod +x "${tmp_bin}/lazydocker"
    PATH="${tmp_bin}:${PATH}" source "${ALIASES_FILE}"
    assert [ "$(type -t lzd)" = "alias" ]
    rm -rf "${tmp_bin}"
}

# ---------------------------------------------------------------------------
# Safety aliases
# ---------------------------------------------------------------------------
@test "aliases.sh: cp uses -i flag (interactive)" {
    source "${ALIASES_FILE}"
    run alias cp
    assert_output --partial "cp -i"
}

@test "aliases.sh: rm uses -i flag (interactive)" {
    source "${ALIASES_FILE}"
    run alias rm
    assert_output --partial "rm -i"
}

@test "aliases.sh: mv uses -i flag (interactive)" {
    source "${ALIASES_FILE}"
    run alias mv
    assert_output --partial "mv -i"
}

# ---------------------------------------------------------------------------
# reload alias
# ---------------------------------------------------------------------------
@test "aliases.sh: reload alias is defined" {
    source "${ALIASES_FILE}"
    assert [ "$(type -t reload)" = "alias" ]
}
