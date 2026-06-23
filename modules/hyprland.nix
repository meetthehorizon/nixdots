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
  programs.hyprshot.enable = true;
  services.hyprsunset = {
    enable = true;
    settings = {
      profile = [
        {
          time = "22:00";
          temperature = "3000";
          gamma = 0.9;
        }
      ];
    };
  };

  services.mako = {
    enable = true;
    settings = {
      font = "IBM Plex Sans 10";
      background-color = "#1e1e2ebd";
      text-color = "#cdd6f4";
      border-color = "#94e2d5";
      border-size = 2;
      border-radius = 4;
      default-timeout = 5000;
    };
  };

  systemd.user.services.awww = {
    Unit = {
      Description = "Awww Wallpaper Daemon";
      # Tie it to the lifecycle of your graphical Wayland session
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };

    Service = {
      # The absolute path to the binary ensures it always executes correctly
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      ExecStop = "${pkgs.awww}/bin/awww kill";
      Restart = "on-failure";
      RestartSec = "2"; # Wait 2 seconds before trying to restart
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = [
        {
          monitor = "";
          # Assuming you updated your assets.nix to output to this path!
          path = "${config.home.homeDirectory}/Pictures/Wallpapers/lock";
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
          border_color = "rgba(148, 226, 213, 1.0)";
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
          outer_color = "rgb(148, 226, 213)";
          inner_color = "rgba(30, 30, 46, 0.9)";
          font_color = "rgb(205, 214, 244)";
          fade_on_empty = false;
          font_family = "IBM Plex Sans";
          placeholder_text = "<span foreground=\"##ffffff80\">you shall not pass!</span>";
          hide_input = false;
          position = "0, -210";
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        # Day-Month-Date
        {
          monitor = "";
          text = "cmd[update:1000] echo -e \"$(date +\"%A, %B %d\")\"";
          color = "rgb(205, 214, 244)";
          font_size = 25;
          font_family = "IBM Plex Sans";
          position = "0, 350";
          halign = "center";
          valign = "center";
        }
        # Time (BOLD + brighter)
        {
          monitor = "";
          text = "cmd[update:1000] echo \"<b>$(date +%I:%M)</b>\"";
          color = "rgb(205, 214, 244)";
          font_size = 120;
          font_family = "IBM Plex Sans";
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          monitor = "";
          text = "  $USER";
          color = "rgb(205, 214, 244)";
          font_size = 18;
          font_family = "IBM Plex Sans";
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
      ];

      shape = [
        # USER-BOX
        {
          monitor = "";
          size = "300, 60";
          color = "rgba(30, 30, 46, 0.9)";
          rounding = -1;
          border_size = 0;
          border_color = "rgb(249, 226, 175)";
          rotate = 0.0;
          xray = false;
          position = "0, -130";
          halign = "center";
          valign = "center";
        }
        # OUTER BOX 1
        {
          monitor = "";
          size = "500, 700";
          color = "rgba(30, 30, 46, 0.6)";
          rounding = 1;
          border_size = 0;
          border_color = "rgb(148, 226, 213)";
          rotate = 0.0;
          xray = false;
          position = "0, 70";
          halign = "center";
          valign = "center";
        }
        # OUTER BOX 2 (Line)
        {
          monitor = "";
          size = "498, 0";
          color = "rgba(30, 30, 46, 0.6)";
          rounding = 0;
          border_size = 2;
          border_color = "rgb(148, 226, 213)";
          rotate = 0.0;
          xray = false;
          position = "0, -280";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

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
          "col.active_border" = "rgba(94e2d5aa)";
          "col.inactive_border" = "rgba(2a2a3aaa)";
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

      bind = makeLuaCode (
        [
          [
            ''mod .. " + SPACE"''
            ''hl.dsp.exec_cmd(launcher)''
            {
              description = "Open application launcher";
            }
          ]
          [
            ''mod .. " + Q"''
            ''hl.dsp.exec_cmd(terminal)''
            {
              description = "Open terminal";
            }
          ]
          [
            ''mod .. " + C"''
            ''hl.dsp.window.close()''
            {
              description = "Close focused window";
            }
          ]
          [
            ''mod .. " + M"''
            ''hl.dsp.exit()''
            {
              description = "Exit Hyprland completely";
              locked = true;
            }
          ]
          [
            ''"XF86AudioRaiseVolume"''
            ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0")''
            {
              description = "Raise Volume";
              locked = "true";
              repeating = "true";
            }
          ]
          [
            ''"XF86AudioLowerVolume"''
            ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- --limit 1.0")''
            {
              description = "Lower Volume";
              locked = "true";
              repeating = "true";
            }
          ]
          [
            ''"XF86AudioMute"''
            ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")''
            {
              description = "Toggle Mute State";
              locked = "true";
            }
          ]
          [
            ''"XF86AudioMicMute"''
            ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")''
            {
              description = "Toggle Mic Mute State";
              locked = "true";
            }
          ]
          [
            ''"XF86MonBrightnessUp"''
            ''hl.dsp.exec_cmd("brightnessctl -e4 -n40000 set 5%+ -d \"amdgpu_bl*\"")''
            {
              description = "Raise Brightness";
              locked = "true";
              repeating = "true";
            }
          ]
          [
            ''"XF86MonBrightnessDown"''
            ''hl.dsp.exec_cmd("brightnessctl -e4 -n40000 set 5%- -d \"amdgpu_bl*\"")''
            {
              description = "Lower Brightness";
              locked = "true";
              repeating = "true";
            }
          ]
          [
            ''"XF86AudioNext"''
            ''hl.dsp.exec_cmd("playerctl next")''
            {
              description = "Play Next Media";
              locked = "true";
            }
          ]
          [
            ''"XF86AudioPrev"''
            ''hl.dsp.exec_cmd("playerctl previous")''
            {
              description = "Play Previous Media";
              locked = "true";
            }
          ]
          [
            ''"XF86AudioPause"''
            ''hl.dsp.exec_cmd("playerctl play-pause")''
            {
              description = "Pause Media";
              locked = "true";
            }
          ]
          [
            ''"XF86AudioPlay"''
            ''hl.dsp.exec_cmd("playerctl play-pause")''
            {
              description = "Play Media";
              locked = "true";
            }
          ]
          [
            ''"XF86Launch1"''
            ''hl.dsp.exec_cmd("rog-control-center")''
            {
              description = "Launch ROG Control Center";
            }
          ]
          [
            ''"SUPER + SHIFT + S"''
            ''hl.dsp.exec_cmd("pidof slurp || hyprshot -m window -o ~/Pictures/Screenshots/")''
            {
              description = "Take Screenshot of Window";
            }
          ]
          [
            ''mod .. " + S"''
            ''hl.dsp.exec_cmd("pidof slurp || hyprshot -m region -o ~/Pictures/Screenshots/")''
            {
              description = "Take Screenshot of Region";
            }
          ]
          [
            ''mod .. " + N"''
            ''hl.dsp.exec_cmd("systemctl --user is-active --quiet hyprsunset && systemctl --user stop hyprsunset || systemctl --user start hyprsunset")''
            {
              description = "Toggle Night Light";
            }
          ]
          [
            ''mod .. " + F"''
            ''hl.dsp.window.fullscreen()''
            {
              description = "Toggle Fullscreen of Active Window";
            }
          ]
          [
            ''mod .. " + V"''
            ''hl.dsp.window.float()''
            {
              description = "Toggle Fullscreen of Active Window";
            }
          ]
          [
            ''mod .. " + h"''
            ''hl.dsp.focus({direction="l"})''
            {
              description = "Make Left Window Active";
              repeating = true;
            }
          ]
          [
            ''mod .. " + l"''
            ''hl.dsp.focus({direction="r"})''
            {
              description = "Make Left Window Active";
              repeating = true;
            }
          ]
          [
            ''mod .. " + k"''
            ''hl.dsp.focus({direction="u"})''
            {
              description = "Make Left Window Active";
              repeating = true;
            }
          ]
          [
            ''mod .. " + j"''
            ''hl.dsp.focus({direction="d"})''
            {
              description = "Make Left Window Active";
              repeating = true;
            }
          ]
          [
            ''mod .. " + mouse:272"''
            ''hl.dsp.window.drag()''
            {
              description = "Move Windows using mouse";
              mouse = true;
            }
          ]
          [
            ''mod .. " + mouse:273"''
            ''hl.dsp.window.resize()''
            {
              description = "Move Windows using mouse";
              mouse = true;
            }
          ]
          [
            ''mod .. " + SHIFT + L"''
            ''hl.dsp.exec_cmd("hyprlock")''
            {
              description = "Lock Screen";
            }
          ]
        ]
        ++ builtins.genList
        (i: [
          ''mod .. " + ${toString (i + 1)}"''
          ''hl.dsp.focus({ workspace = "${toString (i + 1)}" })''
          {
            description = "Focus workspace ${toString (i + 1)}";
          }
        ])
        9
        ++ builtins.genList
        (i: [
          ''mod .. " + SHIFT + ${toString (i + 1)}"''
          ''hl.dsp.window.move({ workspace = "${toString (i + 1)}" })''
          {
            description = "Move window to workspace ${toString (i + 1)}";
          }
        ])
        9
      );
    };
    extraConfig = "";
  };
}
