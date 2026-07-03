{pkgs, ...}: {
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 500;
        };
        formatters_by_ft = {
          nix = ["alejandra"];
          go = [
            "goimports"
            "gofmt"
          ];
          cpp = ["clang-format"];
          lua = ["stylua"];
          javascript = ["prettier"];
          typescript = ["prettier"];
        };
      };
    };

    extraPackages = with pkgs; [
      alejandra
      clang-tools
      gotools
      stylua
      typescript-language-server
      prettier
    ];
  };
}
