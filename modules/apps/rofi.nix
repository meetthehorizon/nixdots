{config, ...}: {
  programs.rofi = with config; {
    enable = true;
    font = "${font.mono} ${toString font.size.base}";
  };
}

