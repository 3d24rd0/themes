---
name: theme-craft
description: Create, calibrate, and generate multi-platform developer themes across Ghostty, tmux, Gentle Shell, Fish, Starship, VS Code, and Obsidian.
---

# Theme Craft — Multi-Platform Theme Creation Guide

Use this skill whenever you need to create a new theme or adapt an existing visual palette across the developer workspace tools.

## 1. Visual Ergonomics Contract (Eye Strain & Post-Surgery)

When designing dark themes, never use raw extreme values:
- **Forbidden Black**: `#000000` (causes sudden pupillary dilation, high halation/bloom against white). Always use deep matte slate/obsidian: `#0E0F10`, `#111413`, `#14171A`.
- **Forbidden White**: `#FFFFFF` (harsh blue-light spike). Always use warm parchment, soft ivory, or subdued bone: `#E6E2D8`, `#EDE7EB`, `#F2ECE6`.
- **Bold Attenuation**: Standard `Bold` text radiates too much photon mass on dark backgrounds. Always configure `SemiBold` or `font-style-bold = SemiBold` in terminal emulators.
- **Background-to-Text Contrast on Tabs**: When styling status bars (e.g. tmux active window), never place white/light text on a yellow/gold/cyan background. Always invert to dark background color (`#0E0F10,bold`).

---

## 2. Palette Specification Template

Each theme requires 8 core semantic tokens:

1. `bg_base`: Deep matte dark background (`#0E0F10`).
2. `bg_panel`: Surface / card background for UI panels (`#151719`).
3. `fg_text`: Primary body text (`#E6E2D8`).
4. `accent_primary`: Main signature accent / keywords / highlights (`#E5CF77`).
5. `accent_secondary`: Secondary accent / types / functions (`#358075` / `#638BA4`).
6. `success`: Green for strings, additions, and success indicators (`#447A66`).
7. `error`: Red for deletions, warnings, and errors (`#C43F38`).
8. `muted`: Dim commentary and unobtrusive metadata (`#5C605E`).

---

## 3. Required Outputs per Theme

A complete theme folder under `themes/<slug>/` MUST generate:

### A. Ghostty (`themes/<slug>/ghostty/<slug>`)
```ini
background = #0e0f10
foreground = #e6e2d8
cursor-color = #e5cf77
cursor-text = #0e0f10
selection-background = #2c281e
selection-foreground = #e6e2d8

palette = 0=#0e0f10
palette = 1=#c43f38
palette = 2=#3f6d5b
palette = 3=#d4b260
palette = 4=#4a6b82
palette = 5=#8a6e9a
palette = 6=#358075
palette = 7=#d5d0c5

palette = 8=#222426
palette = 9=#e26252
palette = 10=#568c76
palette = 11=#e5cf77
palette = 12=#638ba4
palette = 13=#ad8fc0
palette = 14=#4abda3
palette = 15=#f2ece6
```

### B. tmux (`themes/<slug>/tmux/{palette.sh,default.sh}`)
- `palette.sh`: Exports individual hex variables.
- `default.sh`: Maps semantic variables (`text`, `bg_bar`, `bg_pane`, `selection`, `highlight`, `info`, `error`).

### C. Gentle Shell (`themes/<slug>/gentle-shell/<Slug>.json`)
Full interactive theme conforming to Pi schema with `vars` and `colors`.

### D. Fish Shell (`themes/<slug>/fish/<slug>.fish`)
Syntax highlighting commands (`fish_color_command`, `fish_color_quote`, `fish_color_param`, etc.).

### E. Starship (`themes/<slug>/starship/starship-<slug>.toml`)
Defines `[palettes.<slug>]` and thematic prompt icon in `[character]`.

### F. VS Code (`themes/<slug>/vscode/settings.json`)
Defines `"workbench.colorCustomizations"` for editor, sidebar, activity bar, and terminal.

### G. Obsidian (`themes/<slug>/obsidian/<slug>.css`)
CSS snippet defining `.theme-dark` variables: `--color-base-00` through `--color-base-40`, `--text-normal`, `--interactive-accent`, headers (`--h1-color` .. `--h6-color`), and tags.

---

## 4. Verification & Installation

After generating the files:
1. Update root `README.md` catalog table.
2. Test installation via the Dart CLI:
   ```bash
   dart run bin/themes.dart apply <slug>
   ```
