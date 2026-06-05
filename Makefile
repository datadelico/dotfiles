# =============================================================================
# Makefile — dotfiles management
#
# Usage: make <target>
# Run 'make help' to list all available targets.
# =============================================================================

SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c

REPO_ROOT := $(shell pwd)
DOTFILES_DIR := $(REPO_ROOT)/dotfiles
INSTALL_DIR := $(REPO_ROOT)/install
SCRIPTS_DIR := $(REPO_ROOT)/scripts

# Shell files to lint and format
SHELL_FILES := $(shell find $(REPO_ROOT) \
    -name "*.sh" \
    -not -path "*/tests/bats/test_helper/*" \
    -not -path "*/.git/*" \
    -not -path "*/node_modules/*")

# Markdown files for linting
MARKDOWN_FILES := $(shell find $(REPO_ROOT) \
    -name "*.md" \
    -not -path "*/.git/*" \
    -not -path "*/tests/bats/test_helper/*" \
    -not -path "*/node_modules/*")

# BATS test directories
BATS_UNIT := $(REPO_ROOT)/tests/unit
BATS_INTEGRATION := $(REPO_ROOT)/tests/integration

# Docker
DOCKER_IMAGE := dotfiles-test
DOCKER_COMPOSE := docker/docker-compose.yml

.PHONY: help install update test lint format \
        docker-build docker-test clean \
        setup-docker-rootless install-fonts \
        submodules check-deps

# ---------------------------------------------------------------------------
# Default target
# ---------------------------------------------------------------------------
.DEFAULT_GOAL := help

# ---------------------------------------------------------------------------
# help — list all targets with descriptions
# ---------------------------------------------------------------------------
help: ## Show this help message
	@echo "dotfiles — Debian 13 development environment"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-28s\033[0m %s\n", $$1, $$2}'
	@echo ""

# ---------------------------------------------------------------------------
# submodules — initialize git submodules (BATS helpers)
# ---------------------------------------------------------------------------
submodules: ## Initialize git submodules (bats-assert, bats-support)
	@echo "==> Initializing git submodules..."
	git submodule update --init --recursive

# ---------------------------------------------------------------------------
# check-deps — verify critical tools are present before installing
# ---------------------------------------------------------------------------
check-deps: ## Check that prerequisite tools are available
	@echo "==> Checking dependencies..."
	@command -v sudo   &>/dev/null || { echo "ERROR: sudo not found"; exit 1; }
	@command -v curl   &>/dev/null || { echo "ERROR: curl not found"; exit 1; }
	@command -v git    &>/dev/null || { echo "ERROR: git not found"; exit 1; }
	@echo "    OK."

# ---------------------------------------------------------------------------
# install — run the full installation sequence
# ---------------------------------------------------------------------------
install: check-deps submodules ## Install all dotfiles and tools (full setup)
	@echo "==> Starting full installation..."
	@bash $(INSTALL_DIR)/00-core.sh
	@bash $(INSTALL_DIR)/01-repos.sh
	@bash $(INSTALL_DIR)/02-binaries.sh
	@bash $(INSTALL_DIR)/03-fonts.sh
	@bash $(INSTALL_DIR)/04-stow.sh
	@bash $(INSTALL_DIR)/05-shell.sh
	@echo ""
	@echo "Installation complete. Start a new shell session to apply changes."

# ---------------------------------------------------------------------------
# install-fonts — install fonts only (without full install)
# ---------------------------------------------------------------------------
install-fonts: ## Install HackGen Nerd Font only
	@bash $(SCRIPTS_DIR)/install-fonts.sh

# ---------------------------------------------------------------------------
# update — update external binaries to versions in config/versions.sh
# ---------------------------------------------------------------------------
update: ## Update all external binaries (starship, lazygit, lazydocker, zellij)
	@echo "==> Updating external binaries..."
	@bash $(SCRIPTS_DIR)/install-starship.sh
	@bash $(SCRIPTS_DIR)/install-lazygit.sh
	@bash $(SCRIPTS_DIR)/install-lazydocker.sh
	@bash $(SCRIPTS_DIR)/install-zellij.sh
	@echo "Update complete."

# ---------------------------------------------------------------------------
# test — run all BATS tests
# ---------------------------------------------------------------------------
test: submodules ## Run all tests (unit + integration)
	@echo "==> Running unit tests..."
	@if command -v bats &>/dev/null; then \
		bats --recursive $(BATS_UNIT); \
	else \
		echo "ERROR: bats not installed. Run: sudo apt-get install bats"; \
		exit 1; \
	fi
	@echo "==> Running integration tests..."
	@bats --recursive $(BATS_INTEGRATION)
	@echo "==> All tests passed."

# ---------------------------------------------------------------------------
# smoke — run smoke tests only (no BATS required)
# ---------------------------------------------------------------------------
smoke: ## Run smoke tests (quick binary existence checks)
	@bash $(REPO_ROOT)/tests/smoke/smoke.sh

# ---------------------------------------------------------------------------
# lint — run shellcheck, shfmt, and markdownlint
# ---------------------------------------------------------------------------
lint: ## Lint shell scripts and Markdown files
	@echo "==> Running ShellCheck..."
	@if command -v shellcheck &>/dev/null; then \
		shellcheck --severity=warning $(SHELL_FILES); \
		echo "    ShellCheck passed."; \
	else \
		echo "ERROR: shellcheck not installed. Run: sudo apt-get install shellcheck"; \
		exit 1; \
	fi
	@echo "==> Running shfmt (diff check)..."
	@if command -v shfmt &>/dev/null; then \
		shfmt -d -i 4 -ci $(SHELL_FILES) && echo "    shfmt passed."; \
	else \
		echo "ERROR: shfmt not installed. Run: sudo apt-get install shfmt"; \
		exit 1; \
	fi
	@echo "==> Running markdownlint-cli2..."
	@if command -v markdownlint-cli2 &>/dev/null; then \
		markdownlint-cli2 "**/*.md" "#tests/bats/**" "#node_modules/**" && echo "    markdownlint passed."; \
	else \
		echo "WARNING: markdownlint-cli2 not installed. Install with: npm install -g markdownlint-cli2"; \
	fi

# ---------------------------------------------------------------------------
# format — format shell scripts with shfmt
# ---------------------------------------------------------------------------
format: ## Format all shell scripts with shfmt (writes in-place)
	@echo "==> Formatting shell scripts with shfmt..."
	@if command -v shfmt &>/dev/null; then \
		shfmt -w -i 4 -ci $(SHELL_FILES); \
		echo "    Done."; \
	else \
		echo "ERROR: shfmt not installed. Run: sudo apt-get install shfmt"; \
		exit 1; \
	fi

# ---------------------------------------------------------------------------
# docker-build — build the Docker test image
# ---------------------------------------------------------------------------
docker-build: ## Build the Docker test image (debian:trixie-slim)
	@echo "==> Building Docker image: $(DOCKER_IMAGE)..."
	docker build \
		--file docker/Dockerfile \
		--tag $(DOCKER_IMAGE):latest \
		.
	@echo "    Build complete."

# ---------------------------------------------------------------------------
# docker-test — run tests inside Docker
# ---------------------------------------------------------------------------
docker-test: docker-build ## Run all tests inside the Docker container
	@echo "==> Running Docker tests..."
	docker compose --file $(DOCKER_COMPOSE) run --rm dotfiles-test
	@echo "    Docker tests complete."

# ---------------------------------------------------------------------------
# setup-docker-rootless — configure Docker Rootless mode
# ---------------------------------------------------------------------------
setup-docker-rootless: ## Configure Docker Rootless mode (run as target user)
	@bash $(SCRIPTS_DIR)/setup-docker-rootless.sh

# ---------------------------------------------------------------------------
# clean — remove GNU Stow symlinks (does not delete config files)
# ---------------------------------------------------------------------------
clean: ## Remove dotfile symlinks created by GNU Stow
	@echo "==> Removing GNU Stow symlinks..."
	@for pkg in bash starship alacritty tmux zellij; do \
		if [[ -d "$(DOTFILES_DIR)/$${pkg}" ]]; then \
			echo "    Unstowing: $${pkg}"; \
			stow --dir=$(DOTFILES_DIR) --target=$(HOME) --delete "$${pkg}" || true; \
		fi; \
	done
	@echo "    Symlinks removed. Original files in dotfiles/ are untouched."
