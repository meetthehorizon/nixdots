{
  programs.nixvim = {
    plugins.venv-selector = {
      enable = true;
      autoLoad = true;
    };
  };
}
