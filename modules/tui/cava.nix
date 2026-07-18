{pkgs, ...}: {
  home.packages = with pkgs; [
    cava
  ];

  xdg.desktopEntries.cava = {
    name = "Audio Visualizer";
    exec = "footclient cava";
    icon = "alsamixergui";
    type = "Application";
    categories = ["Audio"];
  };
}

