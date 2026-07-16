{ config, ... }: let
  sans = config.font.sans;
  mono = config.font.mono;
  size = builtins.toString (config.font.size.base + 3);
  weight = builtins.toString config.font.weight.normal;
in {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      enableDebug = true;
    };

    style = ''
      /* =========================================================================
         1. GLOBAL RESETS & FONTS
         ========================================================================= */
      * {
        font-size: ${size}px;
        font-family: "${sans}", "Symbols Nerd Font", "${mono}";
        font-weight: ${weight};
        min-height: 0;
      }

      /* =========================================================================
         2. WINDOW CONFIGURATION
         ========================================================================= */
      window#waybar {
        background: rgba(0, 0, 0, 0.1);
      }

      /* =========================================================================
         3. MODULE LAYOUT
         ========================================================================= */
      .modules-left,
      .modules-center,
      .modules-right {
        padding: 4px;
      }

      /* =========================================================================
         4. MODULE STYLES (frosted glass)
         ========================================================================= */
      #window,
      #bluetooth,
      #clock,
      #network,
      #wireplumber,
      #battery,
      #backlight,
      #workspaces button,
      #custom-fan,
      #user,
      #mpris,
      #power-profiles-daemon,
      #tray {
        padding: 3px 5px;
        color: white;
        margin: 2px;
        border-radius: 1px;
        border: 0px solid rgba(255, 255, 255, 0.3);
        box-shadow:
          inset 0 1px 0 rgba(255, 255, 255, 0.06),
          0 6px 20px rgba(0, 0, 0, 0.25);
        background: rgba(0, 0, 0, 1);
        transition: all 120ms ease-out;
      }

      #image {
        margin: 2px;
      }

      /* =========================================================================
         5. INTERACTIVE ELEMENTS (hover)
         ========================================================================= */
      #workspaces button:hover,
      #clock:hover,
      #battery:hover,
      #network:hover,
      #bluetooth:hover,
      #wireplumber:hover,
      #backlight:hover,
      #power-profiles-daemon:hover,
      #mpris:hover,
      #user:hover {
        background: rgba(255, 255, 255, 0.1);
      }

      /* =========================================================================
         6. TOOLTIPS
         ========================================================================= */
      tooltip {
        padding: 4px 6px;
        margin: 3px;
        border-radius: 5px;
        border: 1px solid rgba(255, 255, 255, 0.3);
        box-shadow:
          inset 0 1px 0 rgba(255, 255, 255, 0.06),
          0 6px 20px rgba(0, 0, 0, 0.25);
        background: rgb(0, 0, 0);
      }

      /* =========================================================================
         7. STATUS INDICATORS
         ========================================================================= */

      /* --- Success / Good State (Green) --- */
      #battery.charging,
      #power-profiles-daemon.power-saver {
        border-color: rgba(166, 227, 161, 0.3);
        color: rgba(166, 227, 161, 0.7);
      }

      /* --- Active / Focus State (Teal) --- */
      #window.active,
      #workspaces button.active,
      #mpris {
        border-color: rgba(148, 226, 213, 0.3);
        color: rgba(148, 226, 213, 0.7);
      }

      /* --- Warning / Progress State (Yellow) --- */
      #battery.bat_30,
      #battery.bat_40,
      #battery.bat_50,
      #bluetooth.discovering,
      #bluetooth.discoverable,
      #mpris.paused,
      #power-profiles-daemon.balanced {
        border-color: rgba(249, 226, 175, 0.1);
        color: rgba(249, 226, 175, 0.7);
      }

      /* --- Critical / Urgent State (Red) --- */
      #battery.bat_0,
      #battery.bat_10,
      #battery.bat_20,
      #network.disabled,
      #network.disconnected,
      #bluetooth.disabled,
      #bluetooth.no-controller,
      #bluetooth.off,
      #wireplumber.muted,
      #workspaces button.urgent,
      #power-profiles-daemon.performance {
        border-color: rgba(243, 139, 168, 0.3);
        color: rgba(243, 139, 168, 0.7);
      }
    '';
  };

  xdg.configFile = {
    "waybar/config.jsonc".source = ./waybar.jsonc;
  };
}
