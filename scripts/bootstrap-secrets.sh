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

# 0. Check GPU MUX mode if running on an ASUS ROG/Zephyrus laptop
if [ -f "/sys/devices/platform/asus-nb-wmi/gpu_mux_mode" ]; then
    GPU_MUX_MODE=$(cat /sys/devices/platform/asus-nb-wmi/gpu_mux_mode 2>/dev/null || echo "")
    if [ -n "$GPU_MUX_MODE" ] && [ "$GPU_MUX_MODE" != "1" ]; then
        echo -e "${YELLOW}${BOLD} WARNING: GPU MUX mode is not set to Hybrid!${NC}"
        echo -e "Current GPU MUX mode: ${RED}$GPU_MUX_MODE${NC} (discrete/dedicated-only mode)"
        echo -e "For this Asus Zephyrus G14 configuration, it is highly recommended to run in ${GREEN}Hybrid mode (1)${NC}."
        echo -e "This allows Hyprland/Wayland to run on the AMD iGPU, while the NVIDIA dGPU is kept idle"
        echo -e "and only powered on dynamically for offloading (e.g. games/renderers) via 'nvidia-offload'."
        echo -e "Otherwise, Hyprland will run entirely on the dedicated NVIDIA GPU, draining battery rapidly."
        echo -e "To switch to Hybrid mode, run:"
        echo -e "  ${BLUE}asusctl armoury set gpu_mux_mode 1${NC}"
        echo -e "Note: Changing the MUX mode requires a system reboot to take effect."
        echo ""
    elif [ "$GPU_MUX_MODE" = "1" ]; then
        echo -e "${GREEN}${BOLD}󰄬${NC} GPU MUX mode is correct (Hybrid mode)."
    fi
fi


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

# 4.5. Check for GitHub PAT / credentials (healthcheck)
USER_PAT_FILE="$BOOTSTRAP_SECRETS_DIR/github-pat"
GITHUB_PAT_FOUND=""

# Discover PAT from various possible locations
if [ -f "$USER_PAT_FILE" ]; then
    GITHUB_PAT_FOUND=$(cat "$USER_PAT_FILE")
elif [ -n "${GITHUB_PAT:-}" ]; then
    GITHUB_PAT_FOUND="$GITHUB_PAT"
elif [ -n "${GH_TOKEN:-}" ]; then
    GITHUB_PAT_FOUND="$GH_TOKEN"
elif command -v gh &>/dev/null && gh auth token &>/dev/null; then
    GITHUB_PAT_FOUND=$(gh auth token)
fi

# Fallback: check if we can run gh via nix shell to find the token
if [ -z "$GITHUB_PAT_FOUND" ]; then
    if nix shell nixpkgs#gh -c gh auth token &>/dev/null; then
        GITHUB_PAT_FOUND=$(nix shell nixpkgs#gh -c gh auth token)
    fi
fi

if [ -z "$GITHUB_PAT_FOUND" ]; then
    if [ "$INTERACTIVE" = true ] && confirm "Do you have a GitHub Personal Access Token (PAT) to configure?"; then
        echo -e "${CYAN}Please paste your GitHub Classic PAT (should start with ghp_):${NC}"
        read -r GITHUB_PAT_INPUT
        GITHUB_PAT_FOUND="$GITHUB_PAT_INPUT"
    else
        echo -e "${RED}=========================================================================${NC}"
        echo -e "${RED}${BOLD}󰅚 ERROR:${NC} GitHub PAT/credentials not found."
        echo -e "To continue, please ensure GITHUB_PAT/GH_TOKEN is set, gh is logged in,"
        echo -e "or paste a token when prompted."
        echo -e "${RED}=========================================================================${NC}"
        exit 1
    fi
fi

# Persist the PAT file
echo "$GITHUB_PAT_FOUND" > "$USER_PAT_FILE"
chmod 600 "$USER_PAT_FILE"
echo -e "${GREEN}${BOLD}󰄬${NC} GitHub PAT set."

# 4.6. Verify and register SSH key with GitHub
if [ -f "$USER_SSH_KEY.pub" ]; then
    SSH_PUB_KEY=$(cat "$USER_SSH_KEY.pub")
    SSH_KEY_BODY=$(echo "$SSH_PUB_KEY" | awk '{print $2}')
    
    echo -e "${CYAN}${NC} Checking if SSH key is registered with GitHub..."
    # Run gh ssh-key list in nix shell with the token
    if GH_TOKEN="$GITHUB_PAT_FOUND" nix shell nixpkgs#gh -c gh ssh-key list | grep -q "$SSH_KEY_BODY"; then
        echo -e "${GREEN}${BOLD}󰄬${NC} SSH key is already registered with GitHub."
    else
        echo -e "${CYAN}${NC} SSH key not found on GitHub. Adding it..."
        if GH_TOKEN="$GITHUB_PAT_FOUND" nix shell nixpkgs#gh -c gh ssh-key add "$USER_SSH_KEY.pub" --title "NixOS - $(hostname) - $(date +%F)"; then
            echo -e "${GREEN}${BOLD}󰄬${NC} SSH key successfully registered with GitHub."
        else
            echo -e "${YELLOW}${BOLD} Warning:${NC} Failed to automatically register SSH key with GitHub. You may need to add it manually."
        fi
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

# 7. Clean up manually created files in ~/.ssh to avoid pollution (only if they are regular files, not symlinks)
echo -e "${CYAN}${NC} Cleaning up any manually created SSH files from ~/.ssh (NixOS will manage them)..."
if [ -f "$HOME/.ssh/id_ed25519" ] && [ ! -L "$HOME/.ssh/id_ed25519" ]; then
    rm -f "$HOME/.ssh/id_ed25519"
fi
if [ -f "$HOME/.ssh/id_ed25519.pub" ] && [ ! -L "$HOME/.ssh/id_ed25519.pub" ]; then
    rm -f "$HOME/.ssh/id_ed25519.pub"
fi

# 7.5. Set up local SSH config for bootstrapping if it doesn't already exist or isn't a symlink
SSH_CONFIG_FILE="$HOME/.ssh/config"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -L "$SSH_CONFIG_FILE" ] && [ ! -f "$SSH_CONFIG_FILE" ]; then
    echo -e "${CYAN}${NC} Creating temporary ~/.ssh/config for bootstrapping..."
    cat << EOF > "$SSH_CONFIG_FILE"
Host github.com
  HostName github.com
  IdentityFile ~/.ssh/id_ed25519
  User git
EOF
    chmod 600 "$SSH_CONFIG_FILE"
    echo -e "${GREEN}${BOLD}󰄬${NC} Temporary ~/.ssh/config created."
elif [ -f "$SSH_CONFIG_FILE" ] && [ ! -L "$SSH_CONFIG_FILE" ] && ! grep -q "Host github.com" "$SSH_CONFIG_FILE"; then
    echo -e "${CYAN}${NC} Appending github.com configuration to ~/.ssh/config..."
    cat << EOF >> "$SSH_CONFIG_FILE"

Host github.com
  HostName github.com
  IdentityFile ~/.ssh/id_ed25519
  User git
EOF
    echo -e "${GREEN}${BOLD}󰄬${NC} ~/.ssh/config updated."
else
    echo -e "${GREEN}${BOLD}󰄬${NC} ~/.ssh/config already configured/managed by Home Manager."
fi

# 8. Clean up any manually created gh config/pat in ~/.config/gh to avoid conflicts (only if not a symlink)
echo -e "${CYAN}${NC} Cleaning up any manually created GitHub CLI credentials to let NixOS/agenix manage them..."
if [ -f "$HOME/.config/gh/github-pat" ] && [ ! -L "$HOME/.config/gh/github-pat" ]; then
    rm -f "$HOME/.config/gh/github-pat"
fi

echo -e "${GREEN}${BOLD}󰄬${NC} Secrets successfully encrypted and stored in ${BLUE}$SECRETS_DIR${NC}"
echo -e "${CYAN}${NC} You can now commit the 'secrets' directory to Git."

# 9. Prompt to restart the shell
if [ "$INTERACTIVE" = true ] && confirm "Do you want to restart your shell now?"; then
    echo -e "${CYAN}${NC} Restarting shell..."
    exec "$SHELL"
fi
