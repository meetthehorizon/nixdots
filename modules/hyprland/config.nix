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
  toRGB = hex: "rgb(${lib.removePrefix "#" hex})";
in {
  home.packages = with pkgs; [
    hyprlauncher
    wl-clipboard
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    systemd.enable = true;
    package = null;
    portalPackage = null;
    systemd.variables = ["--all"];
    settings = {
      mod._var = "SUPER";
      terminal._var = "kitty";
      launcher._var = "hyprlauncher";
      browser._var = "firefox";

      config = {
        general = with config.color; {
          gaps_in = config.ui.spacing.s1;
          gaps_out = config.ui.spacing.s2;
          border_size = 0;
          allow_tearing = false;
          layout = "dwindle";
          "col.active_border" = toRGB accent;
          "col.inactive_border" = toRGB terminal.gray;
        };
        xwayland = {
          force_zero_scaling = true;
        };
        decoration = {
          rounding = config.ui.radius.r1;
          rounding_power = 1;
          blur = {
            enabled = true;
            size = 10;
            passes = 3;
            new_optimizations = true;
            noise = 0.02;
            contrast = 1.0;
            brightness = 0.7;
            xray = false;
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
        render.cm_enabled = true;
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
        hl.exec_cmd("dbus-update-activation-environment --systemd --all")
        hl.exec_cmd("rog-control-center", { worksapce = "silent" })
        hl.exec_cmd("hyprctl setcursor ${config.cursorTheme} 24")
        hl.exec_cmd(terminal .. " -e nvim", { workspace = "1 silent" })
        hl.exec_cmd(browser, { workspace = "2 silent" })
        hl.exec_cmd(terminal, { workspace = "3 silent" })
        hl.exec_cmd("spotify", { workspace = "4 silent" })
        hl.dispatch(hl.dsp.focus({ workspace = "3" }))
      end)
    '';
  };
}
