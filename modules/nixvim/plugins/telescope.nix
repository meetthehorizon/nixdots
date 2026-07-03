{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      telescope.enable = true;
    };
    extraPackages = with pkgs; [
      ripgrep
    ];
  };
}
