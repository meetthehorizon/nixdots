# horizon - NixOS Dotfiles

NixOS system configuration flake for the host `horizon` using Home Manager, Nixvim, Hyprland, and agenix.

## Architecture & Features

- **OS**: NixOS (using `nixpkgs` stable/unstable release 26.05)
- **WM**: Hyprland (configured via Home Manager)
- **Editor**: Nixvim (Neovim configuration packaged inside Nix)
- **Terminal**: Kitty & Zsh
- **Secrets Management**: `agenix` (using age for decrypting SSH keys and GitHub PATs dynamically at boot/rebuild time)

---

## Secrets Management & Bootstrapping

We use `agenix` to securely handle credentials (like your SSH private key and GitHub PAT) without checking plaintext secrets into a public Git repository.

Plaintext credentials are kept in the gitignored `.secrets/` directory during setup.

### How to Bootstrap (New Keys/Tokens)

If you want to set up this system with **brand-new** credentials:

1. Clone this repository.
2. Run the bootstrap script:
   ```bash
   ./scripts/bootstrap-secrets.sh
   ```
   * This script will:
     - Generate a master recovery age key at `~/.config/sops/age/keys.txt`.
     - Generate a new SSH key pair inside `.secrets/`.
     - Ask you to enter a GitHub Personal Access Token (PAT) and save it to `.secrets/github-pat`.
     - Encrypt the SSH private key and PAT into `secrets/github-ssh-key.age` and `secrets/github-pat.age`.
3. Commit the newly generated encrypted `.age` files in the `secrets/` directory.
4. Run your rebuild alias to switch configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#horizon
   ```
5. Register your new SSH key with GitHub using the GitHub CLI:
   ```bash
   GITHUB_TOKEN=$(cat ~/.config/gh/github-pat) gh ssh-key add .secrets/id_ed25519.pub --title "Horizon NixOS"
   ```

---

### How to Restore (Using Existing Keys)

If you are reinstalling NixOS or deploying to a new system and want to **restore your existing credentials**:

1. Clone this repository.
2. Copy your previously backed up `keys.txt` recovery key file to `~/.config/sops/age/keys.txt`.
3. Apply the system configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#horizon
   ```
4. **Done!** `agenix` will automatically decrypt your existing SSH private key and GitHub Personal Access Token directly to `~/.ssh/id_ed25519` and `~/.config/gh/github-pat`.
