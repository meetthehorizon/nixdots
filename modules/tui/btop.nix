{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
  ];

  xdg.desktopEntries.btop = {
    name = "Resource Monitor";
    exec = "footclient btop";
    icon = "btop";
    type = "Application";
    categories = ["System"];
  };
}
