{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    layer_rule = {
      match = {
        namespace = "waybar-top|rofi";
      };
      blur = true;
      xray = true;
    };

    window_rule = [
      {
        match = {
          class = "xdg-desktop-portal-gtk|footclient|rog-control-center|.*seahorse.*|Anki";
        };
        float = true;
        min_size = lib.generators.mkLuaInline "{1000, 800}";
        max_size = lib.generators.mkLuaInline "{1000, 800}";
      }
      {
        match = {
          class = "feh";
        };
        float = true;
      }
    ];

    workspace_rule = [
      {
        workspace = "2";
        monitor = "eDP-1";
      }
      {
        workspace = "3";
        monitor = "eDP-1";
      }
      {
        workspace = "9";
        monitor = "eDP-1";
      }
      {
        workspace = "1";
        monitor = "DP-2";
      }
      {
        workspace = "10";
        monitor = "DP-2";
      }
    ];
  };
}
