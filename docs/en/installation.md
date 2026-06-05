# Installation Guide

This document covers installation, prerequisites, and common install scenarios
for the dotfiles repository on Debian 13 (trixie).

---

## Prerequisites

- Debian 13 (trixie) — fresh or existing installation
- Bash 5+ (`bash --version`)
- A non-root user account with `sudo` access
- Internet connection (packages and binaries are downloaded during install)
- `git` and `curl` (installed if missing by the first apt phase)

---

## Standard installation

```bash
git clone https://github.com/datadelico/dotfiles.git ~/dotfiles
cd ~/dotfiles
make install
exec bash
```

The `make install` target runs the following phases in order:

| Phase | What it does |
| --- | --- |
| `00-core.sh` | Installs core apt packages (build-essential, git, curl, fzf, eza, bat, etc.) |
| `01-repos.sh` | Adds external apt repos for GitHub CLI and Docker CE |
| `02-binaries.sh` | Downloads starship, lazygit, lazydocker, zellij from GitHub Releases |
| `03-fonts.sh` | Downloads and installs HackGen Nerd Font to `~/.local/share/fonts/` |
| `04-stow.sh` | Creates symlinks in `$HOME` using GNU Stow |
| `05-shell.sh` | Ensures `~/.local/bin` is in `PATH` and initializes git submodules |

---

## Idempotency

`make install` is designed to be run multiple times safely:

- `apt-get install` skips already-installed packages
- Binary installers skip if the correct version is already present
- `stow --restow` refreshes symlinks without duplicating them

Run `make install` again at any time to repair or refresh the installation.

---

## Optional: VSCodium

VSCodium is not included in the default install (it requires a GUI and is not
needed on headless servers). To install it:

```bash
INSTALL_VSCODIUM=1 bash install/01-repos.sh
```

---

## Optional: Docker Rootless

After the main install, configure Docker to run without root privileges:

```bash
make setup-docker-rootless
```

See [docker.md](docker.md) for full details.

---

## Fonts

HackGen Nerd Font is installed to `~/.local/share/fonts/HackGenNF/` during
`make install`. After installation, configure your terminal emulator to use
`HackGen Console NF` as the font family.

To install fonts only (without the full install):

```bash
make install-fonts
```

---

## PATH configuration

`~/.local/bin` is added to `PATH` by `~/.bash_profile`. External binaries
(starship, lazygit, lazydocker, zellij) are installed there.

If `~/.local/bin` is not in `PATH` after the install, run:

```bash
source ~/.bash_profile
```

---

## Verifying the installation

Run the smoke tests to verify all tools are present:

```bash
make smoke
```

Run the full BATS test suite:

```bash
make test
```

---

## Manual installation of individual phases

Each install script can be run independently:

```bash
bash install/00-core.sh          # apt packages only
bash install/04-stow.sh          # symlinks only
bash scripts/install-starship.sh # starship only
```

---

## Non-root systems

Most tools are installed to `~/.local/bin` (user-space). The following steps
require `sudo`:

- `install/00-core.sh` — apt package installation
- `install/01-repos.sh` — apt repository setup
- `install/03-fonts.sh` — only `fc-cache` runs without sudo

On systems where `sudo` is unavailable, ask the system administrator to
pre-install the apt packages listed in `install/00-core.sh` and then run
only the user-space phases:

```bash
bash install/02-binaries.sh
bash install/03-fonts.sh
bash install/04-stow.sh
bash install/05-shell.sh
```
