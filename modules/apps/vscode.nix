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
    enkia.tokyo-night
    jdinhlife.gruvbox
    catppuccin.catppuccin-vsc

    catppuccin.catppuccin-vsc-icons
    navernoedenis.gruvbox-material-icons
    pkief.material-icon-theme

    github.copilot-chat
    mkhl.direnv
    tonybaloney.vscode-pets
  ];

  commonSettings = {
    "editor.formatOnSave" = true;
    "direnv.restart.automatic" = true;

    "editor.fontFamily" = "'${config.font.mono}', 'monospace'";
    "workbench.colorTheme" = activeColorTheme;
    "workbench.iconTheme" = activeIconTheme;

    "files.autoSave" = "afterDelay";
    "files.autoSaveDelay" = 1000;
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

      finance = {
        extensions =
          commonExtensions
          ++ (with pkgs.vscode-marketplace; [
            lencerf.beancount
            dongfg.vscode-beancount-formatter
            ms-python.python
            ms-python.black-formatter
          ]);

        userSettings =
          commonSettings
          // {
            "beancount.instantAlignment" = true;
            "beancount.separatorColumn" = 60;
            "beancount.mainBeanFile" = "main.beancount";
            "[beancount]" = {
              "editor.defaultFormatter" = "dongfg.vscode-beancount-formatter";
            };
            "python.analysis.typeCheckingMode" = "basic";
            "python.analysis.autoImportCompletions" = true;
            "[python]" = {
              "editor.defaultFormatter" = "ms-python.black-formatter";
            };
          };

        keybindings = commonKeybindings;
      };
    };
  };
}
