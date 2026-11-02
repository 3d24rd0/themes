# Themes

Universal collection of custom, ergonomic, and eye-friendly themes across my developer ecosystem: **Ghostty**, **tmux**, **Gentle Shell / Pi**, **Fish**, **Starship**, **VS Code**, and **Obsidian**.

Includes a **Dart CLI** for instant multi-tool installation and an **Agent Skill** (`skills/theme-craft`) for generating complete new themes.

## Catalog

| Theme | Inspiration | Dominant Palette | Supported Platforms |
| :--- | :--- | :--- | :--- |
| [**Zelda 40th Anniversary**](themes/zelda-40th) | Switch OLED Zelda Edition / 40º Aniversario Oficial | Deep Matte Obsidian `#0E0F10`, Triforce Gold `#E5CF77`, Zonai Teal `#358075` | Ghostty, tmux, Gentle Shell, Fish, Starship, VS Code, Obsidian |

---

## Quickstart (Dart CLI)

### Prerequisites
- [Dart SDK](https://dart.dev/get-dart) (`brew install dart` on macOS)

### Commands

```bash
# 1. List available themes in the repo
dart run bin/themes.dart list

# 2. Apply a theme to ALL tools at once:
dart run bin/themes.dart apply zelda-40th

# 3. Or apply only to specific targets:
dart run bin/themes.dart apply zelda-40th --ghostty
dart run bin/themes.dart apply zelda-40th --tmux
dart run bin/themes.dart apply zelda-40th --gentle-shell
dart run bin/themes.dart apply zelda-40th --obsidian
```

---

## Creating New Themes (AI Skill)

This repository includes a specialized skill for AI coding assistants:
👉 **[`skills/theme-craft/SKILL.md`](skills/theme-craft/SKILL.md)**

It provides full specifications, visual ergonomics rules (anti-glare, eye strain prevention, proper contrast), and code generation templates for all 7 platforms.

---

## Directory Structure

```text
themes/
├── bin/
│   └── themes.dart                   # Dart CLI for theme management & installation
├── pubspec.yaml                      # Dart package definition
├── skills/
│   └── theme-craft/
│       └── SKILL.md                  # Skill for generating new complete themes
└── themes/
    ├── zelda-40th/
    │   ├── README.md
    │   ├── ghostty/zelda-40th
    │   ├── tmux/{palette.sh,default.sh}
    │   ├── gentle-shell/Zelda-40th.json
    │   ├── fish/zelda-40th.fish
    │   ├── starship/starship-zelda.toml
    │   ├── vscode/settings.json
    │   └── obsidian/zelda-40th.css
    │
    └── <future-theme>/
```

## License

MIT © [Eduardo Martínez](https://github.com/3d24rd0)
