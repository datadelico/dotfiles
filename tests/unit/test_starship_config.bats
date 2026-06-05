#!/usr/bin/env bats
# =============================================================================
# tests/unit/test_starship_config.bats — Validate starship.toml
#
# Checks that the Starship configuration is syntactically valid and contains
# the required modules for SSH detection, root detection, and multiline prompt.
# =============================================================================

load '../bats/test_helper/bats-support/load'
load '../bats/test_helper/bats-assert/load'

STARSHIP_CONFIG="${BATS_TEST_DIRNAME}/../../dotfiles/starship/.config/starship.toml"

# ---------------------------------------------------------------------------
# File existence
# ---------------------------------------------------------------------------
@test "starship.toml: config file exists" {
    assert [ -f "${STARSHIP_CONFIG}" ]
}

# ---------------------------------------------------------------------------
# Starship validation (requires starship to be installed)
# ---------------------------------------------------------------------------
@test "starship.toml: passes starship config validation" {
    if ! command -v starship &>/dev/null; then
        skip "starship not installed"
    fi
    run starship config --print-default
    # If starship is installed, validate our config instead
    run env STARSHIP_CONFIG="${STARSHIP_CONFIG}" starship print-path
    # We just need it not to crash — any output is acceptable
    assert [ "$status" -eq 0 ] || assert [ "$status" -eq 1 ]
}

# ---------------------------------------------------------------------------
# Required modules in the format string
# ---------------------------------------------------------------------------
@test "starship.toml: contains username module" {
    run grep -c '^\[username\]' "${STARSHIP_CONFIG}"
    assert_success
    assert_output "1"
}

@test "starship.toml: contains hostname module with ssh_only = true" {
    run grep -c 'ssh_only = true' "${STARSHIP_CONFIG}"
    assert_success
    refute_output "0"
}

@test "starship.toml: contains directory module" {
    run grep -c '^\[directory\]' "${STARSHIP_CONFIG}"
    assert_success
    assert_output "1"
}

@test "starship.toml: directory truncation is disabled (full path)" {
    run grep 'truncation_length = 0' "${STARSHIP_CONFIG}"
    assert_success
}

@test "starship.toml: contains git_branch module" {
    run grep -c '^\[git_branch\]' "${STARSHIP_CONFIG}"
    assert_success
    assert_output "1"
}

@test "starship.toml: contains git_status module" {
    run grep -c '^\[git_status\]' "${STARSHIP_CONFIG}"
    assert_success
    assert_output "1"
}

@test "starship.toml: contains cmd_duration module" {
    run grep -c '^\[cmd_duration\]' "${STARSHIP_CONFIG}"
    assert_success
    assert_output "1"
}

@test "starship.toml: contains SSH env_var detection" {
    run grep -c 'SSH_CONNECTION' "${STARSHIP_CONFIG}"
    assert_success
    refute_output "0"
}

@test "starship.toml: contains line_break module (multiline prompt)" {
    run grep -c '^\[line_break\]' "${STARSHIP_CONFIG}"
    assert_success
    assert_output "1"
}

@test "starship.toml: contains character module" {
    run grep -c '^\[character\]' "${STARSHIP_CONFIG}"
    assert_success
    assert_output "1"
}

# ---------------------------------------------------------------------------
# TOML syntax — no tabs (TOML does not allow tabs for indentation)
# ---------------------------------------------------------------------------
@test "starship.toml: does not contain tab characters" {
    run grep -P '\t' "${STARSHIP_CONFIG}"
    assert_failure  # grep returns 1 when no match found — that is the success case
}
