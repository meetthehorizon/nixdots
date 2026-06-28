{config, ...}: {
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
}
