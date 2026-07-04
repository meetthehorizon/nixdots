{
  config,
  lib,
  ...
}: let
  installedPlugins = config.programs.nixvim.plugins;
in {
  programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;

      settings = {
        keymap = {
          "<C-space>" = ["show" "show_documentation" "hide_documentation"];
          "<C-y>" = ["select_and_accept"];
          "<C-n>" = ["select_next" "fallback"];
          "<C-p>" = ["select_prev" "fallback"];
        };

        sources = {
          default =
            (lib.optional installedPlugins.lsp.enable "lsp")
            ++ (lib.optional installedPlugins.luasnip.enable "snippets")
            ++ [
              "path"
              "buffer"
            ];
        };

        completion = {
          menu = {
            border = "rounded";
          };
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200;
            window = {
              border = "rounded";
            };
          };
        };

        signature = {
          enabled = true;
          window.border = "rounded";
        };
      };
    };
  };
}
