# Guía de desinstalación

Este documento cubre cómo eliminar componentes individuales o toda la
instalación de dotfiles.

---

## Eliminar solo los symlinks de GNU Stow

Para eliminar todos los symlinks creados por Stow manteniendo el repositorio
y tus archivos originales intactos:

```bash
make clean
```

Esto ejecuta `stow --delete` para cada paquete de dotfiles (bash, starship,
alacritty, tmux, zellij). Los archivos de configuración reales permanecen en
`dotfiles/` — solo se eliminan los symlinks de `$HOME`.

---

## Eliminar paquetes individuales de dotfiles

Para desvincular solo un paquete específico:

```bash
stow --dir=dotfiles/ --target="${HOME}" --delete bash
stow --dir=dotfiles/ --target="${HOME}" --delete starship
stow --dir=dotfiles/ --target="${HOME}" --delete alacritty
stow --dir=dotfiles/ --target="${HOME}" --delete tmux
stow --dir=dotfiles/ --target="${HOME}" --delete zellij
```

---

## Eliminar los binarios externos

Estos binarios fueron instalados en `~/.local/bin`:

```bash
rm -f ~/.local/bin/starship
rm -f ~/.local/bin/lazygit
rm -f ~/.local/bin/lazydocker
rm -f ~/.local/bin/zellij
```

---

## Eliminar las fuentes

```bash
rm -rf ~/.local/share/fonts/HackGenNF
fc-cache -f ~/.local/share/fonts
```

---

## Eliminar los paquetes apt

Para desinstalar los paquetes apt que este proyecto añadió:

```bash
sudo apt-get remove --purge \
    build-essential curl file fontconfig git gnupg iproute2 \
    unzip wget tar jq chafa bash-completion openssh-client htop btop \
    stow fzf zoxide eza bat fd-find ripgrep tmux alacritty \
    shellcheck shfmt papirus-icon-theme gh \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin \
    docker-ce-rootless-extras uidmap
```

Eliminar los archivos de repositorios apt externos:

```bash
sudo rm -f /etc/apt/sources.list.d/github-cli.list
sudo rm -f /etc/apt/sources.list.d/docker.list
sudo rm -f /etc/apt/sources.list.d/vscodium.list
sudo rm -f /usr/share/keyrings/githubcli-archive-keyring.gpg
sudo rm -f /etc/apt/keyrings/docker.asc
sudo rm -f /usr/share/keyrings/vscodium-archive-keyring.gpg
sudo apt-get autoremove
sudo apt-get update
```

---

## Eliminar Docker Rootless

Si Docker Rootless fue configurado:

```bash
dockerd-rootless-setuptool.sh uninstall
systemctl --user disable docker
systemctl --user stop docker
```

---

## Eliminar VSCodium (si está instalado)

```bash
sudo apt-get remove --purge codium
sudo rm -f /etc/apt/sources.list.d/vscodium.list
sudo rm -f /usr/share/keyrings/vscodium-archive-keyring.gpg
sudo apt-get update
```

---

## Eliminar el repositorio

```bash
cd ~
rm -rf ~/dotfiles
```

---

## Restaurar la configuración de shell anterior

Si hiciste una copia de seguridad de tu `.bashrc` original antes de la instalación:

```bash
cp ~/.bashrc.backup ~/.bashrc
```

Si no se hizo ninguna copia de seguridad, Debian proporciona una plantilla
predeterminada de `.bashrc`:

```bash
cp /etc/skel/.bashrc ~/.bashrc
```
