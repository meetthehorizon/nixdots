{
  config,
  lib,
  ...
}: let
  plugins = config.programs.nixvim.plugins;
in {
  programs.nixvim.keymaps =
    [
      # Diagnostics
      {
        mode = "n";
        key = "<leader>df";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Open [D]iagnostic [F]loat";
      }
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>";
        options.desc = "Previous Diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>";
        options.desc = "Next Diagnostic";
      }
      {
        mode = "n";
        key = "[D";
        action = "<cmd>lua vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })<CR>";
        options.desc = "Previous Error";
      }
      {
        mode = "n";
        key = "]D";
        action = "<cmd>lua vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })<CR>";
        options.desc = "Next Error";
      }
    ]
    # Debugger
    ++ lib.optionals plugins.dap.enable [
      {
        mode = "n";
        key = "<F5>";
        action = "<cmd>lua require('dap').continue()<CR>";
        options.desc = "Debug: Start/Continue";
      }
      {
        mode = "n";
        key = "<F9>";
        action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
        options.desc = "Debug: Toggle Breakpoint";
      }
      {
        mode = "n";
        key = "<F10>";
        action = "<cmd>lua require('dap').step_over()<CR>";
        options.desc = "DAP: Step Over";
      }
      {
        mode = "n";
        key = "<F11>";
        action = "<cmd>lua require('dap').step_into()<CR>";
        options.desc = "DAP: Step Into";
      }
      {
        mode = "n";
        key = "<F12>";
        action = "<cmd>lua require('dap').step_out()<CR>";
        options.desc = "DAP: Step Out";
      }
    ]
    ++ lib.optionals plugins.dap-ui.enable [
      {
        mode = "n";
        key = "<leader>du";
        action = "<cmd>lua require('dapui').toggle()<CR>";
        options.desc = "DAP UI: Toggle";
      }
      {
        mode = ["n" "v"];
        key = "<leader>de";
        action = "<cmd>lua require('dapui').eval()<CR>";
        options.desc = "DAP UI: Evaluate Expression";
      }
    ]
    # File Explorer
    ++ lib.optional plugins.oil.enable {
      mode = "n";
      key = "-";
      action = "<cmd>Oil<CR>";
      options.desc = "Open File Explorer";
    }
    # Format Code
    ++ lib.optional plugins.conform-nvim.enable {
      mode = ["n" "v"];
      key = "<leader>lf";
      action = "<cmd>lua require('conform').format({ async = true, lsp_format = 'fallback' })<CR>";
      options.desc = "Format Document (Conform)";
    }
    # Gitsigns
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
    # LSP
    ++ lib.optionals plugins.lsp.enable [
      {
        mode = "n";
        key = "gD";
        action = "<cmd>lua vim.lsp.buf.declaration()<CR>";
        options.desc = "Go to Declaration";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Hover Documentation";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
        options.desc = "Signature Help";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>lua vim.lsp.buf.rename()<CR>";
        options.desc = "LSP Rename Symbol";
      }
      {
        mode = ["n" "v"];
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "LSP Code Action";
      }
    ]
    # Notifications
    ++ lib.optional plugins.notify.enable
    {
      mode = "n";
      key = "<leader>nc";
      action = "<cmd>lua require('notify').dismiss({ silent = true, pending = true })<CR>";
      options.desc = "[N]otifications [C]lear";
    }
    # Telescope
    ++ lib.optionals plugins.telescope.enable [
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
        action = "<cmd>Telescope diagnostics<CR>";
        options.desc = "[S]earch [D]iagnostics [W]orkspace";
      }
      {
        mode = "n";
        key = "gd";
        action = "<cmd>Telescope lsp_definitions<CR>";
        options.desc = "Go to Definition";
      }
      {
        mode = "n";
        key = "gt";
        action = "<cmd>Telescope lsp_type_definitions<CR>";
        options.desc = "Go to Type Definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>Telescope lsp_references<CR>";
        options.desc = "Go to References";
      }
      {
        mode = "n";
        key = "gi";
        action = "<cmd>Telescope lsp_implementations<CR>";
        options.desc = "Go to Implementation";
      }
      {
        mode = "n";
        key = "<leader>sS";
        action = "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>";
        options.desc = "[S]earch Workspace [S]ymbols";
      }
      {
        mode = "n";
        key = "<leader>sc";
        action = "<cmd>Telescope commands<CR>";
        options.desc = "[S]earch [C]ommands";
      }
      {
        mode = "n";
        key = "<leader>sh";
        action = "<cmd>Telescope help_tags<CR>";
        options.desc = "[S]earch [H]elp";
      }
      {
        mode = "n";
        key = "<leader>sk";
        action = "<cmd>Telescope keymaps<CR>";
        options.desc = "[S]earch [K]eymaps";
      }
      {
        mode = "n";
        key = "<leader>ss";
        action = "<cmd>Telescope lsp_document_symbols<CR>";
        options.desc = "[S]earch [S]ymbols";
      }
    ]
    # Python venv selector
    ++ lib.optional plugins.venv-selector.enable {
      mode = "n";
      key = "<leader>vs";
      action = "<cmd>VenvSelect<CR>";
      options.desc = "Select Virtual Environment";
    };
}
