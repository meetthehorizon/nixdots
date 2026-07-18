# nixdots

Personal NixOS + home-manager configuration for **horizon** (ASUS Zephyrus G14).

![desktop](screenshot.png)

## Quick start

```sh
# Build & switch home-manager
home-manager switch --flake .#conart@horizon

# Build & switch system
sudo nixos-rebuild switch --flake .#horizon
```

## Stack

| Layer | Choice |
|---|---|
| OS | NixOS 26.05 |
| Compositor | Hyprland |
| Bar | Waybar |
| Editor | nixvim |
| Shell | fish · kitty |
| Secrets | agenix |
