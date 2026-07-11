{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [awww];
  systemd.user.services.awww = {
    Unit = {
      Description = "Awww Wallpaper Daemon";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      ExecStartPost = "${pkgs.awww}/bin/awww img ${config.theme.assets.homeScreen} --transition-fps 60 --transition-type wipe --transition-duration 1";
      ExecStop = "${pkgs.awww}/bin/awww kill";
      Restart = "on-failure";
      RestartSec = "2";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
