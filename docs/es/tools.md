# Referencia de herramientas

Referencia completa de todas las herramientas instaladas y configuradas por
este repositorio de dotfiles.

---

## Paquetes apt básicos

Instalados desde los repositorios oficiales de Debian 13 (trixie).

| Paquete | Descripción |
|---|---|
| `build-essential` | Cadena de compilación C/C++ (gcc, make, etc.) |
| `curl` | Cliente HTTP en línea de comandos |
| `file` | Determina el tipo de archivo |
| `fontconfig` | Biblioteca de configuración de fuentes |
| `git` | Sistema de control de versiones |
| `gnupg` | GNU Privacy Guard (gestión de claves GPG) |
| `iproute2` | Herramientas de configuración de red (ip, ss) |
| `unzip` | Extracción de archivos ZIP |
| `wget` | Herramienta alternativa de descarga HTTP |
| `tar` | Herramienta de archivado |
| `jq` | Procesador JSON |
| `chafa` | Visor de imágenes en terminal |
| `bash-completion` | Completado programable de Bash |
| `openssh-client` | Cliente SSH |
| `htop` | Visor interactivo de procesos |
| `btop` | Monitor de recursos con gráficas |
| `stow` | GNU Stow — gestor de granja de symlinks |

---

## Herramientas de mejora del shell

### fzf

- **Paquete:** `fzf` (Debian apt)
- **Descripción:** Buscador difuso de propósito general
- **Atajos de teclado (tras cargar .bashrc):**
  - `Ctrl+R` — búsqueda difusa en el historial
  - `Ctrl+T` — buscador difuso de archivos
  - `Alt+C` — cd difuso
- **Configuración:** `FZF_DEFAULT_COMMAND` y `FZF_DEFAULT_OPTS` en `.bashrc`

### zoxide

- **Paquete:** `zoxide` (Debian apt)
- **Descripción:** `cd` inteligente que aprende tus directorios más visitados
- **Uso:** `z <nombre-parcial>` o `zi` para selección interactiva
- **Inicialización:** `eval "$(zoxide init bash)"` en `.bashrc`

### eza

- **Paquete:** `eza` (Debian apt)
- **Descripción:** Reemplazo moderno de `ls` con iconos e integración de git
- **Aliases:** `ls`, `ll`, `la`, `lt`, `lta`
- **Nota:** Renombrado desde el obsoleto `exa`

### bat

- **Paquete:** `bat` (Debian apt — nombre del binario: `batcat`)
- **Descripción:** Clon de `cat` con resaltado de sintaxis y paginación
- **Alias:** `bat='batcat'` definido en `aliases.sh`
- **Integración con man:** `MANPAGER="sh -c 'col -bx | batcat -l man -p'"` en `.bashrc`

### fd

- **Paquete:** `fd-find` (Debian apt — nombre del binario: `fdfind`)
- **Descripción:** Alternativa rápida y simple a `find`
- **Alias:** `fd='fdfind'` definido en `aliases.sh`
- **Uso:** `fd <patrón>` en lugar de `find . -name '*patrón*'`

### ripgrep

- **Paquete:** `ripgrep` (Debian apt)
- **Binario:** `rg`
- **Descripción:** grep recursivo rápido que respeta `.gitignore`
- **Configuración:** `RIPGREP_CONFIG_PATH` apunta a `~/.config/ripgrep/config`

---

## Herramientas de terminal

### Alacritty

- **Paquete:** `alacritty` (Debian apt)
- **Configuración:** `~/.config/alacritty/alacritty.toml`
- **Tema:** Dracula
- **Fuente:** HackGen Console NF, 13pt
- **Atajos de teclado:** `Ctrl+Shift+C/V` copiar/pegar, `Ctrl+Shift+Return` nueva instancia

### tmux

- **Paquete:** `tmux` (Debian apt)
- **Configuración:** `~/.config/tmux/tmux.conf`
- **Prefijo:** `Ctrl+a`
- **Gestor de plugins:** TPM (instalar: `prefijo + I`)
- **Plugins:** tmux-sensible, tmux-yank, tmux-resurrect, tmux-continuum
- **Tema:** Inspirado en Dracula

### Zellij

- **Fuente:** GitHub Releases (no está en los repos de Debian)
- **Configuración:** `~/.config/zellij/config.kdl`
- **Shell predeterminada:** Bash
- **Atajos de teclado:** `Ctrl+a` entra al modo Pane, `Ctrl+t` modo Tab
- **Tema:** Dracula

---

## Herramientas de git

### gh (GitHub CLI)

- **Fuente:** Repositorio apt oficial de GitHub CLI (`cli.github.com/packages`)
- **Configuración:** `~/.config/gh/` (gestionado por `gh auth login`)
- **Completados:** Se cargan automáticamente en `completions.sh`

### lazygit

- **Fuente:** GitHub Releases
- **Versión:** definida en `config/versions.sh`
- **Alias:** `lg`
- **Configuración:** `~/.config/lazygit/config.yml`

---

## Herramientas de Docker

### Docker CE

- **Fuente:** Repositorio apt oficial de Docker (`download.docker.com`)
- **Paquetes:** docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin
- **Extras rootless:** docker-ce-rootless-extras, uidmap

### lazydocker

- **Fuente:** GitHub Releases
- **Versión:** definida en `config/versions.sh`
- **Alias:** `lzd`

---

## Herramientas de calidad

### ShellCheck

- **Paquete:** `shellcheck` (Debian apt)
- **Descripción:** Análisis estático para scripts shell
- **Uso:** `shellcheck script.sh` o `make lint`

### shfmt

- **Paquete:** `shfmt` (Debian apt)
- **Descripción:** Formateador de scripts shell
- **Uso:** `shfmt -d script.sh` (diff) o `make format` (sobreescribir)
- **Estilo:** Indentación de 4 espacios, indentación de `case` (`-ci`)

---

## Fuentes

### HackGen Console NF

- **Fuente:** GitHub Releases (`github.com/yuru7/HackGen`)
- **Versión:** definida en `config/versions.sh`
- **Ruta de instalación:** `~/.local/share/fonts/HackGenNF/`
- **Nombre de familia de fuente:** `HackGen Console NF`
- **Nota:** El nombre de familia cambió de `HackGenNerd*` a `HackGen* NF` en v2.7.0

---

## Opcional: VSCodium

- **Fuente:** Repositorio apt oficial de VSCodium (`download.vscodium.com`)
- **Paquete:** `codium`
- **Instalación:** `INSTALL_VSCODIUM=1 bash install/01-repos.sh`
- **No se instala por defecto** — no es necesario en servidores sin GUI
