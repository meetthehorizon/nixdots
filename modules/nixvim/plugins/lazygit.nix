{pkgs, ...}: {
  programs.nixvim = {
    plugins.lazygit = {
      enable = true;
      package = pkgs.emptyDirectory;
    };
  };
}
