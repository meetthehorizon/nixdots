{...}: {
  programs.nixvim.plugins.emmet = {
    enable = true;
    settings = {
      mode = "inv";
      leader_key = "<C-e>";
      filetypes = [
        "css"
        "html"
        "javascript"
        "javascriptreact"
        "svelte"
        "typescript"
        "typescriptreact"
      ];
    };
  };
}