# Troubleshooting

Common issues and their solutions.

---

## Installation issues

### `make install` fails at `00-core.sh`

**Symptom:** `apt-get: command not found` or `sudo: command not found`

**Solution:** You must be on a Debian/Ubuntu-based system with `sudo` installed.

```bash
su -
apt-get install sudo
usermod -aG sudo "${USER}"
exit
# Log out and back in, then retry
make install
```

---

### `stow: command not found`

**Symptom:** Phase `04-stow.sh` fails because `stow` is not installed.

**Solution:** Re-run the core install phase:

```bash
bash install/00-core.sh
bash install/04-stow.sh
```

---

### Stow conflict: existing file is not a symlink

**Symptom:**

```text
WARNING! stow: [file] is not owned by stow
```

Stow refuses to overwrite a file that was not created by Stow. You must
rename or remove the conflicting file manually:

```bash
mv ~/.bashrc ~/.bashrc.backup
bash install/04-stow.sh
```

---

### `sha256sum` verification fails for a binary

**Symptom:** The checksum verification step in an installer script fails.

**Solution:** The downloaded file may be corrupt or the version in
`config/versions.sh` does not match what is on GitHub. Clean up and retry:

```bash
# Remove any partial downloads
rm -f /tmp/tmp.*/*.tar.gz 2>/dev/null

# Verify the version in config/versions.sh matches an actual GitHub release
cat config/versions.sh
```

---

## Prompt issues

### Starship not loading

**Symptom:** The Starship prompt does not appear after starting Bash.

**Check 1:** Is starship in `PATH`?

```bash
which starship
# Expected: ~/.local/bin/starship
```

If not found, run:

```bash
bash scripts/install-starship.sh
source ~/.bash_profile
```

**Check 2:** Is `~/.local/bin` in `PATH`?

```bash
echo "${PATH}" | tr ':' '\n' | grep local
```

If not, source your profile:

```bash
source ~/.bash_profile
```

---

### Icons appear as boxes or question marks

**Cause:** The terminal is not using a Nerd Font or the font is not installed.

**Solution:**

1. Verify HackGen Nerd Font is installed:

   ```bash
   fc-list | grep -i hackgen
   ```

   If nothing appears, run:

   ```bash
   make install-fonts
   ```

2. Configure your terminal emulator to use `HackGen Console NF`.

---

### `bat` command not found

**Cause:** On Debian, `bat` is installed as `batcat`. The alias `bat='batcat'`
is defined in `~/.config/bash/aliases.sh`, but it may not have loaded.

**Solution:**

```bash
source ~/.bashrc
which bat   # should now point to the alias
```

---

### `fd` command not found

**Cause:** On Debian, `fd` is installed as `fdfind`. The alias `fd='fdfind'`
is defined in `~/.config/bash/aliases.sh`.

**Solution:**

```bash
source ~/.bashrc
fd --version
```

---

## fzf not working

**Symptom:** `Ctrl+R` does not open the fuzzy history search.

**Check:** Are the fzf key bindings loaded?

```bash
grep -i fzf ~/.bashrc
# Should show: source /usr/share/doc/fzf/examples/key-bindings.bash
```

Reload:

```bash
source ~/.bashrc
```

---

## zoxide not working

**Symptom:** `z` command not found.

**Check:**

```bash
grep zoxide ~/.bashrc
# Should show: eval "$(zoxide init bash)"
```

Verify `zoxide` is installed:

```bash
zoxide --version
```

If not installed:

```bash
sudo apt-get install zoxide
```

---

## Docker Rootless issues

See [docker.md](docker.md) for Docker Rootless troubleshooting.

---

## Git submodules missing (BATS tests fail)

**Symptom:** BATS tests fail with `load: bats-support not found`

**Solution:**

```bash
git submodule update --init --recursive
# or
make submodules
```

---

## Reporting a bug

Open an issue on GitHub:
[https://github.com/datadelico/dotfiles/issues](https://github.com/datadelico/dotfiles/issues)

Include:

- Debian version: `cat /etc/os-release`
- Bash version: `bash --version`
- Output of `make smoke`
- The full error message
