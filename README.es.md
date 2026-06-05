# dotfiles

> Un entorno de desarrollo Bash de calidad de producción para Debian 13,
> administración SSH y estaciones de trabajo Linux reproducibles.

[![lint](https://github.com/datadelico/dotfiles/actions/workflows/lint.yml/badge.svg)](https://github.com/datadelico/dotfiles/actions/workflows/lint.yml)
[![build](https://github.com/datadelico/dotfiles/actions/workflows/build.yml/badge.svg)](https://github.com/datadelico/dotfiles/actions/workflows/build.yml)
[![integration](https://github.com/datadelico/dotfiles/actions/workflows/integration.yml/badge.svg)](https://github.com/datadelico/dotfiles/actions/workflows/integration.yml)
[![Licencia: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Descripción general

Este repositorio contiene un entorno de desarrollo Bash completo y reproducible
para Debian 13 (trixie). Un único comando `make install` en un sistema limpio
instala y configura todas las herramientas, crea los enlaces simbólicos con
GNU Stow y deja el entorno listo para uso diario.

Está diseñado para:

- Estaciones de trabajo de desarrollo Linux modernas
- Administración de servidores SSH
- Homelabs y entornos reproducibles
- Publicación pública en GitHub y mantenimiento a largo plazo

---

## Características

| Categoría | Herramientas |
| --- | --- |
| **Shell** | Bash, bash-completion, prompt Starship |
| **Búsqueda difusa** | fzf, zoxide |
| **Listado de archivos** | eza (reemplazo moderno de ls) |
| **Visor de archivos** | bat (Debian: batcat) |
| **Búsqueda** | ripgrep (rg), fd (Debian: fdfind) |
| **Terminal** | Alacritty, tmux, Zellij |
| **Interfaz Git** | lazygit |
| **Interfaz Docker** | lazydocker |
| **Docker** | Docker CE, Docker Rootless |
| **Git** | git, gh (GitHub CLI) |
| **IDE** | VSCodium (opcional) |
| **Fuentes** | HackGen Console NF (Nerd Font) |
| **Iconos** | Tema de iconos Papirus |
| **Calidad** | ShellCheck, shfmt |
| **Monitoreo** | htop, btop |

---

## Arquitectura

```
dotfiles/
├── config/versions.sh       ← definiciones centralizadas de versiones
├── dotfiles/                ← paquetes GNU Stow (enlazados simbólicamente en $HOME)
│   ├── bash/                ← .bashrc, .bash_profile, .inputrc, aliases, funciones
│   ├── starship/            ← starship.toml
│   ├── alacritty/           ← alacritty.toml
│   ├── tmux/                ← tmux.conf
│   └── zellij/              ← config.kdl
├── install/                 ← scripts de instalación por fases (00–05)
├── scripts/                 ← instaladores de binarios + docker rootless
├── tests/                   ← tests BATS: unitarios, integración y smoke
├── docker/                  ← Dockerfile, docker-compose.yml, script de test
├── .github/workflows/       ← CI/CD: lint, build, test, integration, release
└── docs/                    ← documentación completa (inglés y español)
```

### Estrategia de enlace de dotfiles

GNU Stow replica la estructura de directorios de cada paquete en `$HOME`.
Ejecutar `make install` llama a `stow --restow` para cada paquete, lo cual
es idempotente: se puede ejecutar múltiples veces sin romper nada.

### Fases de instalación

| Fase | Script | Descripción |
| --- | --- | --- |
| 00 | `install/00-core.sh` | Paquetes apt básicos |
| 01 | `install/01-repos.sh` | Repositorios apt externos (gh, Docker CE) |
| 02 | `install/02-binaries.sh` | Binarios externos con verificación de checksum |
| 03 | `install/03-fonts.sh` | HackGen Nerd Font |
| 04 | `install/04-stow.sh` | Symlinks de GNU Stow |
| 05 | `install/05-shell.sh` | PATH e inicialización de submódulos git |

---

## Requisitos

- Debian 13 (trixie)
- Bash 5+
- Una cuenta de usuario con privilegios `sudo`
- Acceso a internet para descargar paquetes y binarios

---

## Instalación

### Inicio rápido

```bash
git clone https://github.com/datadelico/dotfiles.git ~/dotfiles
cd ~/dotfiles
make install
```

Inicia una nueva sesión de shell para aplicar todos los cambios:

```bash
exec bash
```

### Verificar la instalación

```bash
make smoke
```

### Opcional: VSCodium

Para instalar también VSCodium (editor GUI — no incluido en la instalación
predeterminada):

```bash
INSTALL_VSCODIUM=1 bash install/01-repos.sh
```

### Opcional: Docker Rootless

Después de la instalación principal, configura Docker para ejecutarse sin root:

```bash
make setup-docker-rootless
```

Consulta [docs/es/docker.md](docs/es/docker.md) para todos los detalles.

---

## Actualización

Para actualizar todos los binarios instalados externamente a las versiones en
`config/versions.sh`:

```bash
# Edita config/versions.sh con los nuevos números de versión, luego:
make update
```

Para actualizar los paquetes apt:

```bash
sudo apt-get update && sudo apt-get upgrade
```

---

## Comandos `make` disponibles

```
make help                    Muestra todos los targets
make install                 Instalación completa (fases 00–05)
make update                  Actualiza binarios externos
make test                    Ejecuta tests BATS (unitarios + integración)
make smoke                   Ejecuta smoke tests (verificaciones rápidas)
make lint                    Ejecuta ShellCheck + shfmt + markdownlint
make format                  Formatea scripts shell con shfmt
make docker-build            Construye la imagen Docker de test
make docker-test             Ejecuta tests dentro de Docker
make clean                   Elimina los symlinks de GNU Stow
make setup-docker-rootless   Configura el modo Docker Rootless
make install-fonts           Instala solo la fuente HackGen Nerd Font
```

---

## Flujo de tests con Docker para cambios futuros

Usa el entorno de tests Docker antes de abrir un pull request o subir cambios
que afecten a scripts de instalación, dotfiles, configuración de shell o tests
de CI. El contenedor parte de una imagen limpia de Debian 13, ejecuta
`make install`, aplica los dotfiles con GNU Stow y después ejecuta smoke tests,
tests unitarios y tests de integración.

### 1. Construir la imagen Docker de test

```bash
make docker-build
```

Esto construye la imagen `dotfiles-test:latest` usando `docker/Dockerfile`.

### 2. Ejecutar todos los tests dentro de Docker

```bash
make docker-test
```

Esto ejecuta la suite completa mediante `docker/docker-compose.yml`:

1. Smoke tests: comprobaciones de binarios y symlinks
2. Tests unitarios BATS
3. Tests de integración BATS

Una ejecución correcta debería terminar con:

```text
All Docker tests passed.
```

### 3. Reconstruir desde cero al depurar problemas de instalación

Si cambiaste scripts de instalación o quieres evitar capas cacheadas de Docker,
reconstruye sin caché:

```bash
docker build --no-cache --file docker/Dockerfile --tag dotfiles-test:latest .
docker compose --file docker/docker-compose.yml run --rm dotfiles-test
```

### 4. Abrir una shell interactiva en el contenedor de test

Úsalo cuando falle un test y necesites inspeccionar el entorno instalado:

```bash
docker compose --file docker/docker-compose.yml run --rm dotfiles-shell
```

Comprobaciones útiles dentro del contenedor:

```bash
echo "$PATH"
command -v starship lazygit lazydocker zellij tmux
bash tests/smoke/smoke.sh
bats --recursive tests/unit
bats --recursive tests/integration
```

### 5. Limpiar contenedores e imagen de test

```bash
docker compose --file docker/docker-compose.yml down --remove-orphans
docker image rm dotfiles-test:latest
```

### Checklist recomendado antes de hacer push

Antes de subir cambios, ejecuta:

```bash
make lint
make test
make docker-test
```

Si `make docker-test` pasa, el repositorio debería estar cerca del mismo entorno
limpio de Debian usado por CI.

---

## Descripción de herramientas

### Prompt Starship

[Starship](https://starship.rs) es un prompt rápido y multiplataforma. La
configuración en `dotfiles/starship/.config/starship.toml` proporciona:

- Prompt multilínea
- Ruta absoluta completa (sin truncación)
- Rama y estado de git
- Duración del comando (para comandos de más de 2 segundos)
- Indicador SSH: el nombre del host se muestra en amarillo y aparece la
  etiqueta `SSH` en el prompt derecho cuando `SSH_CONNECTION` está definida
- Indicador de root: el nombre de usuario se muestra en rojo al ejecutar como root
- Iconos Nerd Font en todo el prompt

### fzf

[fzf](https://github.com/junegunn/fzf) proporciona búsqueda difusa de archivos
e historial. Atajos de teclado disponibles tras cargar `.bashrc`:

- `Ctrl+R` — búsqueda difusa en el historial
- `Ctrl+T` — buscador difuso de archivos
- `Alt+C` — cd difuso

### zoxide

[zoxide](https://github.com/ajeetdsouza/zoxide) aprende tus directorios más
visitados. Usa `z <nombre-parcial>` para saltar a cualquier lugar al instante.

### eza

[eza](https://github.com/eza-community/eza) es un reemplazo moderno de `ls`.
Los aliases `ls`, `ll`, `la`, `lt` y `lta` se configuran automáticamente.

### bat

[bat](https://github.com/sharkdp/bat) es un clon de `cat` con resaltado de
sintaxis. En Debian el binario se llama `batcat`; el alias `bat='batcat'` se
define automáticamente en `aliases.sh`.

### ripgrep / fd

[ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) y
[fd](https://github.com/sharkdp/fd) son alternativas más rápidas a `grep` y
`find`. En Debian, `fd` se instala como `fdfind`; el alias `fd='fdfind'` se
define automáticamente.

### lazygit

[lazygit](https://github.com/jesseduffield/lazygit) es una interfaz de terminal
para git. Usa el alias `lg` para iniciarlo.

### lazydocker

[lazydocker](https://github.com/jesseduffield/lazydocker) es una interfaz de
terminal para Docker. Usa el alias `lzd` para iniciarlo.

---

## Uso con SSH

Al conectarse a un servidor remoto por SSH, el prompt Starship automáticamente:

1. Muestra el nombre del host en amarillo junto al nombre de usuario
2. Muestra la etiqueta `SSH` en el prompt derecho
3. Mantiene visible la ruta absoluta completa

La configuración utiliza la variable de entorno estándar `SSH_CONNECTION`, que
es definida por el daemon SSH en todos los servidores OpenSSH estándar.

Consulta [docs/es/ssh.md](docs/es/ssh.md) para la guía completa de
configuración SSH.

---

## Uso de Docker

### Docker estándar (con root)

Instalado mediante el repositorio apt oficial de Docker. Se gestiona con el
comando `docker` y se visualiza con `lazydocker` (`lzd`).

### Docker Rootless

Ejecuta el daemon de Docker sin privilegios de root. Configuración:

```bash
make setup-docker-rootless
```

Tras la configuración, `DOCKER_HOST` se define automáticamente en
`~/.bash_profile` cuando existe el socket rootless.

Consulta [docs/es/docker.md](docs/es/docker.md) para todos los detalles.

---

## Notas de seguridad

- Ningún script de instalación usa `curl ... | bash` sin validación previa.
- Todos los binarios externos se descargan desde los GitHub Releases oficiales.
- Los binarios de Starship y Zellij se verifican con checksums SHA-256 antes
  de la instalación.
- Los repositorios apt externos usan claves GPG oficiales ubicadas en
  `/usr/share/keyrings/` (el estándar actual de Debian).
- No se almacenan secretos, credenciales ni claves privadas en este repositorio.

---

## Capturas de pantalla

Consulta [assets/screenshots/README.md](assets/screenshots/README.md) para
las instrucciones sobre cómo capturar capturas de pantalla del entorno
configurado.

---

## Solución de problemas

Consulta [docs/es/troubleshooting.md](docs/es/troubleshooting.md).

---

## Desinstalar

Para eliminar los symlinks de GNU Stow sin borrar el repositorio:

```bash
make clean
```

Esto solo elimina los symlinks. Los archivos originales en `dotfiles/` no
se modifican.

Consulta [docs/es/uninstall.md](docs/es/uninstall.md) para la guía completa
de desinstalación.

---

## Licencia

[MIT](LICENSE) © 2026 datadelico
