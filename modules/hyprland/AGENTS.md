# AGENTS.md — modules/hyprland

> Hyprland compositor configuration. Since Hyprland 0.55+, config format is
> **Lua** (the old `hyprlang` format is deprecated). This project uses
> home-manager's `wayland.windowManager.hyprland` module with `configType = "lua"`.
>
> **References:** [Hyprland Wiki](https://wiki.hypr.land/),
> [Hyprland on Home Manager](https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/),
> [hl.* Lua API](https://alejandrominaya.github.io/hyprland-lua-docs/)

## 1. File Map

```
modules/hyprland/
├── config.nix          # Core settings: general, decoration, input, monitors, autostart
├── binds.nix           # Keybinds (hl.dsp.*, hl.exec_cmd)
├── window-rules.nix    # Layer rules, window rules
├── lock.nix            # hyprlock screen locker
├── shot.nix            # hyprshot screenshot tool
├── sunset.nix          # hyprsunset night light (systemd user service)
└── AGENTS.md           # This file
```

## 2. Mechanical Invariants

1. **Lua config only.** `configType = "lua"` is set in `config.nix`. Never
   revert to hyprlang. All bind/dispatch/monitor/rule values must be valid
   Lua expressions.
2. **Use `makeLuaCode` for structured Lua tables.** The helper (defined in
   `config.nix` and `binds.nix`) wraps Nix attrsets into `hl.*()` Lua
   function calls via `lib.generators.mkLuaInline`. This is the project's
   bridge between Nix type-safety and Hyprland's Lua API. Follow the pattern:
   ```nix
   makeLuaCode [
     [
       ''mod .. " + KEY"''
       ''hl.dsp.exec_cmd("command")''
       { description = "What it does"; }
     ]
   ]
   ```
3. **Design tokens via `config.color`, `config.ui`, `config.font`.** Never
   hardcode hex colors, spacing, radii, or fonts. Use the `toRGB` helper
   (`lib.removePrefix "#" hex`) to convert hex tokens to `rgb()` format
   required by Hyprland's Lua API.
4. **Variables use `_var` suffix.** `mod._var`, `terminal._var`,
   `launcher._var`, `browser._var` — these are home-manager's mechanism for
   setting Hyprland `$variables` that are available in Lua string
   interpolation.
5. **Systemd integration is mandatory.** `systemd.enable = true` and
   `systemd.variables = ["--all"]` ensure DBus environment propagation to
   systemd user services (required for hyprsunset, hyprlock, quickshell).
6. **Package pinning via null.** `package = null; portalPackage = null;`
   means Hyprland and xdg-desktop-portal-hyprland come from the NixOS module,
   not home-manager — prevents version mismatches.

## 3. Keybind Conventions

- **Mod key:** `mod` (a Hyprland `$mod` variable, set to `SUPER` in config.nix).
  Never hardcode `SUPER`.
- **Descriptions mandatory.** Every bind must have `{ description = "..." }`.
  These show up in the Hyprland keybind overlay and are used by which-key
  in nixvim.
- **Media keys:** `XF86Audio*` and `XF86MonBrightness*` bindings have
  `locked = "true"` and `repeating = "true"` where appropriate.
- **Workspace binds generated programmatically** via `builtins.genList` (1-10).
  Workspace 10 uses key `0`. Move-to-workspace uses `SHIFT` modifier.
- **Mouse binds** use `mouse:272` (move) and `mouse:273` (resize) with
  `mouse = true`.

## 4. Autostart (`hl.on("hyprland.start", ...)`)

Defined in `config.nix` via `extraConfig`. The startup sequence:
1. `dbus-update-activation-environment --systemd --all` — environment propagation
2. `rog-control-center` — ASUS hardware control (silent)
3. `hyprctl setcursor` — cursor theme from design tokens
4. App launches to specific workspaces (terminal→1, browser→2, terminal→3, spotify→4)
5. Focus workspace 3 (default landing workspace)

## 5. Component-Specific Notes

- **hyprlock** (`lock.nix`): Uses `programs.hyprlock` home-manager module.
  References design tokens for colors, fonts, and assets (lock screen image,
  user icon).
- **hyprshot** (`shot.nix`): `programs.hyprshot` with save location set to
  `~/Pictures/Screenshot`.
- **hyprsunset** (`sunset.nix`): Systemd user service, `WantedBy` forced to
  empty list (`lib.mkForce []`) to prevent auto-start — toggled manually
  via `mod + N`.
- **window-rules** (`window-rules.nix`): Currently minimal (waybar blur rule).
  Use `hl.window_rule()` Lua API for new rules — see the Hyprland Wiki's
  [Window Rules](https://wiki.hypr.land/Configuring/Window-Rules/) page.

## 6. Common Pitfalls

- **`rgb()` vs hex:** Hyprland's Lua API requires `rgb(RRGGGBB)` format
  (no `#`). The `toRGB` helper handles this.
- **Lua string quoting:** Inside `makeLuaCode`, strings passed to
  `hl.dsp.exec_cmd()` need double-quotes around the command because they're
  already inside Lua single-quoted string delimiters from `mkLuaInline`.
- **Module reload:** Hyprland auto-reloads config on save, but systemd
  services (hyprsunset) need a manual `systemctl --user restart`.
- **Workspace focus vs move:** Focus (`hl.dsp.focus({ workspace = "X" })`)
  switches view; move (`hl.dsp.window.move({ workspace = "X" })`) sends
  the window. Don't confuse them.

## 7. When Adding a New Feature

1. Identify which file it belongs to (binds, config, or a new module)
2. If it's a new file, import it in `default.nix`
3. Reference design tokens — never hardcode
4. Test: `home-manager build --flake .#conart@horizon`
5. Commit with `hyprland:` prefix
