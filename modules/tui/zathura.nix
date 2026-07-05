{config, ...}: {
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";

      default-bg = config.theme.colors.background;
      default-fg = config.theme.colors.foreground;
      recolor-lightcolor = config.theme.colors.background;
      recolor-darkcolor = config.theme.colors.foreground;

      statusbar-bg = config.theme.colors.background;
      statusbar-fg = config.theme.colors.foreground;
      highlight-color = config.theme.colors.accent;
      highlight-active-color = config.theme.colors.magenta;
    };
  };
}
