{pkgs, ...}: {
  home.packages = with pkgs; [
    pulsemixer
  ];

  xdg.desktopEntries.pulsemixer = {
    name = "Audio Mixer";
    exec = "footclient pulsemixer";
    icon = "alsamixergui";
    type = "Application";
    categories = ["Audio"];
  };
}
