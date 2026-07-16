{config, ...}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "${config.assets.homeIcon}";
        type = "auto";
        width = 15;
        padding = {
          top = 2;
          left = 2;
          right = 2;
        };
      };

      display = {
        separator = "  ";
        color = {
          keys = "cyan";
        };
        key = {
          width = 14;
        };
      };

      modules = [
        "break"
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

  xdg.desktopEntries.fastfetch = {
    name = "System Info";
    exec = "fastfetch";
    terminal = true;
    type = "Application";
    categories = ["System"];
  };
}
