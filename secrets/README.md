# Secrets Management (`secrets/`)

This directory stores encrypted credentials used during system installations and rebuilds.

## Content Files

- [secrets.nix](file:///home/conart/nixdots/secrets/secrets.nix): Declares age public keys for authorized host systems and master recovery configurations.
- [github-pat.age](file:///home/conart/nixdots/secrets/github-pat.age): Encrypted file containing the GitHub Personal Access Token (PAT). Decrypts to `~/.config/gh/github-pat`.
- [github-ssh-key.age](file:///home/conart/nixdots/secrets/github-ssh-key.age): Encrypted file containing the main user SSH private key. Decrypts to `~/.ssh/id_ed25519`.

## Operational Notes

We utilize **agenix** for secret handling.
- Host configurations specify SSH keys (`/etc/ssh/ssh_host_ed25519_key`) and recovery keys (`~/.config/sops/age/keys.txt`) to dynamically decrypt secrets during NixOS rebuilds.
- Decrypted outputs are owned by the active user with strict read-only permissions (`0600`).
