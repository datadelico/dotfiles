# dotfiles

> A production-quality Bash development environment for Debian 13, SSH
> administration, and reproducible Linux workstations.

[![lint](https://github.com/datadelico/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/datadelico/dotfiles/actions/workflows/lint.yml)
[![build](https://github.com/datadelico/dotfiles/actions/workflows/build.yml/badge.svg)](https://github.com/datadelico/dotfiles/actions/workflows/build.yml)
[![integration](https://github.com/datadelico/dotfiles/actions/workflows/integration.yml/badge.svg)](https://github.com/datadelico/dotfiles/actions/workflows/integration.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Overview

This repository contains a complete, reproducible Bash development environment
for Debian 13 (trixie). A single `make install` command on a clean system
installs and configures all tools, creates symlinks with GNU Stow, and leaves
the environment ready for daily use.

It is designed for:

- Modern Linux development workstations
- SSH server administration
- Homelabs and reproducible environments
- Public GitHub publication and long-term maintenance

---

## Features

| Category | Tools |
|---|---|
| **Shell** | Bash, bash-completion, Starship prompt |
| **Fuzzy find** | fzf, zoxide |
| **File listing** | eza (modern ls replacement) |
| **File viewer** | bat (Debian: batcat) |
| **Search** | ripgrep (rg), fd (Debian: fdfind) |
| **Terminal** | Alacritty, tmux, Zellij |
| **Git UI** | lazygit |
| **Docker UI** | lazydocker |
| **Docker** | Docker CE, Docker Rootless |
| **Git** | git, gh (GitHub CLI) |
| **IDE** | VSCodium (optional) |
| **Fonts** | HackGen Console NF (Nerd Font) |
| **Icons** | Papirus Icon Theme |
| **Quality** | ShellCheck, shfmt |
| **Monitoring** | htop, btop |

---

## Architecture

```
dotfiles/
├── config/versions.sh       ← centralized tool version definitions
├── dotfiles/                ← GNU Stow packages (symlinked into $HOME)
│   ├── bash/                ← .bashrc, .bash_profile, .inputrc, aliases, functions
│   ├── starship/            ← starship.toml
│   ├── alacritty/           ← alacritty.toml
│   ├── tmux/                ← tmux.conf
│   └── zellij/              ← config.kdl
├── install/                 ← phased installation scripts (00–05)
├── scripts/                 ← individual binary installers + docker rootless
├── tests/                   ← BATS unit, integration, and smoke tests
├── docker/                  ← Dockerfile, docker-compose.yml, test script
├── .github/workflows/       ← CI/CD: lint, build, test, integration, release
└── docs/                    ← full documentation (English and Spanish)
```

### Dotfile linking strategy

GNU Stow mirrors the directory structure inside each package to `$HOME`.
Running `make install` calls `stow --restow` for every package, which is
idempotent: safe to run multiple times without breaking anything.

### Installation phases

| Phase | Script | Description |
|---|---|---|
| 00 | `install/00-core.sh` | Core apt packages |
| 01 | `install/01-repos.sh` | External apt repos (gh, Docker CE) |
| 02 | `install/02-binaries.sh` | External binaries with checksum verification |
| 03 | `install/03-fonts.sh` | HackGen Nerd Font |
| 04 | `install/04-stow.sh` | GNU Stow symlinks |
| 05 | `install/05-shell.sh` | PATH and git submodule init |

---

## Requirements

- Debian 13 (trixie)
- Bash 5+
- A user account with `sudo` privileges
- Internet access for package and binary downloads

---

## Installation

### Quick start

```bash
git clone https://github.com/datadelico/dotfiles.git ~/dotfiles
cd ~/dotfiles
make install
```

Start a new shell session to apply all changes:

```bash
exec bash
```

### Verify installation

```bash
make smoke
```

### Optional: VSCodium

To also install VSCodium (GUI editor — not included in the default install):

```bash
INSTALL_VSCODIUM=1 bash install/01-repos.sh
```

### Optional: Docker Rootless

After the main install, configure Docker to run without root:

```bash
make setup-docker-rootless
```

See [docs/en/docker.md](docs/en/docker.md) for full details.

---

## Upgrade

To upgrade all externally installed binaries to the versions in
`config/versions.sh`:

```bash
# Edit config/versions.sh with the new version numbers, then:
make update
```

To upgrade apt packages:

```bash
sudo apt-get update && sudo apt-get upgrade
```

---

## Available `make` targets

```
make help                    Show all targets
make install                 Full installation (phases 00–05)
make update                  Update external binaries
make test                    Run BATS unit + integration tests
make smoke                   Run smoke tests (quick checks)
make lint                    Run ShellCheck + shfmt + markdownlint
make format                  Format shell scripts with shfmt
make docker-build            Build Docker test image
make docker-test             Run tests inside Docker
make clean                   Remove GNU Stow symlinks
make setup-docker-rootless   Configure Docker Rootless mode
make install-fonts           Install HackGen Nerd Font only
```

---

## Tool descriptions

### Starship prompt

[Starship](https://starship.rs) is a fast, cross-shell prompt. The
configuration in `dotfiles/starship/.config/starship.toml` provides:

- Multiline prompt
- Absolute path (no truncation)
- Git branch and status
- Command duration (for commands > 2 seconds)
- SSH indicator: hostname is shown and an `SSH` label appears on the right
  when `SSH_CONNECTION` is set
- Root indicator: username shown in red when running as root
- Nerd Font icons throughout

### fzf

[fzf](https://github.com/junegunn/fzf) provides fuzzy file finding and history
search. Key bindings after sourcing `.bashrc`:

- `Ctrl+R` — fuzzy history search
- `Ctrl+T` — fuzzy file finder
- `Alt+C` — fuzzy cd

### zoxide

[zoxide](https://github.com/ajeetdsouza/zoxide) learns your most-visited
directories. Use `z <partial-name>` to jump anywhere instantly.

### eza

[eza](https://github.com/eza-community/eza) is a modern `ls` replacement.
The `ls`, `ll`, `la`, `lt`, and `lta` aliases are automatically configured.

### bat

[bat](https://github.com/sharkdp/bat) is a `cat` clone with syntax highlighting.
On Debian the binary is named `batcat`; the alias `bat='batcat'` is set
automatically in `aliases.sh`.

### ripgrep / fd

[ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) and
[fd](https://github.com/sharkdp/fd) are faster alternatives to `grep` and
`find`. On Debian, `fd` is installed as `fdfind`; the alias `fd='fdfind'` is
set automatically.

### lazygit

[lazygit](https://github.com/jesseduffield/lazygit) is a terminal UI for git.
Use the `lg` alias to launch it.

### lazydocker

[lazydocker](https://github.com/jesseduffield/lazydocker) is a terminal UI for
Docker. Use the `lzd` alias to launch it.

---

## SSH usage

When connecting to a remote host via SSH, the Starship prompt automatically:

1. Shows the hostname in yellow after the username
2. Displays an `SSH` label on the right prompt
3. Keeps the full absolute path visible

The configuration relies on the standard `SSH_CONNECTION` environment variable
which is set by the SSH daemon on all standard OpenSSH servers.

See [docs/en/ssh.md](docs/en/ssh.md) for complete SSH configuration guidance.

---

## Docker usage

### Standard Docker (with root)

Installed via the official Docker apt repository. Managed with the `docker`
command and visualized with `lazydocker` (`lzd`).

### Docker Rootless

Runs the Docker daemon without root privileges. Setup:

```bash
make setup-docker-rootless
```

After setup, `DOCKER_HOST` is automatically set in `~/.bash_profile` when the
rootless socket exists.

See [docs/en/docker.md](docs/en/docker.md) for full details.

---

## Security notes

- No installation script uses `curl ... | bash` without validation.
- All external binaries are downloaded from official GitHub Releases.
- Starship and Zellij binaries are verified with SHA-256 checksums before
  installation.
- External apt repositories use official GPG keys pinned to
  `/usr/share/keyrings/` (the current Debian standard).
- No secrets, credentials, or private keys are stored in this repository.

---

## Screenshots

See [assets/screenshots/README.md](assets/screenshots/README.md) for
instructions on capturing screenshots of the configured environment.

---

## Troubleshooting

See [docs/en/troubleshooting.md](docs/en/troubleshooting.md).

---

## Uninstall

To remove GNU Stow symlinks without deleting the repository:

```bash
make clean
```

This only removes the symlinks. Original files in `dotfiles/` are untouched.

See [docs/en/uninstall.md](docs/en/uninstall.md) for a complete uninstall guide.

---

## License

[MIT](LICENSE) © 2026 datadelico
