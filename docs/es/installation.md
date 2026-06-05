# Guía de instalación

Este documento cubre la instalación, los requisitos previos y los escenarios
de instalación más comunes para el repositorio de dotfiles en Debian 13 (trixie).

---

## Requisitos previos

- Debian 13 (trixie) — instalación limpia o existente
- Bash 5+ (`bash --version`)
- Una cuenta de usuario no-root con acceso `sudo`
- Conexión a internet (los paquetes y binarios se descargan durante la instalación)
- `git` y `curl` (se instalan si faltan en la primera fase apt)

---

## Instalación estándar

```bash
git clone https://github.com/datadelico/dotfiles.git ~/dotfiles
cd ~/dotfiles
make install
exec bash
```

El target `make install` ejecuta las siguientes fases en orden:

| Fase | Qué hace |
| --- | --- |
| `00-core.sh` | Instala paquetes apt básicos (build-essential, git, curl, fzf, eza, bat, etc.) |
| `01-repos.sh` | Añade repositorios apt externos para GitHub CLI y Docker CE |
| `02-binaries.sh` | Descarga starship, lazygit, lazydocker, zellij desde GitHub Releases |
| `03-fonts.sh` | Descarga e instala HackGen Nerd Font en `~/.local/share/fonts/` |
| `04-stow.sh` | Crea symlinks en `$HOME` usando GNU Stow |
| `05-shell.sh` | Asegura que `~/.local/bin` esté en `PATH` e inicializa los submódulos de git |

---

## Idempotencia

`make install` está diseñado para ejecutarse múltiples veces de forma segura:

- `apt-get install` omite los paquetes ya instalados
- Los instaladores de binarios omiten la instalación si la versión correcta ya está presente
- `stow --restow` refresca los symlinks sin duplicarlos

Ejecuta `make install` tantas veces como necesites para reparar o refrescar la instalación.

---

## Opcional: VSCodium

VSCodium no está incluido en la instalación predeterminada (requiere GUI y no es
necesario en servidores sin interfaz gráfica). Para instalarlo:

```bash
INSTALL_VSCODIUM=1 bash install/01-repos.sh
```

---

## Opcional: Docker Rootless

Tras la instalación principal, configura Docker para ejecutarse sin privilegios de root:

```bash
make setup-docker-rootless
```

Consulta [docker.md](docker.md) para todos los detalles.

---

## Fuentes

HackGen Nerd Font se instala en `~/.local/share/fonts/HackGenNF/` durante
`make install`. Tras la instalación, configura tu emulador de terminal para
usar `HackGen Console NF` como familia de fuente.

Para instalar solo las fuentes (sin la instalación completa):

```bash
make install-fonts
```

---

## Configuración del PATH

`~/.local/bin` se añade al `PATH` por `~/.bash_profile`. Los binarios externos
(starship, lazygit, lazydocker, zellij) se instalan ahí.

Si `~/.local/bin` no está en `PATH` tras la instalación, ejecuta:

```bash
source ~/.bash_profile
```

---

## Verificar la instalación

Ejecuta los smoke tests para verificar que todas las herramientas están presentes:

```bash
make smoke
```

Ejecuta la suite completa de tests BATS:

```bash
make test
```

---

## Instalación manual de fases individuales

Cada script de instalación puede ejecutarse de forma independiente:

```bash
bash install/00-core.sh          # solo paquetes apt
bash install/04-stow.sh          # solo symlinks
bash scripts/install-starship.sh # solo starship
```

---

## Sistemas sin root

La mayoría de las herramientas se instalan en `~/.local/bin` (espacio de usuario).
Los pasos que requieren `sudo` son:

- `install/00-core.sh` — instalación de paquetes apt
- `install/01-repos.sh` — configuración de repositorios apt
- `install/03-fonts.sh` — solo `fc-cache` no requiere sudo

En sistemas donde `sudo` no está disponible, pide al administrador que
pre-instale los paquetes apt listados en `install/00-core.sh` y luego ejecuta
solo las fases en espacio de usuario:

```bash
bash install/02-binaries.sh
bash install/03-fonts.sh
bash install/04-stow.sh
bash install/05-shell.sh
```
