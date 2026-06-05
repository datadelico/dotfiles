# Guía de Docker

Este documento cubre la instalación de Docker CE, su uso y la configuración
de Docker Rootless.

---

## Instalación de Docker CE

Docker CE se instala durante `make install` (fase `01-repos.sh`). Los paquetes
instalados son:

- `docker-ce` — daemon y CLI de Docker
- `docker-ce-cli` — interfaz de línea de comandos de Docker
- `containerd.io` — runtime de contenedores
- `docker-buildx-plugin` — plugin BuildKit
- `docker-ce-rootless-extras` — archivos de soporte para modo rootless
- `uidmap` — requerido para el modo rootless (mapeo de IDs de usuario)

La clave GPG oficial de Docker se añade a `/etc/apt/keyrings/docker.asc` y
el repositorio queda fijado al canal `stable`.

---

## Uso estándar de Docker

Tras la instalación, Docker se ejecuta como root de forma predeterminada. Tu
usuario debe estar en el grupo `docker` para usar Docker sin `sudo`:

```bash
sudo usermod -aG docker "${USER}"
newgrp docker
```

Verifica:

```bash
docker info
docker run --rm hello-world
```

---

## Modo Docker Rootless

Docker Rootless ejecuta el daemon de Docker completamente sin privilegios de
root. Esto mejora la seguridad al eliminar el riesgo de que una fuga de
contenedor obtenga acceso root en el host.

### Requisitos previos (ya instalados por make install)

- `docker-ce-rootless-extras`
- `uidmap`
- Entradas en `/etc/subuid` y `/etc/subgid` para tu usuario

Verifica si tu usuario tiene entradas subuid/subgid:

```bash
grep "^$(id -un):" /etc/subuid
grep "^$(id -un):" /etc/subgid
```

Si faltan las entradas, pide al administrador del sistema que ejecute:

```bash
sudo usermod --add-subuids 100000-165535 "${USER}"
sudo usermod --add-subgids 100000-165535 "${USER}"
```

### Configuración

```bash
make setup-docker-rootless
```

Esto ejecuta `dockerd-rootless-setuptool.sh install` como tu usuario y habilita
el servicio systemd de usuario.

### Verificar Docker Rootless

```bash
systemctl --user status docker
docker info | grep -i rootless
```

La salida debe incluir `rootless` en la sección de opciones de seguridad.

### DOCKER_HOST

El socket de Docker Rootless está en una ruta diferente al socket root. Tu
`~/.bash_profile` define `DOCKER_HOST` automáticamente cuando el socket existe:

```bash
# Se define automáticamente en ~/.bash_profile:
export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/docker.sock"
```

### Solución de problemas de Rootless

**Problema: `newuidmap` no encontrado**

```bash
sudo apt-get install uidmap
```

**Problema: sin entradas subuid/subgid**

```bash
sudo usermod --add-subuids 100000-165535 "${USER}"
sudo usermod --add-subgids 100000-165535 "${USER}"
```

**Problema: el servicio no arranca**

```bash
systemctl --user status docker
journalctl --user -u docker
```

**Problema: DOCKER_HOST no definida tras reiniciar**

Asegúrate de que `~/.bash_profile` se cargue al iniciar sesión. Los dotfiles
lo configuran automáticamente mediante el `~/.bash_profile` gestionado por Stow.

---

## lazydocker

[lazydocker](https://github.com/jesseduffield/lazydocker) proporciona una
interfaz de terminal para gestionar contenedores, imágenes, volúmenes y redes.

Inicia con:

```bash
lzd
```

lazydocker lee `DOCKER_HOST` automáticamente, por lo que funciona tanto con
Docker estándar como con Docker Rootless.

---

## Docker en CI

El `docker/Dockerfile` de este repositorio construye una imagen de prueba
basada en `debian:trixie-slim`. Instala todos los dotfiles y ejecuta la suite
completa de tests.

Construcción local:

```bash
make docker-build
make docker-test
```

El test de Docker valida:

1. Todos los paquetes apt instalados
2. Todos los binarios externos instalados
3. Todos los symlinks creados por Stow
4. Arranque de Bash sin errores
5. Inicialización de Starship
6. Idempotencia de la reinstalación

---

## Aliases útiles de Docker

Definidos en `~/.config/bash/aliases.sh`:

| Alias | Comando |
|---|---|
| `dps` | `docker ps` con salida en tabla formateada |
| `dpsa` | `docker ps -a` (incluyendo contenedores detenidos) |
| `dimg` | `docker images` |
| `dprune` | `docker system prune -f` |
| `denter` | Entrada interactiva a un contenedor (con selección fzf) |
