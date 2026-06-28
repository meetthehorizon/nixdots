{
  config,
  pkgs,
  lib,
  ...
}: let
  makeLuaCode = bindList:
    map (args: {
      _args =
        map (
          arg:
            if builtins.isAttrs arg
            then arg
            else lib.generators.mkLuaInline arg
        )
        args;
    })
    bindList;
in {
  home.packages = with pkgs; [
    hyprlauncher
    wl-clipboard
  ];

  programs.hyprshot.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = {
      mod._var = "SUPER";
      terminal._var = "kitty";
      launcher._var = "hyprlauncher";

      config = {
        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          allow_tearing = false;
          layout = "dwindle";
          "col.active_border" = config.theme.colors.accent_rgba;
          "col.inactive_border" = config.theme.colors.inactive_border_rgba;
        };
        xwayland = {
          force_zero_scaling = true;
        };
        decoration = {
          rounding = 4;
          rounding_power = 1;
          blur = {
            enabled = true;
            size = 10;
            passes = 3;
            new_optimizations = true;
            noise = 0.02;
            contrast = 1.0;
            brightness = 0.7;
            xray = true;
          };
        };
        input = {
          kb_layout = "us";
          kb_options = "caps:escape";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
          };
        };
        render = {
          cm_enabled = true;
        };
      };

      monitor = makeLuaCode [
        [
          {
            output = "eDP-2";
            mode = "2880x1800@120";
            position = "0x0";
            scale = "1.25";
            bitdepth = 10;
            cm = "hdr";
          }
        ]
        [
          {
            output = "eDP-1";
            mode = "2880x1800@120";
            position = "0x0";
            scale = "1.25";
            bitdepth = 10;
            cm = "hdr";
          }
        ]
      ];
    };

    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("antigravity", { workspace = "1 silent" })
        hl.exec_cmd("firefox", { workspace = "2 silent" })
        hl.exec_cmd("kitty", { workspace = "3 silent" })
        hl.exec_cmd("spotify", { workspace = "4 silent" })
        hl.exec_cmd("obsidian", { workspace = "10 silent" })
        hl.dispatch(hl.dsp.focus({ workspace = "3" }))
      end)
    '';
  };
}
