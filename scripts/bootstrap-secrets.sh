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
INTERACTIVE=false
if [ -t 0 ]; then
    INTERACTIVE=true
fi

confirm() {
    local prompt="$1"
    local reply
    read -p "$prompt [y/N]: " -r reply
    if [[ "$reply" =~ ^[Yy]$ ]]; then
        return 0
    fi
    return 1
}

if [ ! -f "$AGE_KEY_FILE" ]; then
    if [ "$INTERACTIVE" = true ] && confirm "Do you have an existing age master key to restore?"; then
        echo "Please paste your age private key (e.g. AGE-SECRET-KEY-1...):"
        read -r AGE_KEY_INPUT
        
        # Extract the secret key line
        RAW_SECRET_KEY=$(echo "$AGE_KEY_INPUT" | grep -o "AGE-SECRET-KEY-1.*" | tr -d '\r\n ' || echo "")
        
        if [ -z "$RAW_SECRET_KEY" ]; then
            echo "ERROR: Invalid age private key format. Must contain AGE-SECRET-KEY-1..."
            exit 1
        fi
        
        # Write temporary key to run age-keygen -y
        echo "$RAW_SECRET_KEY" > "$AGE_KEY_FILE"
        
        # Generate the public key
        PUB_KEY=$(nix shell nixpkgs#age -c age-keygen -y "$AGE_KEY_FILE")
        
        # Re-write in the standard age-keygen format
        cat << EOF > "$AGE_KEY_FILE"
# public key: $PUB_KEY
$RAW_SECRET_KEY
EOF
        chmod 600 "$AGE_KEY_FILE"
        echo "Age key successfully restored in standard format."
    else
        echo "==> Generating age master recovery key at $AGE_KEY_FILE..."
        nix shell nixpkgs#age -c age-keygen -o "$AGE_KEY_FILE"
        echo "IMPORTANT: Please backup this key safely! It is your recovery key."
    fi
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
    if [ "$INTERACTIVE" = true ] && confirm "Do you have an existing SSH private key to restore?"; then
        echo "Please paste your SSH private key (press Enter, then Ctrl+D when finished):"
        cat > "$USER_SSH_KEY"
        chmod 600 "$USER_SSH_KEY"
        
        echo "Please paste your SSH public key (starts with ssh-ed25519):"
        read -r USER_SSH_PUB
        echo "$USER_SSH_PUB" > "$USER_SSH_KEY.pub"
        echo "SSH key successfully restored."
    else
        echo "==> Generating new SSH key pair for GitHub..."
        ssh-keygen -t ed25519 -C "kshitij.dev@proton.me" -f "$USER_SSH_KEY" -N ""
    fi
else
    echo "==> Found existing SSH key at $USER_SSH_KEY"
fi

# 4.5. Check for GitHub PAT
USER_PAT_FILE="$BOOTSTRAP_SECRETS_DIR/github-pat"
if [ ! -f "$USER_PAT_FILE" ]; then
    if [ -n "${GITHUB_PAT:-}" ]; then
        echo "$GITHUB_PAT" > "$USER_PAT_FILE"
    elif [ "$INTERACTIVE" = true ] && confirm "Do you have a GitHub Personal Access Token (PAT) to configure?"; then
        echo "Please paste your GitHub Classic PAT (should start with ghp_):"
        read -r GITHUB_PAT_INPUT
        echo "$GITHUB_PAT_INPUT" > "$USER_PAT_FILE"
        echo "PAT saved."
    else
        echo "========================================================================="
        echo "ERROR: GitHub PAT not found at $USER_PAT_FILE"
        echo "To continue, please create this file and paste your GitHub PAT inside it."
        echo "Ensure the token has 'repo', 'admin:public_key', and 'workflow' scopes."
        echo "========================================================================="
        exit 1
    fi
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
  "github-pat.age".publicKeys = keys;
}
EOF

# 6. Encrypt SSH private key and GitHub PAT using age directly
echo "==> Encrypting secrets..."
AGE_ARGS=("-r" "$USER_AGE_PUB")
if [ -n "$SYSTEM_HOST_PUB" ]; then
    AGE_ARGS+=("-r" "$SYSTEM_HOST_PUB")
fi

echo "Encrypting SSH key..."
nix shell nixpkgs#age -c age "${AGE_ARGS[@]}" -o "$SECRETS_DIR/github-ssh-key.age" "$USER_SSH_KEY"

echo "Encrypting GitHub PAT..."
nix shell nixpkgs#age -c age "${AGE_ARGS[@]}" -o "$SECRETS_DIR/github-pat.age" "$USER_PAT_FILE"

# 7. Clean up manually created files in ~/.ssh to avoid pollution
echo "==> Cleaning up any manually created SSH files from ~/.ssh to let NixOS manage them..."
rm -f "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ed25519.pub"

# 8. Clean up any manually created gh config/pat in ~/.config/gh to avoid conflicts
echo "==> Cleaning up any manually created GitHub CLI credentials to let NixOS/agenix manage them..."
rm -f "$HOME/.config/gh/github-pat"

echo "==> Secrets successfully encrypted and stored in $SECRETS_DIR"
echo "==> You can now commit the 'secrets' directory to Git."
