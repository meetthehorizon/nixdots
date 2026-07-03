{config, ...}: {
  programs.eza = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;
    git = config.programs.git.enable;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}
