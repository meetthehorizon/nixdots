{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    globals.mapleader = " ";
    globals.maplocalleader = " ";

    opts = {
      list = true;
      listchars = {
        lead = "·";
        tab = "> ";
        eol = "󰘌";
        trail = "~";
      };
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
  };
}
