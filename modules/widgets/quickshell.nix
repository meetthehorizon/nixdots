{
  inputs,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    inputs.quickshell.packages.${stdenv.hostPlatform.system}.default
    kdePackages.qtdeclarative
  ];

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell Wayland GUI";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.bash}/bin/bash -lc 'qs -p ${config.settings.nixdotsPath}/modules/widgets/quickshell'";
      Restart = "always";
      RestartSec = 3;
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
