{
  config,
  lib,
  ...
}: let
  plugins = config.programs.nixvim.plugins;
in {
  programs.nixvim.keymaps =
    [
      ## Diagnostics
      {
        mode = "n";
        key = "<leader>d";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Open Diagnostic Float";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Previous Diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Next Diagnostic";
      }
      {
        mode = "n";
        key = "<leader>dl";
        action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
        options.desc = "Add Diagnostics to Location List";
      }
    ]
    ++ lib.optional plugins.oil.enable
    {
      mode = "n";
      key = "-";
      action = "<cmd>Oil<CR>";
      options = {
        desc = "Open File Explorer";
      };
    }
    ++ lib.optionals plugins.gitsigns.enable [
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
    ]
    ++ lib.optionals config.programs.nixvim.plugins.lsp.enable [
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
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "LSP Code Action";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>lua vim.lsp.buf.rename()<CR>";
        options.desc = "LSP Rename Symbol";
      }
      {
        mode = "n";
        key = "<leader>lf";
        action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
        options.desc = "LSP Format Document";
      }
    ]
    ++ lib.optionals config.programs.nixvim.plugins.telescope.enable [
      {
        mode = "n";
        key = "<leader>sf";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "[S]earch [F]iles";
      }
      {
        mode = "n";
        key = "<leader>sg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "[S]earch [G]rep";
      }
      {
        mode = "n";
        key = "<leader>sb";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "[S]earch [B]uffers";
      }
      {
        mode = "n";
        key = "<leader>sdb";
        action = "<cmd>Telescope diagnostics bufnr=0<CR>";
        options.desc = "[S]earch [D]iagnostics [B]uffer";
      }
      {
        mode = "n";
        key = "<leader>sdw";
        action = "<cmd>Telescope diagnostics<CR>"; # <-- Notice bufnr=0 is gone!
        options.desc = "[S]earch [D]iagnostics [W]orkspace";
      }
    ];
}
