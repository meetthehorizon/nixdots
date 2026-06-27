# Global Gemini Coding Conventions & Preferences

> [!IMPORTANT]
> - **GEMINI.md vs. GEMINI-global.md**: `GEMINI.md` is local to the repository and must NOT be edited for global memory/conventions. To update the global memory, you must edit `GEMINI-global.md` in the NixOS config repository at [GEMINI-global.md](file:///home/conart/nixdots/GEMINI-global.md). The NixOS rebuild process automatically updates the global `~/.gemini/GEMINI.md` based on it.

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

## Development & Execution Rules

### 1. Test-Driven Development (TDD)
- For all projects other than this NixOS/dotfiles repository, strictly follow Test-Driven Development (TDD). 
- Write tests based on the requested feature or change, run them to see them fail (red), inform the user about the failure, and then write the code implementation to make them pass (green).

### 2. Execution & Permissions
- Proactively propose and run diagnostic commands (probing system/machine state) and local git commands (modifying local repositories) without asking the user beforehand in chat.
- Always ask for explicit confirmation/permission before executing push commands (such as `git push` or `gh` commands that push remote changes).

### 3. Git Commits & Workflow
- Always commit changes in bite-sized, incremental steps to keep changes readable, structured, and manageable without becoming overwhelmed.
- Use descriptive, semantic commit messages (e.g., `feat: ...`, `fix: ...`, `docs: ...`, `refactor: ...`).

## Documentation Standards

- For repositories authored by the user:
  - Every commit must include an update to the documentation. Keep documentation precise.
  - Every directory must contain documentation providing a high-level overview of its contents, helping both humans and AIs onboard quickly.
  - The root `README.md` must provide quick links and a graph traversal option (e.g., a map, tree, or visual graph) to all repository documentation.
