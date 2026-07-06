{pkgs, ...}: {
  programs.nixvim = {
    plugins.lint = {
      enable = true;
      lintersByFt = {
        nix = ["statix"];
        go = ["golangci-lint"];
        python = ["ruff"];
        sh = ["shellcheck"];
        bash = ["shellcheck"];
      };
    };

    extraPackages = with pkgs; [
      statix
      golangci-lint
      ruff
      shellcheck
    ];
  };
}
