{...}: {
  programs.nixvim = {
    plugins.gitsigns = {
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
  };
}
