# Guía de configuración SSH

Este documento cubre el uso de SSH con estos dotfiles: comportamiento del
prompt, gestión de claves y configuración recomendada.

---

## Comportamiento del prompt en sesiones SSH

Al conectarte a un servidor remoto por SSH, Starship muestra automáticamente
contexto adicional para ayudarte a evitar confusiones entre shells locales y remotas.

### Qué cambia en SSH

| Elemento | Local | SSH |
|---|---|---|
| Nombre de usuario | Oculto (usuario normal) | Mostrado en verde |
| Nombre del host | Oculto | Mostrado en amarillo |
| Etiqueta SSH en prompt derecho | No se muestra | `  SSH` visible |
| Ruta | Ruta absoluta completa | Ruta absoluta completa |
| Estado de git | Visible | Visible |

La detección SSH se basa en la variable de entorno `SSH_CONNECTION`, que es
definida por el daemon OpenSSH en cada conexión SSH estándar. No se define en
sesiones de terminal locales.

### Por qué es importante mostrar el hostname

Al administrar múltiples servidores, es fundamental saber siempre en qué
máquina estás operando. La configuración de Starship muestra el nombre del
host inmediatamente después del nombre de usuario en cada sesión SSH, haciendo
imposible confundir una shell root remota con una local.

---

## Gestión de claves SSH

### Generar una nueva clave Ed25519

La función `sshkey` está disponible tras cargar `~/.bashrc`:

```bash
sshkey servidor-trabajo "usuario@workstation"
```

Esto crea:
- `~/.ssh/servidor-trabajo` — clave privada
- `~/.ssh/servidor-trabajo.pub` — clave pública

Las claves Ed25519 son preferibles a las RSA para nuevas implementaciones:
son más pequeñas, más rápidas y más seguras.

### Estructura recomendada para `~/.ssh/config`

```
# Configuración global predeterminada
Host *
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
    AddKeysToAgent yes

# Servidor de trabajo
Host trabajo
    HostName 192.168.1.10
    User admin
    IdentityFile ~/.ssh/servidor-trabajo
    Port 22

# Patrón de jump host
Host interno-*
    ProxyJump bastion
    User admin
    IdentityFile ~/.ssh/clave-interna

Host bastion
    HostName bastion.ejemplo.com
    User admin
    IdentityFile ~/.ssh/clave-bastion
```

---

## Configuración recomendada en el servidor

Para los servidores que administras, añade estos parámetros a `/etc/ssh/sshd_config`:

```
# Deshabilitar autenticación por contraseña — usar solo claves
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes

# Permitir solo claves Ed25519 y ECDSA
PubkeyAcceptedAlgorithms ssh-ed25519,ecdsa-sha2-nistp256

# Limitar el acceso
AllowUsers tu-usuario
LoginGraceTime 30
MaxAuthTries 3

# Registro
LogLevel VERBOSE
```

Recarga tras los cambios:

```bash
sudo systemctl reload sshd
```

---

## Usar tmux en servidores remotos

Al conectarte a un servidor remoto, iniciar una sesión tmux asegura que tu
trabajo sobreviva a desconexiones:

```bash
ssh trabajo
# En el servidor remoto:
tmux new-session -s main
# o reconectar:
tmux attach -t main
```

La configuración de tmux de este repositorio (prefijo `Ctrl+a`) funciona de
manera idéntica en sesiones locales y remotas.

---

## Usar Zellij en servidores remotos

Si Zellij está instalado en el servidor remoto:

```bash
zellij attach main 2>/dev/null || zellij --session main
```

---

## Configuración del agente SSH

Añade a `~/.bash_profile`:

```bash
if [[ -z "${SSH_AUTH_SOCK}" ]]; then
    eval "$(ssh-agent -s)"
fi
ssh-add ~/.ssh/servidor-trabajo 2>/dev/null || true
```

O usa el keyring del sistema (`gnome-keyring-daemon` o `kde-wallet`) que
gestiona el agente automáticamente en sistemas de escritorio.

---

## Verificar la variable SSH_CONNECTION

Puedes verificar que la detección SSH está funcionando:

```bash
# En una sesión local — debe estar vacía
echo "${SSH_CONNECTION:-no establecida}"

# En una sesión SSH — debe mostrar: <ip_cliente> <puerto_cliente> <ip_servidor> <puerto_servidor>
echo "${SSH_CONNECTION}"
```
