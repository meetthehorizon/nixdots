{config, ...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          monitor = "";
          path = toString config.theme.assets.lockScreen;
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
          path = "${config.theme.assets.userIcon}";
          border_size = 0;
          border_color = config.theme.colors.accentRGBA;
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
          outer_color = config.theme.colors.accentRGB;
          inner_color = config.theme.colors.backgroundRGBA;
          font_color = config.theme.colors.foregroundRGB;
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
          color = config.theme.colors.foregroundRGB;
          font_size = 25;
          font_family = config.theme.fonts.sans;
          position = "0, 350";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b>$(date +%I:%M)</b>\"";
          color = config.theme.colors.foregroundRGB;
          font_size = 120;
          font_family = config.theme.fonts.sans;
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "  $USER";
          color = config.theme.colors.foregroundRGB;
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
          color = config.theme.colors.backgroundRGBA;
          rounding = -1;
          border_size = 0;
          border_color = config.theme.colors.yellowRGB;
          rotate = 0.0;
          xray = false;
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          size = "500, 700";
          color = config.theme.colors.backgroundRGBA;
          rounding = 1;
          border_size = 0;
          border_color = config.theme.colors.accentRGB;
          rotate = 0.0;
          xray = false;
          position = "0, 70";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          size = "498, 0";
          color = config.theme.colors.backgroundRGBA;
          rounding = 0;
          border_size = 2;
          border_color = config.theme.colors.accentRGB;
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
