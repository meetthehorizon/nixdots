{...}: {
  programs.nixvim = {
    plugins.luasnip.enable = true;
    extraConfigLua = ''
      require("luasnip.loaders.from_lua").load({
        paths = {
          "${../snippets}"
        }
      })
    '';
  };
}
