{
  config,
  lib,
  ...
}: let
  toRGB = hex: "rgb(${lib.removePrefix "#" hex})";
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          monitor = "";
          path = "${config.home.homeDirectory}/.cache/hyprlock-bg";
          blur_passes = 3;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      image = [
        {
          monitor = "";
          path = "${config.assets.userIcon}";
          border_size = 0;
          border_color = toRGB config.color.accent;
          size = 180;
          rounding = -1;
          rotate = 0.0;
          reload_time = -1;
          reload_cmd = "";
          position = "0, 40";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = with config.color; [
        {
          monitor = "";
          size = "300, 60";
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = toRGB accent;
          inner_color = toRGB surface;
          font_color = toRGB text;
          fade_on_empty = false;
          font_family = config.font.sans;
          placeholder_text = "<span foreground=\"##ffffff80\">you shall not pass!</span>";
          hide_input = false;
          position = "0, -210";
          halign = "center";
          valign = "center";
        }
      ];

      label = with config.font; [
        {
          monitor = "";
          text = "cmd[update:1000] echo -e \"$(date +\"%A, %B %d\")\"";
          color = toRGB config.color.text;
          font_size = size."xl";
          font_family = sans;
          position = "0, 350";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b>$(date +%I:%M)</b>\"";
          color = toRGB config.color.text;
          font_size = size."8xl";
          font_family = sans;
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "  $USER";
          color = toRGB config.color.text;
          font_size = size.lg;
          font_family = sans;
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
      ];

      shape = with config.color; [
        {
          monitor = "";
          size = "300, 60";
          color = toRGB surface;
          rounding = -1;
          border_size = 0;
          border_color = toRGB terminal.yellow;
          rotate = 0.0;
          xray = false;
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          size = "500, 700";
          color = toRGB surface;
          rounding = 1;
          border_size = 0;
          border_color = toRGB accent;
          rotate = 0.0;
          xray = false;
          position = "0, 70";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          size = "498, 0";
          color = toRGB surface;
          rounding = 0;
          border_size = 2;
          border_color = toRGB accent;
          rotate = 0.0;
          xray = false;
          position = "0, -280";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  home.activation.setupHyprlockBg = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -L "$HOME/.cache/hyprlock-bg" ]; then
      $DRY_RUN_CMD ln -sf ${toString config.assets.lockScreen} "$HOME/.cache/hyprlock-bg"
    fi
  '';
}
