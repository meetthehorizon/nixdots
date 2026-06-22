#!/usr/bin/env bash

set -euo pipefail

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Directories
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SECRETS_DIR="$DOTFILES_DIR/secrets"
AGE_KEY_DIR="$HOME/.config/sops/age"
AGE_KEY_FILE="$AGE_KEY_DIR/keys.txt"

echo -e "${CYAN}${BOLD}${NC} Setting up reproducible secrets..."

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
        echo -e "${CYAN}Please paste your age private key (e.g. AGE-SECRET-KEY-1...):${NC}"
        read -r AGE_KEY_INPUT
        
        # Extract the secret key line
        RAW_SECRET_KEY=$(echo "$AGE_KEY_INPUT" | grep -o "AGE-SECRET-KEY-1.*" | tr -d '\r\n ' || echo "")
        
        if [ -z "$RAW_SECRET_KEY" ]; then
            echo -e "${RED}${BOLD}󰅚 ERROR:${NC} Invalid age private key format. Must contain AGE-SECRET-KEY-1..."
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
        echo -e "${GREEN}${BOLD}󰄬${NC} Age key successfully restored in standard format."
    else
        echo -e "${CYAN}${NC} Generating age master recovery key at ${BLUE}$AGE_KEY_FILE${NC}..."
        nix shell nixpkgs#age -c age-keygen -o "$AGE_KEY_FILE"
        echo -e "${MAGENTA}${BOLD}󰀼 IMPORTANT:${NC} Please backup this key safely! It is your recovery key."
    fi
else
    echo -e "${CYAN}${NC} Found existing age key at ${BLUE}$AGE_KEY_FILE${NC}"
fi

# Extract public key from the age key file
USER_AGE_PUB=$(nix shell nixpkgs#age -c age-keygen -y "$AGE_KEY_FILE")
echo -e "${CYAN}User age public key:${NC} ${GREEN}$USER_AGE_PUB${NC}"

# 3. Get system host SSH public key
SYSTEM_HOST_PUB=""
if [ -f "/etc/ssh/ssh_host_ed25519_key.pub" ]; then
    SYSTEM_HOST_PUB=$(cat /etc/ssh/ssh_host_ed25519_key.pub)
    echo -e "${GREEN}${BOLD}󰄬${NC} Found system host SSH public key."
else
    echo -e "${YELLOW}${BOLD} Warning:${NC} System host SSH key not found in /etc/ssh/. Encryption will only use age master key."
fi

# 4. Generate user SSH key if it doesn't exist
BOOTSTRAP_SECRETS_DIR="$DOTFILES_DIR/.secrets"
mkdir -p "$BOOTSTRAP_SECRETS_DIR"
USER_SSH_KEY="$BOOTSTRAP_SECRETS_DIR/id_ed25519"
if [ ! -f "$USER_SSH_KEY" ]; then
    if [ "$INTERACTIVE" = true ] && confirm "Do you have an existing SSH private key to restore?"; then
        echo -e "${CYAN}Please paste your SSH private key (press Enter, then Ctrl+D when finished):${NC}"
        cat > "$USER_SSH_KEY"
        chmod 600 "$USER_SSH_KEY"
        
        echo -e "${CYAN}Please paste your SSH public key (starts with ssh-ed25519):${NC}"
        read -r USER_SSH_PUB
        echo "$USER_SSH_PUB" > "$USER_SSH_KEY.pub"
        echo -e "${GREEN}${BOLD}󰄬${NC} SSH key successfully restored."
    else
        echo -e "${CYAN}${NC} Generating new SSH key pair for GitHub..."
        ssh-keygen -t ed25519 -C "kshitij.dev@proton.me" -f "$USER_SSH_KEY" -N ""
    fi
else
    echo -e "${CYAN}${NC} Found existing SSH key at ${BLUE}$USER_SSH_KEY${NC}"
fi

# 4.5. Check for GitHub PAT
USER_PAT_FILE="$BOOTSTRAP_SECRETS_DIR/github-pat"
if [ ! -f "$USER_PAT_FILE" ]; then
    if [ -n "${GITHUB_PAT:-}" ]; then
        echo "$GITHUB_PAT" > "$USER_PAT_FILE"
    elif [ "$INTERACTIVE" = true ] && confirm "Do you have a GitHub Personal Access Token (PAT) to configure?"; then
        echo -e "${CYAN}Please paste your GitHub Classic PAT (should start with ghp_):${NC}"
        read -r GITHUB_PAT_INPUT
        echo "$GITHUB_PAT_INPUT" > "$USER_PAT_FILE"
        echo -e "${GREEN}${BOLD}󰄬${NC} PAT saved."
    else
        echo -e "${RED}=========================================================================${NC}"
        echo -e "${RED}${BOLD}󰅚 ERROR:${NC} GitHub PAT not found at ${BLUE}$USER_PAT_FILE${NC}"
        echo -e "To continue, please create this file and paste your GitHub PAT inside it."
        echo -e "Ensure the token has 'repo', 'admin:public_key', and 'workflow' scopes."
        echo -e "${RED}=========================================================================${NC}"
        exit 1
    fi
fi

# 5. Prepare secrets directory and secrets.nix
mkdir -p "$SECRETS_DIR"
SECRETS_NIX="$SECRETS_DIR/secrets.nix"

echo -e "${CYAN}${NC} Creating ${BLUE}$SECRETS_NIX${NC}..."
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
echo -e "${CYAN}${BOLD}${NC} Encrypting secrets..."
AGE_ARGS=("-r" "$USER_AGE_PUB")
if [ -n "$SYSTEM_HOST_PUB" ]; then
    AGE_ARGS+=("-r" "$SYSTEM_HOST_PUB")
fi

echo -e "${CYAN}Encrypting SSH key...${NC}"
nix shell nixpkgs#age -c age "${AGE_ARGS[@]}" -o "$SECRETS_DIR/github-ssh-key.age" "$USER_SSH_KEY"

echo -e "${CYAN}Encrypting GitHub PAT...${NC}"
nix shell nixpkgs#age -c age "${AGE_ARGS[@]}" -o "$SECRETS_DIR/github-pat.age" "$USER_PAT_FILE"

# 7. Clean up manually created files in ~/.ssh to avoid pollution
echo -e "${CYAN}${NC} Cleaning up any manually created SSH files from ~/.ssh to let NixOS manage them..."
rm -f "$HOME/.ssh/id_ed25519" "$HOME/.ssh/id_ed25519.pub"

# 8. Clean up any manually created gh config/pat in ~/.config/gh to avoid conflicts
echo -e "${CYAN}${NC} Cleaning up any manually created GitHub CLI credentials to let NixOS/agenix manage them..."
rm -f "$HOME/.config/gh/github-pat"

echo -e "${GREEN}${BOLD}󰄬${NC} Secrets successfully encrypted and stored in ${BLUE}$SECRETS_DIR${NC}"
echo -e "${CYAN}${NC} You can now commit the 'secrets' directory to Git."

# 9. Prompt to restart the shell
if [ "$INTERACTIVE" = true ] && confirm "Do you want to restart your shell now?"; then
    echo -e "${CYAN}${NC} Restarting shell..."
    exec "$SHELL"
fi
