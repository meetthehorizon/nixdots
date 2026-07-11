{config, ...}: {
  programs.zathura = with config.color; {
    enable = true;
    options = {
      selection-clipboard = "clipboard";

      default-bg = surface;
      default-fg = text;
      recolor-lightcolor = surface;
      recolor-darkcolor = text;

      statusbar-bg = surface;
      statusbar-fg = text;
      highlight-color = accent;
      highlight-active-color = terminal.magenta;
    };
  };
}
