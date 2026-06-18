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

      telescope = {
        enable = true;
        keymaps = {
          "<leader>sf" = "find_files";
          "<leader>sg" = "live_grep";
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
            lua = ["stylua"];
          };
        };
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
          ];
          mapping = {
            "<C-y>" = "cmp.mapping.confirm({ select = true })";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          };
        };
      };

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

    extraPackages = with pkgs; [
      alejandra # The new formatter binary
      gotools
      stylua
    ];
  };
}
