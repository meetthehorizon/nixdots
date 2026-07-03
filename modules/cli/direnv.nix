{config, ...}: {
  programs.direnv = {
    enable = true;
    silent = true;
    enableFishIntegration = config.programs.fish.enable;
    enableZshIntegration = config.programs.zsh.enable;
    nix-direnv.enable = true;
  };
}
