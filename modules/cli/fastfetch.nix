{
  pkgs,
  config,
  ...
}: let
  ascii = pkgs.writeText "logo.txt" ''
     ▄       ▄
    ▄ ▀▄   ▄▀ ▄
    █▄█▀███▀█▄█
    ▀█████████▀
     ▄▀     ▀▄
  '';
in {
  programs.fastfetch = with config.color.terminal; {
    enable = true;
    settings = {
      logo = {
        source = "${ascii}";
        type = "file";
        color = {
          "1" = white;
        };
        padding = {
          top = 2;
          left = 2;
        };
      };

      display = {
        separator = "  ";
        color = {
          keys = white;
        };
        key = {
          width = 14;
        };
      };

      modules = [
        {
          type = "title";
          color = {
            user = red;
            at = gray;
            host = red;
          };
        }
        "break"
        {
          type = "os";
          key = "  OS";
          keyColor = blue;
          format = "{pretty-name}";
        }
        {
          type = "kernel";
          key = " 󰌽 Kernel";
          keyColor = magenta;
        }
        {
          type = "wm";
          key = "  WM";
          keyColor = red;
          format = "{pretty-name}";
        }
        {
          type = "shell";
          key = "  Shell";
          keyColor = green;
          format = "{pretty-name}";
        }
        {
          type = "uptime";
          key = " 󰔚 Uptime";
          keyColor = yellow;
        }
        {
          type = "colors";
          key = " 󰸱 Color";
          symbol = "circle";
          format = "{pretty-name}";
        }
      ];
    };
  };

  xdg.desktopEntries.fastfetch = {
    name = "System Info";
    exec = ''footclient bash -c "fastfetch; read -n1 -s -r; echo"'';
    icon = "utilities-system-monitor";
    type = "Application";
    categories = ["System"];
  };
}
