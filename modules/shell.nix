{
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # These are the modern Zsh features that make it great
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    defaultKeymap = "viins";

    history = {
      size = 10000;
      save = 10000;
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      ll = "ls -la";
      v = "nvim";
      g = "git";
      clr = "clear && fastfetch";

      nean = "sudo nix-collect-garbage -d";
      nate = "sudo nixos-rebuild switch --flake ~/.dotfiles/#horizon";
      nest = "sudo nixos-rebuild test --flake ~/.dotfiles/#horizon";
    };

    initContent = ''
      fastfetch
      if [ -f /home/conart/.config/gh/github-pat ]; then
        export GITHUB_TOKEN=$(cat /home/conart/.config/gh/github-pat)
        export GH_TOKEN=$GITHUB_TOKEN
      fi
    '';
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "${config.home.homeDirectory}/.config/fastfetch/logo.png";
        type = "auto";
        width = 15;
        padding = {
          top = 2;
          left = 2;
          right = 2;
        };
      };

      # --- NEW: Global Display Settings ---
      display = {
        separator = "  "; # Replaces the default ":" with clean whitespace
        color = {
          keys = "cyan"; # Unifies all key colors to match the title
        };
        key = {
          width = 14; # Forces perfect vertical alignment for all values
        };
      };

      modules = [
        "break" # Adds a blank line at the top for breathing room

        {
          type = "title";
          color = {
            user = "cyan";
            at = "white";
            host = "cyan";
          };
        }

        "break"

        {
          type = "os";
          key = "  OS";
          keyColor = "blue";
          format = "{pretty-name}";
        }
        {
          type = "kernel";
          key = " 󰌽 Kernel";
          keyColor = "magenta";
        }
        {
          type = "wm";
          key = "  WM";
          keyColor = "red";
        }
        {
          type = "shell";
          key = "  Shell";
          keyColor = "green";
        }
        {
          type = "uptime";
          key = " 󰔚 Uptime";
          keyColor = "yellow";
        }

        {
          type = "colors";
          key = " 󰸱 Color";
          symbol = "circle";
        }
      ];
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
        detect_extensions = [];
        detect_files = [];
      };
    };
  };
}
