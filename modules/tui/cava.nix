{pkgs, ...}: {
  home.packages = with pkgs; [
    cava
  ];

  xdg.desktopEntries.cava = {
    name = "Audio Visualizer";
    exec = ''sh -c "flock -n /tmp/cava.lock footclient cava"'';
    icon = "alsamixergui";
    type = "Application";
    categories = ["Audio"];
  };
}
