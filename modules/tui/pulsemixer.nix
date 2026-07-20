{pkgs, ...}: {
  home.packages = with pkgs; [
    pulsemixer
  ];

  xdg.desktopEntries.pulsemixer = {
    name = "Audio Mixer";
    exec = ''sh -c "flock -n /tmp/pulsemixer.lock footclient pulsemixer"'';
    icon = "alsamixergui";
    type = "Application";
    categories = ["Audio"];
  };
}
