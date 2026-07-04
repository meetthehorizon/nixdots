{config, ...}: {
  programs.hyprshot = {
    enable = true;
    saveLocation = "${config.home.homeDirectory}/Pictures/Screenshot";
  };
}
