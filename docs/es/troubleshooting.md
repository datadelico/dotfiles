# Solución de problemas

Problemas comunes y sus soluciones.

---

## Problemas de instalación

### `make install` falla en `00-core.sh`

**Síntoma:** `apt-get: command not found` o `sudo: command not found`

**Solución:** Debes estar en un sistema basado en Debian/Ubuntu con `sudo` instalado.

```bash
su -
apt-get install sudo
usermod -aG sudo "${USER}"
exit
# Cierra sesión y vuelve a entrar, luego reintenta
make install
```

---

### `stow: command not found`

**Síntoma:** La fase `04-stow.sh` falla porque `stow` no está instalado.

**Solución:** Vuelve a ejecutar la fase de instalación básica:

```bash
bash install/00-core.sh
bash install/04-stow.sh
```

---

### Conflicto Stow: el archivo existente no es un symlink

**Síntoma:**

```
WARNING! stow: [archivo] is not owned by stow
```

Stow se niega a sobreescribir un archivo que no fue creado por Stow. Debes
renombrar o eliminar el archivo en conflicto manualmente:

```bash
mv ~/.bashrc ~/.bashrc.backup
bash install/04-stow.sh
```

---

### Fallo en la verificación `sha256sum` para un binario

**Síntoma:** El paso de verificación del checksum en un script instalador falla.

**Solución:** El archivo descargado puede estar corrupto o la versión en
`config/versions.sh` no corresponde a lo que hay en GitHub. Limpia y reintenta:

```bash
# Eliminar descargas parciales
rm -f /tmp/tmp.*/*.tar.gz 2>/dev/null

# Verificar que la versión en config/versions.sh existe en GitHub
cat config/versions.sh
```

---

## Problemas con el prompt

### Starship no se carga

**Síntoma:** El prompt de Starship no aparece al iniciar Bash.

**Verificación 1:** ¿Está starship en el `PATH`?

```bash
which starship
# Esperado: ~/.local/bin/starship
```

Si no se encuentra, ejecuta:

```bash
bash scripts/install-starship.sh
source ~/.bash_profile
```

**Verificación 2:** ¿Está `~/.local/bin` en el `PATH`?

```bash
echo "${PATH}" | tr ':' '\n' | grep local
```

Si no lo está, carga tu perfil:

```bash
source ~/.bash_profile
```

---

### Los iconos aparecen como cuadros o signos de interrogación

**Causa:** El terminal no usa una Nerd Font o la fuente no está instalada.

**Solución:**

1. Verifica que HackGen Nerd Font está instalada:

   ```bash
   fc-list | grep -i hackgen
   ```

   Si no aparece nada, ejecuta:

   ```bash
   make install-fonts
   ```

2. Configura tu emulador de terminal para usar `HackGen Console NF`.

---

### Comando `bat` no encontrado

**Causa:** En Debian, `bat` se instala como `batcat`. El alias `bat='batcat'`
está definido en `~/.config/bash/aliases.sh`, pero puede que no se haya cargado.

**Solución:**

```bash
source ~/.bashrc
which bat   # ahora debería apuntar al alias
```

---

### Comando `fd` no encontrado

**Causa:** En Debian, `fd` se instala como `fdfind`. El alias `fd='fdfind'`
está definido en `~/.config/bash/aliases.sh`.

**Solución:**

```bash
source ~/.bashrc
fd --version
```

---

## fzf no funciona

**Síntoma:** `Ctrl+R` no abre la búsqueda difusa en el historial.

**Verificación:** ¿Están cargados los atajos de teclado de fzf?

```bash
grep -i fzf ~/.bashrc
# Debe mostrar: source /usr/share/doc/fzf/examples/key-bindings.bash
```

Recarga:

```bash
source ~/.bashrc
```

---

## zoxide no funciona

**Síntoma:** Comando `z` no encontrado.

**Verificación:**

```bash
grep zoxide ~/.bashrc
# Debe mostrar: eval "$(zoxide init bash)"
```

Verifica que `zoxide` está instalado:

```bash
zoxide --version
```

Si no está instalado:

```bash
sudo apt-get install zoxide
```

---

## Problemas con Docker Rootless

Consulta [docker.md](docker.md) para la solución de problemas de Docker Rootless.

---

## Submódulos git faltantes (tests BATS fallan)

**Síntoma:** Los tests BATS fallan con `load: bats-support not found`

**Solución:**

```bash
git submodule update --init --recursive
# o
make submodules
```

---

## Reportar un error

Abre un issue en GitHub:
[https://github.com/datadelico/dotfiles/issues](https://github.com/datadelico/dotfiles/issues)

Incluye:
- Versión de Debian: `cat /etc/os-release`
- Versión de Bash: `bash --version`
- Salida de `make smoke`
- El mensaje de error completo
