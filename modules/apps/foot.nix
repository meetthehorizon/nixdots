{config, ...}: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = with config; {
      main = {
        font = with font; "${mono}:size=${toString size.base}";
        term = "xterm-256color";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      colors-dark = {
        alpha = "${toString ui.effects.surfaceAlpha}";
      };
    };
  };
}
