{...}: {
  programs.nixvim = {
    plugins.luasnip.enable = true;
    plugins.friendly-snippets.enable = true;
    extraConfigLua = ''
      require("luasnip.loaders.from_lua").load({
        paths = {
          "${../snippets}"
        }
      })
    '';
  };
}
