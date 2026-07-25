{
  config,
  lib,
  ...
}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300; # 5min — lock screen
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330; # 5.5min — turn off display
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30min — suspend
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
