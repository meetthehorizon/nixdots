{
  config,
  lib,
  ...
}: let
  installedPlugins = config.programs.nixvim.plugins;
in {
  programs.nixvim = {
    plugins = {
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = ''
            function(args)
              require("luasnip").lsp_expand(args.body)
            end
          '';
          sources =
            (lib.optional installedPlugins.lsp.enable {name = "nvim_lsp";})
            ++ (lib.optional installedPlugins.luasnip.enable {name = "luasnip";})
            ++ [
              {name = "path";}
              {name = "buffer";}
            ];

          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-y>" = "cmp.mapping.confirm({ select = true })";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };

      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-nvim-lsp.enable = installedPlugins.lsp.enable;
      cmp_luasnip.enable = installedPlugins.luasnip.enable;
    };
  };
}
