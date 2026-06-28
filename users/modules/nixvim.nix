{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    globals.mapleader = " ";
    globals.maplocalleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      clipboard = "unnamedplus";
    };

    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night";
        transparent = true;
        styles = {
          sidebars = "transparent";
          floats = "transparent";
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<CR>";
        options = {
          desc = "Open File Explorer";
        };
      }
      {
        mode = "n";
        key = "]h";
        action = "<cmd>Gitsigns next_hunk<CR>";
        options.desc = "Next Git Hunk";
      }
      {
        mode = "n";
        key = "[h";
        action = "<cmd>Gitsigns prev_hunk<CR>";
        options.desc = "Previous Git Hunk";
      }
      {
        mode = "n";
        key = "<leader>gp";
        action = "<cmd>Gitsigns preview_hunk<CR>";
        options.desc = "Preview Git Hunk";
      }
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>Gitsigns stage_hunk<CR>";
        options.desc = "Stage Hunk";
      }
      {
        mode = "n";
        key = "<leader>gr";
        action = "<cmd>Gitsigns reset_hunk<CR>";
        options.desc = "Reset Hunk";
      }
      {
        mode = "n";
        key = "<leader>gu";
        action = "<cmd>Gitsigns undo_stage_hunk<CR>";
        options.desc = "Undo Stage Hunk";
      }
      {
        mode = "n";
        key = "<leader>gS";
        action = "<cmd>Gitsigns stage_buffer<CR>";
        options.desc = "Stage Entire Buffer";
      }
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Go to Definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<CR>";
        options.desc = "Go to References";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Hover Documentation";
      }
      {
        mode = "n";
        key = "<leader>sf";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>sg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Live Grep";
      }
      {
        mode = "n";
        key = "<leader>sb";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "Search Buffers";
      }
    ];

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
            # Swapped to Alejandra!
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

      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          delete_to_trash = true;
          skip_confirm_for_simple_edits = true;
        };
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

    extraConfigLua = ''
      require("luasnip.loaders.from_lua").load({
        paths = {
          "${./snippets}"
        }
      })
    '';

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
