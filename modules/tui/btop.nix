{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
  ];

  xdg.desktopEntries.btop = {
    name = "Resource Monitor";
    exec = ''sh -c "flock -n /tmp/btop.lock footclient btop"'';
    icon = "btop";
    type = "Application";
    categories = ["System"];
  };
}
