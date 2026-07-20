{pkgs, ...}: {
  home.packages = [pkgs.spotatui];

  xdg.desktopEntries.spotatui = {
    name = "Spotify TUI";
    genericName = "Music Player";
    comment = "Play and control Spotify from the terminal";
    exec = "footclient --app-id=spotatui -e spotatui";
    icon = "spotify";
    type = "Application";
    categories = ["Audio" "Music" "Player" "AudioVideo"];
  };
}
