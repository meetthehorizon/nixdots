{lib, ...}: {
  wayland.windowManager.hyprland.settings.layer_rule = {
    match = {
      namespace = "waybar-top|rofi";
    };
    blur = true;
    xray = true;
  };

  wayland.windowManager.hyprland.settings.window_rule = [
    {
      match = {
        class = "xdg-desktop-portal-gtk|footclient|rog-control-center";
      };
      float = true;
      min_size = lib.generators.mkLuaInline "{1000, 800}";
      max_size = lib.generators.mkLuaInline "{1000, 800}";
    }
  ];
}
