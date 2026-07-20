{
  lib,
  config,
  ...
}: {
  programs.wezterm = {
    enable = true;
    colorSchemes = with config.color; {
      Nix = {
        ansi = with terminal; [
          black
          red
          green
          yellow
          blue
          magenta
          cyan
          white
        ];

        bright = with terminal; [
          black
          red
          green
          yellow
          blue
          magenta
          cyan
          white
        ];

        foreground = text;
        background = surface;

        cursor_fg = surface;
        cursor_bg = text;
        cursor_border = outline;

        selection_bg = surfaceVariant;
        selection_fg = accent;
      };
    };

    settings = with config; {
      font = lib.generators.mkLuaInline ''wezterm.font("${font.mono}")'';
      font_size = font.size.base;

      color_scheme = "Nix";
      window_background_opacity = ui.effects.surfaceAlpha;

      hide_tab_bar_if_only_one_tab = true;

      keys = with lib.generators; [
        {
          key = "s";
          mods = "CTRL";
          action = mkLuaInline ''wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }'';
        }
        {
          key = "v";
          mods = "CTRL";
          action = mkLuaInline ''wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }'';
        }
        {
          key = "h";
          mods = "CTRL";
          action = mkLuaInline ''wezterm.action.ActivatePaneDirection 'Left' '';
        }
        {
          key = "j";
          mods = "CTRL";
          action = mkLuaInline ''wezterm.action.ActivatePaneDirection 'Down' '';
        }
        {
          key = "k";
          mods = "CTRL";
          action = mkLuaInline ''wezterm.action.ActivatePaneDirection 'Up' '';
        }
        {
          key = "l";
          mods = "CTRL";
          action = mkLuaInline ''wezterm.action.ActivatePaneDirection 'Right' '';
        }
        {
          key = "x";
          mods = "CTRL";
          action = mkLuaInline ''wezterm.action.CloseCurrentPane { confirm = false }'';
        }
        {
          key = "l";
          mods = "CTRL|SHIFT";
          action = mkLuaInline ''wezterm.action.DisableDefaultAssignment'';
        }
      ];
    };
  };
}
