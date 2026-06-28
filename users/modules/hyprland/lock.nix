{
  config,
  pkgs,
  ...
}: let
  assets = import ../assets.nix {inherit pkgs;};
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          monitor = "";
          path = toString assets.lockScreen;
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
          path = "${config.home.homeDirectory}/.face";
          border_size = 0;
          border_color = config.theme.colors.accent_rgba;
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

      input-field = [
        {
          monitor = "";
          size = "300, 60";
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = config.theme.colors.accent_rgb;
          inner_color = config.theme.colors.background_rgba;
          font_color = config.theme.colors.foreground_rgb;
          fade_on_empty = false;
          font_family = config.theme.fonts.sans;
          placeholder_text = "<span foreground=\"##ffffff80\">you shall not pass!</span>";
          hide_input = false;
          position = "0, -210";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo -e \"$(date +\"%A, %B %d\")\"";
          color = config.theme.colors.foreground_rgb;
          font_size = 25;
          font_family = config.theme.fonts.sans;
          position = "0, 350";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b>$(date +%I:%M)</b>\"";
          color = config.theme.colors.foreground_rgb;
          font_size = 120;
          font_family = config.theme.fonts.sans;
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "  $USER";
          color = config.theme.colors.foreground_rgb;
          font_size = 18;
          font_family = config.theme.fonts.sans;
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
      ];

      shape = [
        {
          monitor = "";
          size = "300, 60";
          color = config.theme.colors.background_rgba;
          rounding = -1;
          border_size = 0;
          border_color = config.theme.colors.yellow_rgb;
          rotate = 0.0;
          xray = false;
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          size = "500, 700";
          color = config.theme.colors.background_rgba;
          rounding = 1;
          border_size = 0;
          border_color = config.theme.colors.accent_rgb;
          rotate = 0.0;
          xray = false;
          position = "0, 70";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          size = "498, 0";
          color = config.theme.colors.background_rgba;
          rounding = 0;
          border_size = 2;
          border_color = config.theme.colors.accent_rgb;
          rotate = 0.0;
          xray = false;
          position = "0, -280";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
