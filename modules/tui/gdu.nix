{pkgs, ...}: {
  home.packages = with pkgs; [
    gdu
  ];

  xdg.desktopEntries.gdu = {
    name = "Disk Usage Analyzer";
    exec = "footclient gdu";
    icon = "disk-usage-analyzer";
    type = "Application";
    categories = ["System"];
  };
}
