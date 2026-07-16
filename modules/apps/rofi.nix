{config, ...}: {
  imports = [./rofi-theme.nix];

  programs.rofi = {
    enable = true;
    font = "${config.font.mono} ${toString config.font.size.base}";
  };
}
