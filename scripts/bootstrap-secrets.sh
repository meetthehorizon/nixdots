#!/usr/bin/env bash

set -euo pipefail

# Directories
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SECRETS_DIR="$DOTFILES_DIR/secrets"
AGE_KEY_DIR="$HOME/.config/sops/age"
AGE_KEY_FILE="$AGE_KEY_DIR/keys.txt"

echo "==> Setting up reproducible secrets..."

# 1. Ensure age key directory exists
mkdir -p "$AGE_KEY_DIR"

# 2. Generate age master key if it doesn't exist
if [ ! -f "$AGE_KEY_FILE" ]; then
    echo "==> Generating age master recovery key at $AGE_KEY_FILE..."
    nix shell nixpkgs#age -c age-keygen -o "$AGE_KEY_FILE"
    echo "IMPORTANT: Please backup this key safely! It is your recovery key."
else
    echo "==> Found existing age key at $AGE_KEY_FILE"
fi

# Extract public key from the age key file
USER_AGE_PUB=$(nix shell nixpkgs#age -c age-keygen -y "$AGE_KEY_FILE")
echo "User age public key: $USER_AGE_PUB"

# 3. Get system host SSH public key
SYSTEM_HOST_PUB=""
if [ -f "/etc/ssh/ssh_host_ed25519_key.pub" ]; then
    SYSTEM_HOST_PUB=$(cat /etc/ssh/ssh_host_ed25519_key.pub)
    echo "Found system host SSH public key."
else
    echo "Warning: System host SSH key not found in /etc/ssh/. Encryption will only use age master key."
fi

# 4. Generate user SSH key if it doesn't exist
BOOTSTRAP_SECRETS_DIR="$DOTFILES_DIR/.secrets"
mkdir -p "$BOOTSTRAP_SECRETS_DIR"
USER_SSH_KEY="$BOOTSTRAP_SECRETS_DIR/id_ed25519"
if [ ! -f "$USER_SSH_KEY" ]; then
    echo "==> Generating new SSH key pair for GitHub..."
    ssh-keygen -t ed25519 -C "kshitij.dev@proton.me" -f "$USER_SSH_KEY" -N ""
else
    echo "==> Found existing SSH key at $USER_SSH_KEY"
fi

# 5. Prepare secrets directory and secrets.nix
mkdir -p "$SECRETS_DIR"
SECRETS_NIX="$SECRETS_DIR/secrets.nix"

echo "==> Creating $SECRETS_NIX..."
cat << EOF > "$SECRETS_NIX"
# Auto-generated secrets configuration. Do not edit manually.
let
  userKey = "$USER_AGE_PUB";
  hostKey = "${SYSTEM_HOST_PUB:-}";
  keys = if hostKey != "" then [ userKey hostKey ] else [ userKey ];
in
{
  "github-ssh-key.age".publicKeys = keys;
}
EOF

# 6. Encrypt SSH private key using age directly
echo "==> Encrypting SSH private key..."
AGE_ARGS=("-r" "$USER_AGE_PUB")
if [ -n "$SYSTEM_HOST_PUB" ]; then
    AGE_ARGS+=("-r" "$SYSTEM_HOST_PUB")
fi
nix shell nixpkgs#age -c age "${AGE_ARGS[@]}" -o "$SECRETS_DIR/github-ssh-key.age" "$USER_SSH_KEY"

# 7. Clean up manually created files in ~/.ssh to avoid pollution
echo "==> Cleaning up any manually created SSH files from ~/.ssh to let NixOS manage them..."
rm -f "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ed25519.pub"

echo "==> SSH key successfully encrypted to $SECRETS_DIR/github-ssh-key.age"
echo "==> You can now commit the 'secrets' directory to Git."
