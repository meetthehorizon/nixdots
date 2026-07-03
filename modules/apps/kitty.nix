{config, ...}: {
  programs.kitty = {
    enable = true;

    font = {
      name = config.theme.fonts.mono;
      size = config.theme.fonts.sizes.kitty;
    };

    settings = {
      background = config.theme.colors.background;
      foreground = config.theme.colors.foreground;
      background_opacity = config.theme.opacity.kitty;
    };
  };
}
