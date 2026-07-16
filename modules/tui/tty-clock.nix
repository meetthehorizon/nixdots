{pkgs, ...}: {
  home.packages = with pkgs; [
    tty-clock
  ];

  xdg.desktopEntries.tty-clock = {
    name = "Terminal Clock";
    exec = "tty-clock -sc";
    terminal = true;
    type = "Application";
    categories = ["Utility"];
  };
}