# Uninstall Guide

This document covers how to remove individual components or the entire
dotfiles installation.

---

## Remove GNU Stow symlinks only

To remove all symlinks created by Stow while keeping the repository and
your original files intact:

```bash
make clean
```

This runs `stow --delete` for every dotfiles package (bash, starship,
alacritty, tmux, zellij). Your actual configuration files remain in
`dotfiles/` — only the `$HOME` symlinks are removed.

---

## Remove individual dotfiles packages

To unlink a specific package only:

```bash
stow --dir=dotfiles/ --target="${HOME}" --delete bash
stow --dir=dotfiles/ --target="${HOME}" --delete starship
stow --dir=dotfiles/ --target="${HOME}" --delete alacritty
stow --dir=dotfiles/ --target="${HOME}" --delete tmux
stow --dir=dotfiles/ --target="${HOME}" --delete zellij
```

---

## Remove external binaries

These binaries were installed to `~/.local/bin`:

```bash
rm -f ~/.local/bin/starship
rm -f ~/.local/bin/lazygit
rm -f ~/.local/bin/lazydocker
rm -f ~/.local/bin/zellij
```

---

## Remove fonts

```bash
rm -rf ~/.local/share/fonts/HackGenNF
fc-cache -f ~/.local/share/fonts
```

---

## Remove apt packages

To uninstall apt packages that were added by this project:

```bash
sudo apt-get remove --purge \
    build-essential curl file fontconfig git gnupg iproute2 \
    unzip wget tar jq chafa bash-completion openssh-client htop btop \
    stow fzf zoxide eza bat fd-find ripgrep tmux alacritty \
    shellcheck shfmt papirus-icon-theme gh \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin \
    docker-ce-rootless-extras uidmap
```

Remove external apt repository files:

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

## Remove Docker Rootless

If Docker Rootless was configured:

```bash
dockerd-rootless-setuptool.sh uninstall
systemctl --user disable docker
systemctl --user stop docker
```

---

## Remove VSCodium (if installed)

```bash
sudo apt-get remove --purge codium
sudo rm -f /etc/apt/sources.list.d/vscodium.list
sudo rm -f /usr/share/keyrings/vscodium-archive-keyring.gpg
sudo apt-get update
```

---

## Remove the repository

```bash
cd ~
rm -rf ~/dotfiles
```

---

## Restore previous shell configuration

If you backed up your original `.bashrc` before installation:

```bash
cp ~/.bashrc.backup ~/.bashrc
```

If no backup was made, Debian provides a default `.bashrc` template:

```bash
cp /etc/skel/.bashrc ~/.bashrc
```
