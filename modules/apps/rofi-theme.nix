{config, lib, ...}: let
  # Convert float alpha (0-1) to two-char hex
  hexAlpha = a: let
    v = builtins.floor (a * 255);
    hex = "0123456789abcdef";
    hi = builtins.substring (v / 16) 1 hex;
    lo = builtins.substring (v - ((v / 16) * 16)) 1 hex;
  in "${hi}${lo}";

  alpha = config.ui.effects.surfaceAlpha;
  a = hexAlpha alpha;

  # Build #RRGGBBAA from config color + computed alpha
  withAlpha = hex: a': "${hex}${a'}";

  borderAlpha = hexAlpha 0.3;
  placeholderAlpha = hexAlpha 0.6;
  selectedAlpha = hexAlpha 0.2;
in {
  xdg.configFile."rofi/themes/custom.rasi".text = ''
    * {
      background-color: ${withAlpha config.color.surface a};
      foreground-color: ${config.color.text};
      border-color:     ${withAlpha config.color.accent borderAlpha};
      spacing: 0;
      padding: 0;
    }

    #window {
      background-color: inherit;
      border-radius:    ${toString config.ui.radius.r2}px;
      padding:          8px;
    }

    #inputbar {
      background-color: ${withAlpha config.color.surfaceVariant a};
      border-radius:    ${toString config.ui.radius.r1}px;
      padding:          8px 12px;
    }

    #entry {
      placeholder:       "Search...";
      placeholder-color: ${withAlpha config.color.textMuted placeholderAlpha};
    }

    #listview {
      background-color: inherit;
      padding:          4px 0;
      lines:            10;
    }

    element {
      padding:       6px 12px;
      border-radius: ${toString config.ui.radius.r1}px;
    }

    element selected {
      background-color: ${withAlpha config.color.accent selectedAlpha};
      text-color:       ${config.color.accent};
    }
  '';
}
