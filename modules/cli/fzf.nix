{config, ...}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;

    colors = with config.color; {
      bg = surface;
      fg = text;
      hl = accent;
      "bg+" = surface;
      "fg+" = text;
      "hl+" = accent;
      info = terminal.yellow;
      prompt = accent;
      pointer = accent;
      marker = accent;
      spinner = accent;
      header = accent;
    };
  };
}
