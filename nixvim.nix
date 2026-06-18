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

    # Global Keymaps for Jumping Between Errors
    keymaps = [
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Jump to Previous Diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Jump to Next Diagnostic";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Show Diagnostic Error Float";
      }
    ];

    plugins.lualine.enable = true;

    plugins = {
      web-devicons.enable = true;
      treesitter.enable = true;

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
    };

    extraPackages = with pkgs; [
      alejandra # The new formatter binary
      gotools
      stylua
    ];
  };
}
