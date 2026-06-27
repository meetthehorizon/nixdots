# System Management Scripts (`scripts/`)

This directory houses helper and maintenance shell scripts utilized to configure the system, bootstrap credentials, and dynamically switch styles.

## Script Details

- [bootstrap-secrets.sh](file:///home/conart/nixdots/scripts/bootstrap-secrets.sh):
  - Used when setting up the system on a new machine.
  - Generates SSH keys and prompts for GitHub Personal Access Tokens (PAT).
  - Encrypts generated secrets to `secrets/github-ssh-key.age` and `secrets/github-pat.age` using the SOPS/age master recovery key.
- [set-theme.sh](file:///home/conart/nixdots/scripts/set-theme.sh):
  - Dynamically updates active desktop backgrounds.
  - Writes wall and lock screens to `~/.cache/theme/` for instant integration in locks and status outputs.
  - Refreshes the Wayland wallpaper daemon (`awww`) with transition effects.

## Usage

Ensure scripts have executive permissions before running:
```bash
chmod +x scripts/set-theme.sh
```
