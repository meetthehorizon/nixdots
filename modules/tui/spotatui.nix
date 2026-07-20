{pkgs, ...}: {
  home.packages = [pkgs.spotatui];

  xdg.desktopEntries.spotatui = {
    name = "Spotify TUI";
    genericName = "Music Player";
    comment = "Play and control Spotify from the terminal";
    exec = ''sh -c "flock -n /tmp/spotatui.lock footclient spotatui"'';
    icon = "spotify";
    type = "Application";
    categories = ["Audio" "Music" "Player" "AudioVideo"];
  };
}
