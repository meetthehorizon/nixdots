{pkgs, ...}: let
  commonExtensions = with pkgs.vscode-marketplace; [
    # --- All Themes ---
    enkia.tokyo-night
    catppuccin.catppuccin-vsc
    catppuccin.catppuccin-vsc-icons

    # --- Core Utilities ---
    github.copilot-chat
    mkhl.direnv
    tonybaloney.vscode-pets
  ];

  commonSettings = {
    "editor.formatOnSave" = true;
    "direnv.restart.automatic" = true;

    "editor.fontFamily" = "'FiraCode Nerd Font', 'monospace'";
    "workbench.colorTheme" = "Tokyo Night";
    "workbench.iconTheme" = "catppuccin-frappe";

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
