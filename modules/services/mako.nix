{config, ...}: {
  services.mako = {
    enable = true;
    settings = {
      font = "${config.font.sans} ${toString config.font.size.base}";
      background-color = "${config.color.surface}bd";
      text-color = config.color.text;
      border-color = config.color.accent;
      border-size = 2;
      border-radius = 4;
      default-timeout = 5000;
    };
  };
}
