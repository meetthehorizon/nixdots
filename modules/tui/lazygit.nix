_: {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        nerdFontsVersion = "3";
        fileTreeSortOrder = "foldersFirst";
        customIcons = {
          filenames = {
            "Makefile" = {
              icon = "";
              color = "#6d8086";
            };
            "flake.nix" = {
              icon = "";
              color = "#7EBAE4";
            };
            "flake.lock" = {
              icon = "";
              color = "#7EBAE4";
            };
            "Dockerfile" = {
              icon = "";
              color = "#2496ED";
            };
            "docker-compose.yml" = {
              icon = "";
              color = "#2496ED";
            };
            "package.json" = {
              icon = "";
              color = "#CB3837";
            };
            "package-lock.json" = {
              icon = "";
              color = "#CB3837";
            };
            ".gitignore" = {
              icon = "󰊢";
              color = "#F14E32";
            };
            "README.md" = {
              icon = "󰈙";
              color = "#FFFFFF";
            };
            "LICENSE" = {
              icon = "";
              color = "#D0BF41";
            };
          };

          extensions = {
            ".go" = {
              icon = "󰟓";
              color = "#00ADD8";
            };
            ".c" = {
              icon = "";
              color = "#555555";
            };
            ".cpp" = {
              icon = "";
              color = "#659AD2";
            };
            ".h" = {
              icon = "";
              color = "#A074C4";
            };
            ".hpp" = {
              icon = "";
              color = "#A074C4";
            };
            ".nix" = {
              icon = "󱄅";
              color = "#7EBAE4";
            };
            ".py" = {
              icon = "";
              color = "#FFD43B";
            };
            ".sh" = {
              icon = "";
              color = "#4EAA25";
            };

            # Web & Scripts
            ".lua" = {
              icon = "";
              color = "#2C2D72";
            };
            ".js" = {
              icon = "";
              color = "#F7DF1E";
            };
            ".ts" = {
              icon = "";
              color = "#3178C6";
            };
            ".jsx" = {
              icon = "";
              color = "#61DAFB";
            };
            ".tsx" = {
              icon = "";
              color = "#61DAFB";
            };

            # Data & Configs
            ".json" = {
              icon = "";
              color = "#F8F8F2";
            };
            ".toml" = {
              icon = "";
              color = "#9C4221";
            };
            ".yaml" = {
              icon = "";
              color = "#CB171E";
            };
            ".yml" = {
              icon = "";
              color = "#CB171E";
            };
            ".md" = {
              icon = "";
              color = "#FFFFFF";
            };
            ".csv" = {
              icon = "";
              color = "#89E051";
            };
            ".qml" = {
              icon = "";
              color = "#41CD52";
            };
          };
        };
      };
    };
  };

  xdg.desktopEntries.lazygit = {
    name = "Git Interface";
    exec = "lazygit";
    terminal = true;
    type = "Application";
    categories = ["Development"];
  };
}
