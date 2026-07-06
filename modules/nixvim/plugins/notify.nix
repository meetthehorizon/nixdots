{
  programs.nixvim.plugins.notify = {
    enable = true;
    settings = {
      stages = "static";
      render = "minimal";
      timeout = 3000;
      topDown = false;
      maxWidth = 60;
    };
  };
}
