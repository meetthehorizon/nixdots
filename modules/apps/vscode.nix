{
  config,
  pkgs,
  ...
}: let
  vscodeThemeMap = {
    "tokyonight" = "Tokyo Night";
    "catppuccin" = "Catppuccin Mocha";
    "gruvbox" = "Gruvbox Dark Hard";
  };

  vscodeIconMap = {
    "tokyonight" = "material-icon-theme";
    "catppuccin" = "catppuccin-mocha";
    "gruvbox" = "gruvbox-material-icons";
  };

  activeColorTheme = vscodeThemeMap.${config.color.style};
  activeIconTheme = vscodeIconMap.${config.color.style};

  commonExtensions = with pkgs.vscode-marketplace; [
    # Themes
    enkia.tokyo-night
    jdinhlife.gruvbox
    catppuccin.catppuccin-vsc

    # Icons
    catppuccin.catppuccin-vsc-icons
    navernoedenis.gruvbox-material-icons
    pkief.material-icon-theme

    # Utilities
    mkhl.direnv
    tonybaloney.vscode-pets
    jbockle.jbockle-format-files

    # Git & GitHub Management
    mhutchie.git-graph

    # Nix
    jnoortheen.nix-ide
  ];

  commonSettings = {
    "editor.formatOnSave" = true;
    "direnv.restart.automatic" = true;

    "explorer.autoReveal" = true;
    "explorer.autoRevealExclude" = {
      "**/.direnv" = true;
    };
    "explorer.confirmDelete" = false;

    "editor.fontFamily" = "'${config.font.mono}', 'monospace'";
    "workbench.colorTheme" = activeColorTheme;
    "workbench.iconTheme" = activeIconTheme;

    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 1000;
    "editor.minimap.enabled" = false;

    "chat.disableAIFeatures" = true;
    "git.openRepositoryInParentFolders" = "always";
  };

  commonKeybindings = [
    {
      key = "ctrl+,";
      command = "workbench.action.openWorkspaceSettings";
    }
  ];
in {
  programs.vscode = {
    enable = true;

    profiles = {
      default = {
        extensions = commonExtensions;
        userSettings = commonSettings;
        keybindings = commonKeybindings;
      };

      frontend = {
        extensions =
          commonExtensions
          ++ (with pkgs.vscode-marketplace; [
            # Frontend - Core Frameworks
            pkgs.vscode-marketplace."1yib".svelte-bundle
            svelte.svelte-vscode
            bradlc.vscode-tailwindcss

            # Frontend - HTML & CSS Utilities
            ecmel.vscode-html-css
            formulahendry.auto-rename-tag
            formulahendry.auto-close-tag
            pranaygp.vscode-css-peek

            # Linting & Formatting
            esbenp.prettier-vscode
            usernamehw.errorlens
            dbaeumer.vscode-eslint

            # Developer Quality of Life
            christian-kohler.path-intellisense
            yoavbls.pretty-ts-errors
          ]);

        userSettings =
          commonSettings
          // {
            "editor.formatOnSave" = true;
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
            "editor.codeActionsOnSave" = {
              "source.fixAll.eslint" = "explicit";
            };

            "explorer.autoRevealExclude" = {
              "**/node_modules" = true;
              "**/.svelte-kit" = true;
              "**/build" = true;
              "**/dist" = true;
              "**/.git" = true;
              "**/.DS_Store" = true;
            };

            "[svelte]" = {
              "editor.defaultFormatter" = "svelte.svelte-vscode";
            };
            "svelte.enable-ts-plugin" = true;

            "emmet.includeLanguages" = {
              "svelte" = "html";
            };
            "emmet.syntaxProfiles" = {
              "svelte" = "html";
            };
            "editor.linkedEditing" = true;

            "tailwindCSS.emmetCompletions" = true;
            "css.validate" = false;
            "less.validate" = false;
            "scss.validate" = false;

            "editor.wordWrap" = "on";
            "editor.tabSize" = 2;
            "files.autoSave" = "afterDelay";
            "files.autoSaveDelay" = 1000;
          };
      };
    };
  };
}
