{pkgs, ...}: {
  home.packages = with pkgs; [
    tty-clock
  ];

  xdg.desktopEntries.tty-clock = {
    name = "Terminal Clock";
    exec = ''sh -c "flock -n /tmp/tty-clock.lock footclient tty-clock -sc"'';
    icon = "accessories-clock";
    type = "Application";
    categories = ["Utility"];
  };
}
