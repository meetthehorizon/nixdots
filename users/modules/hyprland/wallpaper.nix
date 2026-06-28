{pkgs, ...}: let
  assets = import ../assets.nix {inherit pkgs;};
in {
  systemd.user.services.awww = {
    Unit = {
      Description = "Awww Wallpaper Daemon";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      ExecStartPost = "${pkgs.awww}/bin/awww img ${assets.homeScreen}";
      ExecStop = "${pkgs.awww}/bin/awww kill";
      Restart = "on-failure";
      RestartSec = "2";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
