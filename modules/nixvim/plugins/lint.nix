{pkgs, ...}: {
  programs.nixvim = {
    plugins.lint = {
      enable = true;
      lintersByFt = {
        nix = ["statix"];
        go = ["golangcilint"];
        python = ["ruff"];
        sh = ["shellcheck"];
        bash = ["shellcheck"];
      };

      linters = {
        shellcheck = {
          args = [
            "-x"
          ];
        };
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
