{
  inputs,
  pkgs,
  config,
  hostName,
  ...
}: let
  themeQmlText = with config; ''
    pragma Singleton
    import QtQuick
    import Quickshell

    Singleton {
        readonly property var user: (${builtins.toJSON {
      username = home.username;
      hostname = hostName;
    }})

        readonly property var font: (${builtins.toJSON {
      inherit (font) sans mono size weight;
      sansSerif = font.serif;
    }})

        readonly property var color: (${builtins.toJSON color})

        readonly property var spacing: (${builtins.toJSON ui.spacing})

        readonly property var radius: (${builtins.toJSON ui.radius})

        readonly property var border: (${builtins.toJSON ui.border})

        readonly property var effects: (${builtins.toJSON ui.effects})

        readonly property var animDuration: (${builtins.toJSON ui.animation})
    }
  '';
in {
  home.packages = with pkgs; [
    inputs.quickshell.packages.${stdenv.hostPlatform.system}.default
    kdePackages.qtdeclarative
  ];

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell Wayland GUI";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
      X-Switch-Trigger = builtins.hashString "sha256" themeQmlText;
    };

    Service = {
      Type = "simple";

      Environment = [
        "QML_DISABLE_DISK_CACHE=1"
        "QML2_IMPORT_PATH=${config.home.homeDirectory}/nixdots/modules/widgets/quickshell"
      ];

      ExecStart = "${pkgs.bash}/bin/bash -lc 'qs -p ${config.home.homeDirectory}/nixdots/modules/widgets/quickshell'";

      Restart = "always";
      RestartSec = 3;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  home.file."${config.home.homeDirectory}/nixdots/modules/widgets/quickshell/globals/Theme.qml".text = themeQmlText;
}
