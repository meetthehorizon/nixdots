{config, ...}: {
  services.mako = {
    enable = true;
    settings = {
      font = "${config.theme.fonts.sans} ${toString config.theme.fonts.sizes.mako}";
      background-color = "${config.theme.colors.background}bd";
      text-color = config.theme.colors.foreground;
      border-color = config.theme.colors.accent;
      border-size = 2;
      border-radius = 4;
      default-timeout = 5000;
    };
  };
}
