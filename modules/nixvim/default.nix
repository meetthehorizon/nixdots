{
  programs.nixvim.enable = true;
  imports = [
    ./plugins

    ./colorschemes.nix
    ./keymaps.nix
    ./options.nix
  ];
}
