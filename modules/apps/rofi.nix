{config, ...}: {
  programs.rofi = {
    enable = true;
    font = "${config.font.mono} ${toString config.font.size.base}";
  };
}
