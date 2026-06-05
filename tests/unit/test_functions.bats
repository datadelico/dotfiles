#!/usr/bin/env bats
# =============================================================================
# tests/unit/test_functions.bats — Unit tests for Bash functions
# =============================================================================

load '../bats/test_helper/bats-support/load'
load '../bats/test_helper/bats-assert/load'

FUNCTIONS_FILE="${BATS_TEST_DIRNAME}/../../dotfiles/bash/.config/bash/functions.sh"

setup() {
    # shellcheck source=/dev/null
    source "${FUNCTIONS_FILE}"
    TEST_TMPDIR="$(mktemp -d)"
}

teardown() {
    rm -rf "${TEST_TMPDIR}"
}

# ---------------------------------------------------------------------------
# mkcd
# ---------------------------------------------------------------------------
@test "mkcd: creates a directory and changes into it" {
    local target="${TEST_TMPDIR}/newdir"
    mkcd "${target}"
    assert_equal "${PWD}" "${target}"
    assert [ -d "${target}" ]
}

@test "mkcd: creates nested directories" {
    local target="${TEST_TMPDIR}/a/b/c"
    mkcd "${target}"
    assert_equal "${PWD}" "${target}"
}

@test "mkcd: prints usage when called with no arguments" {
    run mkcd
    assert_failure
    assert_output --partial "Usage:"
}

# ---------------------------------------------------------------------------
# extract
# ---------------------------------------------------------------------------
@test "extract: extracts a .tar.gz archive" {
    local archive="${TEST_TMPDIR}/test.tar.gz"
    echo "hello" >"${TEST_TMPDIR}/file.txt"
    tar czf "${archive}" -C "${TEST_TMPDIR}" file.txt
    rm "${TEST_TMPDIR}/file.txt"
    (cd "${TEST_TMPDIR}" && extract "${archive}")
    assert [ -f "${TEST_TMPDIR}/file.txt" ]
}

@test "extract: extracts a .zip archive" {
    local archive="${TEST_TMPDIR}/test.zip"
    echo "hello" >"${TEST_TMPDIR}/file.txt"
    (cd "${TEST_TMPDIR}" && zip -q "${archive}" file.txt)
    rm "${TEST_TMPDIR}/file.txt"
    (cd "${TEST_TMPDIR}" && extract "${archive}")
    assert [ -f "${TEST_TMPDIR}/file.txt" ]
}

@test "extract: fails with helpful message on non-existent file" {
    run extract "/nonexistent/file.tar.gz"
    assert_failure
    assert_output --partial "not a valid file"
}

@test "extract: fails with usage when called with no arguments" {
    run extract
    assert_failure
    assert_output --partial "Usage:"
}

# ---------------------------------------------------------------------------
# up
# ---------------------------------------------------------------------------
@test "up: navigates up one directory by default" {
    local start="${TEST_TMPDIR}/a/b"
    mkdir -p "${start}"
    cd "${start}"
    up
    assert_equal "${PWD}" "${TEST_TMPDIR}/a"
}

@test "up: navigates up N directories" {
    local start="${TEST_TMPDIR}/a/b/c"
    mkdir -p "${start}"
    cd "${start}"
    up 2
    assert_equal "${PWD}" "${TEST_TMPDIR}/a"
}

# ---------------------------------------------------------------------------
# confirm
# ---------------------------------------------------------------------------
@test "confirm: returns 0 when user answers y" {
    run bash -c 'source '"${FUNCTIONS_FILE}"'; echo "y" | confirm "Continue?" && echo "confirmed"'
    assert_success
    assert_output --partial "confirmed"
}

@test "confirm: returns 1 when user answers n" {
    run bash -c 'source '"${FUNCTIONS_FILE}"'; echo "n" | confirm "Continue?" || echo "denied"'
    assert_output --partial "denied"
}

@test "confirm: returns 1 on empty input (default no)" {
    run bash -c 'source '"${FUNCTIONS_FILE}"'; echo "" | confirm "Continue?" || echo "denied"'
    assert_output --partial "denied"
}

# ---------------------------------------------------------------------------
# mkenv
# ---------------------------------------------------------------------------
@test "mkenv: creates a .env file in the current directory" {
    cd "${TEST_TMPDIR}"
    run mkenv
    assert_success
    assert [ -f "${TEST_TMPDIR}/.env" ]
}

@test "mkenv: fails if .env already exists" {
    cd "${TEST_TMPDIR}"
    touch .env
    run mkenv
    assert_failure
    assert_output --partial "already exists"
}
