{config, ...}: {
  programs.kitty = with config; {
    enable = true;

    font = {
      name = font.mono;
      size = font.size.xs;
    };

    settings = {
      background = color.surface;
      foreground = color.text;
      background_opacity = ui.effects.surfaceAlpha;
    };
  };
}
