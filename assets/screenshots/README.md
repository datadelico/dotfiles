# Screenshots

This directory contains screenshots of the configured development environment.

---

## How to capture screenshots

### Prerequisites

Complete `make install` and start a new shell session with all tools active.

### Terminal screenshots

Use `scrot`, `gnome-screenshot`, or your compositor's built-in screenshot tool.

For consistent screenshots, set the terminal to full screen using the HackGen
Console NF font at 13pt, with the Dracula color scheme.

### Recommended screenshots to capture

| Filename | Content |
|---|---|
| `prompt-local.png` | Starship prompt in a local session |
| `prompt-ssh.png` | Starship prompt during an SSH session (with hostname + SSH label) |
| `prompt-root.png` | Starship prompt as root (red username) |
| `lazygit.png` | lazygit interface |
| `lazydocker.png` | lazydocker interface |
| `tmux.png` | tmux with multiple panes |
| `zellij.png` | Zellij with multiple panes |
| `fzf.png` | fzf fuzzy file finder |
| `alacritty.png` | Alacritty terminal with the full setup |

### Automated screenshots via Docker

To capture a terminal screenshot in Docker (requires `xvfb`):

```bash
# This is a manual process — automated capture requires a virtual framebuffer
# and screenshot tool installed inside the container.
#
# On a host with a display:
docker run --rm \
    -e DISPLAY="${DISPLAY}" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    dotfiles-test:latest \
    bash -c "alacritty &"
```

Screenshots are excluded from git by the `.gitignore` rule
(`assets/screenshots/*.png`) to keep the repository lightweight. Commit
selectively when you want to include a screenshot in the README.

---

## Screenshot naming convention

- Use lowercase with hyphens: `prompt-local.png`
- Include the tool name: `lazygit.png`, `tmux.png`
- Use PNG format for lossless quality
- Maximum recommended size: 1920x1080

---

## Updating screenshots

Recapture and re-commit screenshots whenever the prompt configuration or
color theme changes significantly.
