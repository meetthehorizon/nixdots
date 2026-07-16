{pkgs, ...}: {
  home.packages = [pkgs.wifitui];

  xdg.desktopEntries.wifitui = {
    name = "WiFi TUI";
    exec = "wifitui";
    terminal = true;
    type = "Application";
    categories = ["System"];
  };
}
