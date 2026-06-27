{config, ...}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -la --icons --group-directories-first";
      v = "nvim";
      g = "git";
      clr = "clear && fastfetch";

      nean = "sudo nix-collect-garbage -d";
      nate = "sudo nixos-rebuild switch --flake ~/nixdots/#horizon";
      nest = "sudo nixos-rebuild test --flake ~/nixdots/#horizon";
    };

    interactiveShellInit = ''
      # Disable greeting
      set -g fish_greeting

      # Enable vi key bindings
      fish_vi_key_bindings

      fastfetch
      if test -f /home/conart/.config/gh/github-pat
        set -gx GITHUB_TOKEN (cat /home/conart/.config/gh/github-pat)
        set -gx GH_TOKEN $GITHUB_TOKEN
      end
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
    enableFishIntegration = true;

    settings = {
      format = "$username$git_branch$git_state$git_status$nix_shell$python$line_break$directory$character";
      right_format = "$cmd_duration";

      username = {
        show_always = true;
        style_user = "bold #89b4fa";
        style_root = "bold #f38ba8";
        format = "[ $user]($style) ";
      };

      directory = {
        style = "bold #b4befe";
        format = "[󰉋 $path]($style)[$read_only]($read_only_style) ";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      character = {
        success_symbol = "[❯](bold #cba6f7)";
        error_symbol = "[❯](bold #f38ba8)";
        vimcmd_symbol = "[❮](bold #a6e3a1)";
      };

      git_branch = {
        format = "[ $branch]($style) ";
        style = "bold #9399b2";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold #eba0ac";
        conflicted = "󰞇 ";
        ahead = "󰶟 ";
        behind = "󰶞 ";
        diverged = "󰹹 ";
        untracked = "󰛑 ";
        stashed = "󰆓 ";
        modified = "󰚌 ";
        staged = "󰜶 ";
        renamed = "󰪹 ";
        deleted = "󰆴 ";
      };

      git_state = {
        # Backslashes must be escaped in Nix strings
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bold #9399b2";
      };

      cmd_duration = {
        format = "[󱎦 $duration]($style)";
        style = "bold #f9e2af";
      };

      python = {
        format = "via [ $virtualenv]($style) ";
        style = "bold #a6e3a1";
        # Empty arrays map perfectly to Nix lists
        detect_extensions = [];
        detect_files = [];
      };

      nix_shell = {
        format = "via [ $state( \\($name\\))]($style) ";
        style = "bold #74c7ec";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
