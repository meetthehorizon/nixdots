{
  lib,
  config,
  ...
}: let
  makeLuaCode = map (args: {
    _args =
      map (
        arg:
          if builtins.isAttrs arg
          then arg
          else lib.generators.mkLuaInline arg
      )
      args;
  });
in {
  wayland.windowManager.hyprland.settings.bind = makeLuaCode (
    [
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
        ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ --limit 1.0")''
        {
          description = "Raise Volume";
          locked = "true";
          repeating = "true";
        }
      ]
      [
        ''"XF86AudioLowerVolume"''
        ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%- --limit 1.0")''
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
        ''hl.dsp.exec_cmd("brightnessctl -e4 -n40000 set 2%+ -d \"amdgpu_bl*\"")''
        {
          description = "Raise Brightness";
          locked = "true";
          repeating = "true";
        }
      ]
      [
        ''"XF86MonBrightnessDown"''
        ''hl.dsp.exec_cmd("brightnessctl -e4 -n40000 set 2%- -d \"amdgpu_bl*\"")''
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
        ''hl.dsp.exec_cmd("pidof slurp || hyprshot -m window")''
        {
          description = "Take Screenshot of Window";
        }
      ]
      [
        ''mod .. " + S"''
        ''hl.dsp.exec_cmd("pidof slurp || hyprshot -m region")''
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
    ++ lib.optionals config.programs.rofi.enable [
      [
        ''mod .. " + SPACE"''
        ''hl.dsp.exec_cmd("rofi -show combi")''
        {
          description = "Open rofi combi mode";
        }
      ]
      [
        ''mod .. " + E"''
        ''hl.dsp.exec_cmd("rofi -show recursivebrowser")''
        {
          description = "Open rofi recursivebrowser mode";
        }
      ]
      [
        ''"SUPER + SHIFT + SPACE"''
        ''hl.dsp.exec_cmd("rofi -show drun")''
        {
          description = "Open rofi drun mode";
        }
      ]
    ]
    ++ builtins.genList
    (i: let
      ws = i + 1;
      key =
        if ws == 10
        then "0"
        else toString ws;
    in [
      ''mod .. " + ${key}"''
      ''hl.dsp.focus({ workspace = "${toString ws}" })''
      {
        description = "Focus workspace ${toString ws}";
      }
    ])
    10
    ++ builtins.genList
    (i: let
      ws = i + 1;
      key =
        if ws == 10
        then "0"
        else toString ws;
    in [
      ''mod .. " + SHIFT + ${key}"''
      ''hl.dsp.window.move({ workspace = "${toString ws}" })''
      {
        description = "Move window to workspace ${toString ws}";
      }
    ])
    10
  );
}
