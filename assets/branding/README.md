# Branding

This directory is reserved for branding assets.

---

## What belongs here

- Repository logo or badge (SVG preferred)
- Social preview image used by GitHub (`og:image`)
- Any custom badge artwork

---

## GitHub social preview

GitHub displays a `1280x640px` social preview image on repository cards and
link previews. To set one:

1. Place a `social-preview.png` (1280x640, PNG) in this directory.
2. Go to the repository **Settings** → **Social preview** → upload the image.

---

## Generating a social preview

A simple social preview can be created with ImageMagick:

```bash
# Example: plain text on a Dracula-themed background
convert \
    -size 1280x640 \
    xc:"#282a36" \
    -font "HackGen-Console-NF" \
    -pointsize 72 \
    -fill "#f8f8f2" \
    -gravity Center \
    -annotate 0 "dotfiles\nDebian 13 · Bash · GNU Stow" \
    assets/branding/social-preview.png
```

---

## Assets naming convention

- `logo.svg` — repository icon
- `social-preview.png` — GitHub/social media preview (1280x640)
- `badge-*.svg` — custom badges
