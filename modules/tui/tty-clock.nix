{pkgs, ...}: {
  home.packages = with pkgs; [
    tty-clock
  ];

  xdg.desktopEntries.tty-clock = {
    name = "Terminal Clock";
    exec = "footclient tty-clock -sc";
    icon = "accessories-clock";
    type = "Application";
    categories = ["Utility"];
  };
}

