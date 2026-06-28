{config, ...}: {
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    colors = {
      bg = config.theme.colors.background;
      fg = config.theme.colors.foreground;
      hl = config.theme.colors.accent;
      "bg+" = config.theme.colors.background;
      "fg+" = config.theme.colors.foreground;
      "hl+" = config.theme.colors.accent;
      info = config.theme.colors.yellow;
      prompt = config.theme.colors.accent;
      pointer = config.theme.colors.accent;
      marker = config.theme.colors.accent;
      spinner = config.theme.colors.accent;
      header = config.theme.colors.accent;
    };
  };
}
