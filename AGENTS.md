# AGENTS.md — nixdots

> A progressive-disclosure guide for coding agents working in this repository.
> This file is a **table of contents**, not an encyclopedia. Detailed docs live
> alongside the modules they describe. Keep this file under ~250 lines.

## 0. What This Repository Is

A single-host NixOS + home-manager dotfiles configuration for `horizon`
(ASUS Zephyrus G14, x86_64-linux). Flake-based. Everything is a module.

- **Host config:** `hosts/horizon/`
- **Hardware quirks:** `hardware/asus-zephyrus-g14/`
- **User (conart):** `users/conart/`
- **Shared modules:** `modules/` — the bulk of the logic
- **Design tokens:** `users/conart/config.json` — color, font, spacing, radii,
  animation durations

## 1. Immutable Rules (Mechanical Invariants)

These are non-negotiable. If you break them the build will fail — and
that's the point.

1. **Every `.nix` file must be valid Nix.** Run `nix flake check` after any
   change to a `.nix` file.
2. **Module imports are always relative.** Use `./foo.nix` or `../../foo`,
   never absolute paths or `<>` angle-bracket paths.
3. **Design tokens come from `config.json`, not hardcoded.** Colors, fonts,
   spacing, radii, and animation durations are never inlined into modules.
   Reference them through the config module (`modules/config/`).
4. **Secrets never touch the working tree.** All secrets are managed through
   `agenix` (`.secrets/*.age`). The `.secrets/` directory is gitignored.
   Secret modules live in `modules/system/secrets.nix` and are imported
   through `modules/config/crpyt.nix`.
5. **Symlinks, not copies, for assets.** `assets/` is symlinked into the home
   directory via `home.file` in `users/conart/home.nix`. Do not create
   duplicate asset directories.
6. **One concern per module file.** A module file configures one program,
   service, or cohesive subsystem. Split when a file crosses ~80 lines.
7. **`git add` new files before any Nix build.** The flake sources itself
   from the git index (`builtins.git`), so any new `.nix` file that hasn't
   been staged with `git add` will cause `home-manager build` and
   `nixos-rebuild` to fail with "is not tracked by Git." After creating a
   new module file, always `git add` it before running `nix flake check`
   or either build command.

## 2. Module Map

```
modules/
├── apps/          # GUI applications (firefox, kitty, obsidian, rofi, spotify, vscode)
├── cli/           # Shell tools (fish, git, fzf, eza, starship, zoxide, direnv, docker)
├── config/        # Cross-cutting config (assets, color, font, gtk, ui tokens, user info, secrets)
├── hyprland/      # Hyprland compositor (binds, config, lock, screenshot, sunset, window-rules)
├── nixvim/        # Neovim via nixvim (plugins live in modules/nixvim/plugins/)
├── services/      # Background daemons (swww, mako, syncthing)
├── system/        # System-level (crypt, playerctl, secrets)
├── tui/           # Terminal UI apps (btop, calcurse, lazygit, yazi, zathura, etc.)
└── widgets/       # Desktop widgets (quickshell/QML bar, waybar fallback)
```

**Adding a new module:**
1. Create the `.nix` file in the appropriate subdirectory
2. Import it in that subdirectory's `default.nix`
3. Run `nix flake check`

**Removing a module:** Delete the file and remove its import. That's it.

## 3. Boring Technology Choices

This project deliberately avoids novelty. Every dependency is chosen for
stability, composability, and high representation in training data.

| Concern | Choice | Why |
|---|---|---|
| OS | NixOS 26.05 | Declarative, reproducible |
| User env | home-manager (release-26.05) | Tracks NixOS release |
| Editor | nixvim (nixos-26.05) | Declarative Neovim config |
| Compositor | Hyprland | Wayland, well-documented |
| Bar | quickshell (QML) | Native-feeling widgets |
| Shell | fish | Modern, scriptable |
| Terminal | kitty | GPU-accelerated, configurable |
| Secrets | agenix | age-encrypted, composable with home-manager |

**When adding a dependency:** prefer what's already in the flake inputs. If
you need something new, add it to `flake.nix` inputs and follow the existing
pattern (`inputs.X.follows = "nixpkgs"`).

## 4. Session Workflow

1. **Start by reading.** Check `git status` and `git log --oneline -5` to
   understand the current state. Read the file you intend to change before
   editing it.
2. **Plan in small steps.** One logical change per commit. If the task is
   complex, break it into sub-tasks and commit after each.
3. **Verify before declaring done.**
   - `git add` any new `.nix` files first (see invariant #7)
   - `nix flake check` — syntax and evaluation
   - For home-manager changes: `home-manager build --flake .#conart@horizon`
   - For NixOS changes: `sudo nixos-rebuild dry-build --flake .#horizon`
4. **Commit with a descriptive message.** Format: `category: what changed`.
   Examples: `cli: add bat as a replacement for cat`, `hyprland: rebind
   Super+Return to kitty`.
5. **Never leave the repo in a broken state.** If you're mid-change and
   something doesn't build, either fix it or `git stash` before handing back.

## 5. Common Patterns

### Adding a new program
```nix
# modules/apps/myapp.nix
{ config, pkgs, ... }:
{
  home.packages = [ pkgs.myapp ];
  # or for system-wide: environment.systemPackages = [ pkgs.myapp ];
}
```
Then import it in `modules/apps/default.nix`.

### Using design tokens
Design tokens flow from `users/conart/config.json` → `modules/config/` modules.
Reference them, don't hardcode:
```nix
# Colors: config.colorScheme.colors.primary
# Fonts: config.fontScheme.sans, config.fontScheme.mono
# Spacing: config.uiScheme.spacing.s4
```
The exact attribute paths depend on how the config module exposes them.
Read `modules/config/` files to see the current bindings.

### Adding a Hyprland keybind
Edit `modules/hyprland/binds.nix`. Use `$mod` (Super), follow the existing
comment groupings.

### Configuring a nixvim plugin
Create or edit a file in `modules/nixvim/plugins/`. Import it in
`modules/nixvim/plugins/default.nix`. Follow the pattern of existing plugin
files — they're thin wrappers around nixvim module options.

## 6. Constraints & Guardrails

- **Python:** Use `uv` for project management when Python tooling is needed.
  This repo itself is Nix, not Python — Python only appears in tooling scripts.
- **Secrets:** Never inline tokens, keys, or passwords. Use agenix
  (`.secrets/*.age` files, encrypted with the host's SSH key).
- **Git:** The `assets/` directory is largely gitignored except for
  `README.md`. Wallpapers, screenshots, and icons are personal data — don't
  version them.
- **Quickshell QML:** The quickshell widget system uses custom components in
  `modules/widgets/quickshell/components/`. Reuse them; don't reinvent
  `Card`, `Chip`, `Icon`, `Label`, `Trigger`.
- **No dead code.** When removing a feature, remove its module file, its
  import, and any related assets. Don't leave commented-out code.
- **flake.lock is committed.** It pins exact revisions. Run `nix flake update
  --commit-lock-file` when updating inputs — and commit the lockfile change
  separately from functional changes.

## 7. Garbage Collection

Periodic cleanup tasks (run when the repo feels heavy):
- Remove unused flake inputs
- Remove modules that aren't imported anywhere
- Consolidate modules that are small (<15 lines) and could be merged
- Check that every `assets/` reference in config still points to a real file

## 8. References

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [home-manager Manual](https://nix-community.github.io/home-manager/)
- [nixvim Documentation](https://nix-community.github.io/nixvim/)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [agenix](https://github.com/ryantm/agenix)
