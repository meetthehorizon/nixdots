{pkgs, ...}: {
  home.packages = with pkgs; [
    gdu
  ];

  xdg.desktopEntries.gdu = {
    name = "Disk Usage Analyzer";
    exec = "gdu";
    terminal = true;
    type = "Application";
    categories = ["System"];
  };
}
