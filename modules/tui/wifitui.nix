{pkgs, ...}: {
  home.packages = [pkgs.wifitui];

  xdg.desktopEntries.wifitui = {
    name = "WiFi TUI";
    exec = ''sh -c "flock -n /tmp/wifitui.lock footclient wifitui"'';
    icon = "wifi-radar";
    type = "Application";
    categories = ["System"];
  };
}
