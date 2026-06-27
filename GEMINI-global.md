# Global Gemini Coding Conventions & Preferences

This file serves as a global memory of programming standards, preferences, and guidelines for AI agents working on any of my projects.

## Programming Language Preferences & Conventions

### 1. Nix / NixOS
- **Formatting**: Format Nix files using `nixfmt-rfc-style` or standard conventions.
- **Modularity**: Prefer splitting configurations into self-contained modules under `modules/` and importing them in `default.nix`.
- **Options**: Always prefer using higher-level configuration options (like `programs.firefox.policies` or `services.syncthing`) instead of creating custom low-level services unless absolutely necessary.
- **Safety**: Do not use `sudo` commands directly inside script tasks; always ask the user to run commands needing privileges.

### 2. Styling & Web Development (HTML/CSS/JS)
- **CSS**: Prefer vanilla CSS with custom properties (CSS variables) for modern, cohesive themes. Avoid utility frameworks like Tailwind CSS unless explicitly requested.
- **Aesthetics**: Coding output for web layouts should look polished, modern, and high-quality (e.g. use HSL palettes, smooth animations, dark modes, clean typography).

## Git Commit Conventions
- Use descriptive, semantic commit messages (e.g., `feat: ...`, `fix: ...`, `docs: ...`, `refactor: ...`).

## General Collaboration Style
- Keep explanations concise and highlight file/code symbols as clickable links.
- When configuring systemd user services, place target constraints inside `Install.WantedBy` rather than using NixOS-specific top-level properties.
