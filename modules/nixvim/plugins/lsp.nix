{...}: {
  programs.nixvim = {
    plugins = {
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
    };
  };
}
