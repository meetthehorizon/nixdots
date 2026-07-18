{pkgs, ...}: {
  home.packages = [pkgs.wifitui];

  xdg.desktopEntries.wifitui = {
    name = "WiFi TUI";
    exec = "footclient wifitui";
    icon = "wifi-radar";
    type = "Application";
    categories = ["System"];
  };
}
