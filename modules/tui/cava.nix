{pkgs, ...}: {
  home.packages = with pkgs; [
    cava
  ];

  xdg.desktopEntries.cava = {
    name = "Audio Visualizer";
    exec = "cava";
    terminal = true;
    type = "Application";
    categories = ["Audio"];
  };
}