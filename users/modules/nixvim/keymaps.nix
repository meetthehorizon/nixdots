{...}: {
  programs.nixvim.keymaps = [
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
}
