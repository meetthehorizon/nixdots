# AGENTS.md — modules/widgets (Waybar)

> Waybar status bar — CSS-styled, JSON-configured. This is the **active**
> bar system (quickshell is currently commented out in `default.nix`).
>
> **References:** [Waybar Wiki](https://github.com/Alexays/Waybar/wiki),
> [home-manager waybar options](https://nix-community.github.io/home-manager/options.html#opt-programs.waybar.enable)

## 1. File Map

```
modules/widgets/
├── default.nix           # Imports waybar.nix (quickshell commented out)
├── waybar.nix            # CSS generation, systemd, config.jsonc symlink
├── waybar.jsonc          # Module layout (JSONC with comments)
└── AGENTS.md             # This file (waybar conventions)
```

## 2. Mechanical Invariants

1. **CSS is generated in Nix, not a standalone file.** `programs.waybar.style`
   is a multi-line Nix string in `waybar.nix`. Design tokens (`config.font`,
   `config.ui`) are interpolated into the CSS at build time. Never create a
   standalone `.css` file.
2. **JSON config is a symlink, not a copy.** `xdg.configFile."waybar/config.jsonc"`
   uses `source = ./waybar.jsonc` — home-manager symlinks it to
   `~/.config/waybar/config.jsonc`. Edit the source at
   `modules/widgets/waybar.jsonc`, never the symlink target.
3. **Design tokens via `config.font`.** Font family, size, and weight are
   injected from `config.json`:
   ```nix
   sans = config.font.sans;
   mono = config.font.mono;
   size = builtins.toString (config.font.size.base + 3);
   weight = builtins.toString config.font.weight.normal;
   ```
4. **Systemd integration is mandatory.** `systemd.enable = true` with
   `systemd.enableDebug = true` for verbose logging.
5. **No javascript.** Use OOP where needed.

## 3. CSS Structure

The style block in `waybar.nix` follows a fixed comment-grouped layout:

```
1. GLOBAL RESETS & FONTS     — `*` selector: font-size, font-family, min-height
2. WINDOW CONFIGURATION      — `window#waybar`: background
3. MODULE LAYOUT             — `.modules-left/center/right`: padding
4. MODULE STYLES             — `#window, #clock, #battery, ...`: glassmorphism
5. INTERACTIVE ELEMENTS      — `:hover` pseudo-classes
6. TOOLTIPS                  — `tooltip`: glassmorphism
7. STATUS INDICATORS         — `.charging, .active, .bat_30, .disabled, ...`
```

**Glassmorphism pattern** (applied to all modules):
```css
#module-name {
  padding: 3px 5px;
  color: white;
  margin: 2px;
  border-radius: 1px;
  border: 0px solid rgba(255, 255, 255, 0.3);
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.06),
    0 6px 20px rgba(0, 0, 0, 0.25);
  background: rgba(0, 0, 0, 1);
  transition: all 120ms ease-out;
}
```

## 4. State Color System

Four semantic color states, consistently applied across modules:

| State | CSS selector pattern | Meaning |
|---|---|---|
| **Green** (good) | `.charging`, `.power-saver` | Positive/active states |
| **Teal** (focus) | `.active`, `#mpris` | Focused/playing states |
| **Yellow** (warning) | `.bat_30`-`.bat_50`, `.discovering`, `.balanced`, `.paused` | Intermediate/warning |
| **Red** (critical) | `.bat_0`-`.bat_20`, `.disabled`, `.disconnected`, `.off`, `.muted`, `.urgent`, `.performance` | Critical/error states |

**Adding a new state:** match the existing pattern — `border-color` and `color`
always use the same hue with `0.3` border alpha and `0.7` text alpha.

## 5. Adding a New Module

1. **Edit `waybar.jsonc`** — add the module to the layout array
   (`.modules-left`, `.modules-center`, or `.modules-right`)
2. **Edit `waybar.nix`** — add the CSS selector to the module style list
   (comma-separated under §4), add hover style under §5, add status
   indicators under §7 if the module has state classes
3. **Test visually:** `home-manager switch --flake .#conart@horizon`,
   then `systemctl --user restart waybar`

## 6. Config Format (waybar.jsonc)

- JSONC (JSON with comments) — trailing commas allowed, `//` comments
- Module configs set `format`, `tooltip`, `interval`, etc.
- Custom modules via `"custom/name"` entries with `exec` scripts
- Position is determined by which array the module appears in
  (`modules-left`, `modules-center`, `modules-right`)

## 7. Common Pitfalls

- **Waybar/config.jsonc is a symlink.** Direct edits to
  `~/.config/waybar/config.jsonc` will be overwritten on the next
  `home-manager switch`. Always edit `modules/widgets/waybar.jsonc`.
- **CSS selector specificity.** Status selectors (e.g., `#battery.bat_30`)
  must appear after the base module selector to override correctly.
- **Font fallback chain.** The `font-family` includes `"Symbols Nerd Font"`
  for icons. If an icon doesn't render, check that the Nerd Font is
  installed.
- **Systemd restart loop.** If waybar crashes on start, systemd will retry
  indefinitely. Check logs: `journalctl --user -u waybar -f`.
- **No hot reload.** Waybar reads config at startup only. After editing
  `waybar.nix`, run `home-manager switch` then `systemctl --user restart waybar`.
