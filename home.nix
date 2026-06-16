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
      alias = {
        st = "status";
        lg = "log -n 10 --oneline";
        ci = "commit";
        co = "checkout";
        br = "branch";
        fk = "commit --amend --no-edit";
        rb = "rebase";
        rbc = "rebase --continue";
      };

      core.editor = "nvim";
      init.defaultBranch = "master";
      pull.rebase = true;
      "url \"git@github.com:\"".insteadOf = "https://github.com/";
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

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";

      directory = {
        style = "blue";
      };

      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        # These preserve the zero-width spaces from your original config
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };

      git_state = {
        # Backslashes must be escaped in Nix strings
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bright-black";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };

      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
        # Empty arrays map perfectly to Nix lists
        detect_extensions = [ ];
        detect_files = [ ];
      };
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
