{pkgs, ...}: {
  home.packages = with pkgs; [
    pulsemixer
  ];

  xdg.desktopEntries.pulsemixer = {
    name = "Audio Mixer";
    exec = "pulsemixer";
    terminal = true;
    type = "Application";
    categories = ["Audio"];
  };
}
