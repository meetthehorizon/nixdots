{ config, pkgs, inputs, ... }:

{
  # Replace with your exact username and home directory path
  home.username = "conart";
  home.homeDirectory = "/home/conart";

  # Do not change this value unless you thoroughly read the release notes.
  home.stateVersion = "26.05"; 

  # User-specific packages you want installed
  home.packages = with pkgs; [
    firefox
    hyprlauncher
    wl-clipboard
  ];

  imports = [
    inputs.nixvim.homeModules.nixvim
    ./nixvim.nix
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Kshitij Sharma";
	email = "kshitij.dev@proton.me";
      };
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.8";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  
    # These are the modern Zsh features that make it great
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -la";
      update = "sudo nixos-rebuild switch --flake ~/.dotfiles/#horizon";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {};
    
    extraConfig = ''
local mod = "SUPER"
local terminal = "kitty"
local launcher = "hyprlauncher"

hl.config({
input = {
  kb_layout = "us",
  kb_options = "caps:escape"
},
})

hl.bind(mod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exit())
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd(launcher))
    '';
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
