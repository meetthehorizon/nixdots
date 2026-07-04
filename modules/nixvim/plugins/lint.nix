{pkgs, ...}: {
  programs.nixvim = {
    plugins.lint = {
      enable = true;
      lintersByFt = {
        nix = ["statix"];
        go = ["golangci-lint"];
      };
    };

    extraPackages = with pkgs; [
      statix
      golangci-lint
    ];
  };
}
