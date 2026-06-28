{pkgs, ...}: {
  programs.nixvim = {
    plugins.lualine.enable = true;
    plugins = {
      web-devicons.enable = true;
      treesitter.enable = true;

      mini = {
        enable = true;
        modules = {
          icons = {
            directory = {
              "bin" = {glyph = "";};
              "cmd" = {glyph = "";};
              "db" = {glyph = "󰆼";};
              "migrations" = {glyph = "󰳿";};
              "env" = {glyph = "";};
              "scripts" = {glyph = "󰯂";};
              "tmp" = {glyph = "󰩺";};
              "src" = {glyph = "";};
              "api" = {glyph = "󰒋";};
              "pkg" = {glyph = "󰏖";};
              "internal" = {glyph = "";};
              "assets" = {glyph = "󰉔";};
              "component" = {glyph = "󰐱";};
              "components" = {glyph = "󰐱";};
              "public" = {glyph = "";};
              "docs" = {glyph = "󱔗";};
              "doc" = {glyph = "󰈙";};
              "test" = {glyph = "󰙨";};
              "tests" = {glyph = "󰙨";};
              ".git" = {glyph = "󰊢";};
              ".github" = {glyph = "󰊤";};
              "node_modules" = {glyph = "󰎙";};
            };
          };
        };
      };

      telescope.enable = true;

      lsp = {
        enable = true;
        servers = {
          clangd.enable = true;
          gopls.enable = true;
          nixd.enable = true;
          lua_ls.enable = true;
          ts_ls.enable = true;
        };
      };

      conform-nvim = {
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

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = ''
            function(args)
              require("luasnip").lsp_expand(args.body)
            end
          '';
          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
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
      luasnip.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;
      cmp-nvim-lsp.enable = true;

      oil.enable = true;
      oil.settings = {
        default_file_explorer = true;
        delete_to_trash = true;
        skip_confirm_for_simple_edits = true;
      };

      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          current_line_blame_opts = {
            delay = 500;
          };
          signs = {
            add = {text = "";};
            change = {text = "";};
            delete = {text = "_";};
            topdelete = {text = "‾";};
            changedelete = {text = "~";};
          };
        };
      };

      nvim-autopairs.enable = true;
      which-key.enable = true;
    };

    extraPackages = with pkgs; [
      alejandra
      gotools
      stylua
      typescript-language-server
      prettier
      ripgrep
    ];
  };
}
