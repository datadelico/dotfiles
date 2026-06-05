# Tool Reference

Complete reference for all tools installed and configured by this dotfiles
repository.

---

## Core apt packages

Installed from the official Debian 13 (trixie) repositories.

| Package | Description |
| --- | --- |
| `build-essential` | C/C++ compiler toolchain (gcc, make, etc.) |
| `curl` | Command-line HTTP client |
| `file` | Determine file type |
| `fontconfig` | Font configuration library |
| `git` | Version control system |
| `gnupg` | GNU Privacy Guard (GPG key management) |
| `iproute2` | Network configuration tools (ip, ss) |
| `unzip` | ZIP archive extraction |
| `wget` | Alternative HTTP download tool |
| `tar` | Archive tool |
| `jq` | JSON processor |
| `chafa` | Terminal image viewer |
| `bash-completion` | Bash programmable completion |
| `openssh-client` | SSH client |
| `htop` | Interactive process viewer |
| `btop` | Resource monitor with graphs |
| `stow` | GNU Stow — symlink farm manager |

---

## Shell enhancement tools

### fzf

- **Package:** `fzf` (Debian apt)
- **Description:** General-purpose fuzzy finder
- **Key bindings (after .bashrc):**
  - `Ctrl+R` — fuzzy history search
  - `Ctrl+T` — fuzzy file finder
  - `Alt+C` — fuzzy cd
- **Config:** `FZF_DEFAULT_COMMAND` and `FZF_DEFAULT_OPTS` in `.bashrc`

### zoxide

- **Package:** `zoxide` (Debian apt)
- **Description:** Smarter `cd` that learns your most-visited directories
- **Usage:** `z <partial-name>` or `zi` for interactive selection
- **Init:** `eval "$(zoxide init bash)"` in `.bashrc`

### eza

- **Package:** `eza` (Debian apt)
- **Description:** Modern `ls` replacement with icons and git integration
- **Aliases:** `ls`, `ll`, `la`, `lt`, `lta`
- **Note:** Renamed from the deprecated `exa`

### bat

- **Package:** `bat` (Debian apt — binary name: `batcat`)
- **Description:** `cat` clone with syntax highlighting and paging
- **Alias:** `bat='batcat'` defined in `aliases.sh`
- **Man page integration:** `MANPAGER="sh -c 'col -bx | batcat -l man -p'"` in `.bashrc`

### fd

- **Package:** `fd-find` (Debian apt — binary name: `fdfind`)
- **Description:** Simple, fast alternative to `find`
- **Alias:** `fd='fdfind'` defined in `aliases.sh`
- **Usage:** `fd <pattern>` instead of `find . -name '*pattern*'`

### ripgrep

- **Package:** `ripgrep` (Debian apt)
- **Binary:** `rg`
- **Description:** Fast recursive grep respecting `.gitignore`
- **Config:** `RIPGREP_CONFIG_PATH` points to `~/.config/ripgrep/config`

---

## Terminal tools

### Alacritty

- **Package:** `alacritty` (Debian apt)
- **Config:** `~/.config/alacritty/alacritty.toml`
- **Theme:** Dracula
- **Font:** HackGen Console NF, 13pt
- **Key bindings:** `Ctrl+Shift+C/V` copy/paste, `Ctrl+Shift+Return` new instance

### tmux

- **Package:** `tmux` (Debian apt)
- **Config:** `~/.config/tmux/tmux.conf`
- **Prefix:** `Ctrl+a`
- **Plugin manager:** TPM (install: `prefix + I`)
- **Plugins:** tmux-sensible, tmux-yank, tmux-resurrect, tmux-continuum
- **Theme:** Dracula-inspired

### Zellij

- **Source:** GitHub Releases (not in Debian repos)
- **Config:** `~/.config/zellij/config.kdl`
- **Default shell:** Bash
- **Key bindings:** `Ctrl+a` enters Pane mode, `Ctrl+t` Tab mode
- **Theme:** Dracula

---

## Git tools

### gh (GitHub CLI)

- **Source:** Official GitHub CLI apt repository (`cli.github.com/packages`)
- **Config:** `~/.config/gh/` (managed by `gh auth login`)
- **Completions:** Loaded automatically in `completions.sh`

### lazygit

- **Source:** GitHub Releases
- **Version:** defined in `config/versions.sh`
- **Alias:** `lg`
- **Config:** `~/.config/lazygit/config.yml` (create manually or let lazygit generate defaults)

---

## Docker tools

### Docker CE

- **Source:** Official Docker apt repository (`download.docker.com`)
- **Packages:** docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin
- **Rootless extras:** docker-ce-rootless-extras, uidmap

### lazydocker

- **Source:** GitHub Releases
- **Version:** defined in `config/versions.sh`
- **Alias:** `lzd`

---

## Quality tools

### ShellCheck

- **Package:** `shellcheck` (Debian apt)
- **Description:** Static analysis for shell scripts
- **Usage:** `shellcheck script.sh` or `make lint`

### shfmt

- **Package:** `shfmt` (Debian apt)
- **Description:** Shell script formatter
- **Usage:** `shfmt -d script.sh` (diff) or `make format` (write in-place)
- **Style:** 4-space indent, `case` indent (`-ci`)

---

## Fonts

### HackGen Console NF

- **Source:** GitHub Releases (`github.com/yuru7/HackGen`)
- **Version:** defined in `config/versions.sh`
- **Install path:** `~/.local/share/fonts/HackGenNF/`
- **Font family name:** `HackGen Console NF`
- **Note:** Family name changed from `HackGenNerd*` to `HackGen* NF` in v2.7.0

---

## Optional: VSCodium

- **Source:** Official VSCodium apt repository (`download.vscodium.com`)
- **Package:** `codium`
- **Install:** `INSTALL_VSCODIUM=1 bash install/01-repos.sh`
- **Not installed by default** — not needed on headless servers
