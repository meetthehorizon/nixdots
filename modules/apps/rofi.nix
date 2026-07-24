{
  lib,
  pkgs,
  config,
  ...
}:
with pkgs; let
  rofi-power-menu = writeShellScriptBin "rofi-power-menu" ''
    if [ -z "$1" ]; then
      printf "Power Off\0icon\x1fsystem-shutdown\n"
      printf "Reboot\0icon\x1fsystem-reboot\n"
      printf "Sleep\0icon\x1fsystem-suspend\n"
      printf "Logout\0icon\x1fsystem-log-out\n"
    else
      case "$1" in
        Shutdown) systemctl poweroff ;;
        Restart)  systemctl reboot ;;
        Sleep)    systemctl suspend ;;
        Logout)   hyprctl dispatch exit ;;
      esac
    fi
  '';

  rofi-clean-files = writeShellScriptBin "rofi-clean-files" ''
    cd /home/${config.home.username}
    if [ -z "$1" ]; then
      ${fd}/bin/fd -t f . Documents Pictures Downloads | ${gawk}/bin/awk '
        {
          # Split by dot to find the extension
          n = split($0, parts, ".")
          ext = (n > 1) ? tolower(parts[n]) : ""

          # --- Images ---
          if      (ext == "jpg"  || ext == "jpeg") icon = "image-jpeg2000"
          else if (ext == "png")  icon = "image-png"
          else if (ext == "gif")  icon = "image-gif"
          else if (ext == "svg")  icon = "image-svg+xml-compressed"
          else if (ext == "webp" || ext == "bmp"  || ext == "ico"  || ext == "tiff" || ext == "tif") icon = "image-x-generic"

          # --- Video ---
          else if (ext == "mp4")  icon = "video-mp4"
          else if (ext == "mkv")  icon = "video-x-matroska"
          else if (ext == "webm") icon = "video-webm"
          else if (ext == "avi")  icon = "video-x-msvideo"
          else if (ext == "mov"  || ext == "flv"  || ext == "wmv") icon = "video-x-generic"

          # --- Audio ---
          else if (ext == "mp3")  icon = "audio-mpeg"
          else if (ext == "flac") icon = "audio-flac"
          else if (ext == "wav")  icon = "audio-x-wav"
          else if (ext == "ogg"  || ext == "opus" || ext == "aac"  || ext == "m4a") icon = "audio-x-generic"

          # --- Archives ---
          else if (ext == "zip")                  icon = "application-zip"
          else if (ext == "gz"  || ext == "tgz")  icon = "application-gzip"
          else if (ext == "rar")                  icon = "application-x-rar"
          else if (ext == "7z")                   icon = "application-x-7z-compressed"
          else if (ext == "tar" || ext == "bz2" || ext == "xz") icon = "package-x-generic"

          # --- Documents ---
          else if (ext == "pdf")                  icon = "application-pdf"
          else if (ext == "doc"  || ext == "docx") icon = "application-msword"
          else if (ext == "xls"  || ext == "xlsx" || ext == "csv")  icon = "x-office-spreadsheet"
          else if (ext == "ppt"  || ext == "pptx") icon = "x-office-presentation"
          else if (ext == "odt"  || ext == "ods"  || ext == "odp") icon = "x-office-document"
          else if (ext == "rtf")  icon = "application-rtf"
          else if (ext == "epub") icon = "application-epub+zip"

          # --- Code / Text ---
          else if (ext == "py")   icon = "text-x-python"
          else if (ext == "rs")   icon = "text-x-rust"
          else if (ext == "c")    icon = "text-x-csrc"
          else if (ext == "h")    icon = "text-x-chdr"
          else if (ext == "go")   icon = "text-x-go"
          else if (ext == "lua")  icon = "text-x-lua"
          else if (ext == "js"  || ext == "ts"  || ext == "jsx" || ext == "tsx") icon = "application-javascript"
          else if (ext == "json") icon = "application-json"
          else if (ext == "toml") icon = "application-toml"
          else if (ext == "html" || ext == "htm")  icon = "text-html"
          else if (ext == "css"  || ext == "scss" || ext == "sass" || ext == "less") icon = "text-css"
          else if (ext == "md"   || ext == "mdx")  icon = "text-x-markdown"
          else if (ext == "sh"   || ext == "bash" || ext == "zsh" || ext == "fish" || ext == "nix") icon = "text-x-script"
          else if (ext == "yaml" || ext == "yml")  icon = "text-x-generic"

          # --- Fonts ---
          else if (ext == "ttf"  || ext == "otf")  icon = "font-ttf"
          else if (ext == "woff" || ext == "woff2") icon = "application-font-woff"

          # --- Disk / Executables ---
          else if (ext == "iso" || ext == "img") icon = "application-x-iso"
          else if (ext == "appimage")             icon = "application-vnd.appimage"

          else icon = "text-x-generic"

          # Print the path + Rofi icon syntax
          printf "%s\0icon\x1f%s\n", $0, icon
        }'
    else
      ${pkgs.xdg-utils}/bin/xdg-open "$1" > /dev/null 2>&1 &
    fi
  '';
  rofi-cliphist = writeShellScriptBin "rofi-cliphist" ''
    if [ -z "$1" ]; then
      cliphist list | while IFS= read -r line; do
        printf "%s\0icon\x1fedit-paste\n" "$line"
      done
    else
      echo "$1" | cut -f1 | cliphist decode | wl-copy
    fi
  '';

  rofi-wallpapers = writeShellScriptBin "rofi-wallpapers" ''
    wallpaper_dir="$HOME/Pictures/wallpapers-pc"
    gif_dir="$HOME/Pictures/wallpapers-pc-gif"

    if [ -z "$1" ]; then
      ${fd}/bin/fd -t f -e jpg -e jpeg -e png -e gif -e webp -e avif -e bmp . \
        "$wallpaper_dir" "$gif_dir" | while IFS= read -r filepath; do
        printf '%s\0icon\x1fimage-x-generic\n' "$filepath"
      done
    else
      ${pkgs.awww}/bin/awww img "$1" --transition-type fade --transition-fps 60 --transition-step 100
    fi
  '';

in {
  programs.rofi = {
    enable = true;
    font = "${config.font.mono} ${toString config.font.size.base}";
    modes = [
      "calc"
      "combi"
      "drun"
      "emoji"
      {
        name = "files";
        path = "${rofi-clean-files}/bin/rofi-clean-files";
      }
      {
        name = "power";
        path = "${rofi-power-menu}/bin/rofi-power-menu";
      }
      {
        name = "cliphist";
        path = "${rofi-cliphist}/bin/rofi-cliphist";
      }
      {
        name = "wallpapers";
        path = "${rofi-wallpapers}/bin/rofi-wallpapers";
      }
    ];
    plugins = [pkgs.rofi-calc pkgs.rofi-emoji];
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      combi-modes = "drun,files,power,cliphist";
      icon-theme = "${config.iconTheme}";
      show-icons = true;
      combi-hide-mode-prefix = true;
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
      c = config.color;
      s = config.ui.spacing;
      b = config.ui.border;
      e = config.ui.effects;

      hexDigit = d:
        if d == "0"
        then 0
        else if d == "1"
        then 1
        else if d == "2"
        then 2
        else if d == "3"
        then 3
        else if d == "4"
        then 4
        else if d == "5"
        then 5
        else if d == "6"
        then 6
        else if d == "7"
        then 7
        else if d == "8"
        then 8
        else if d == "9"
        then 9
        else if d == "a" || d == "A"
        then 10
        else if d == "b" || d == "B"
        then 11
        else if d == "c" || d == "C"
        then 12
        else if d == "d" || d == "D"
        then 13
        else if d == "e" || d == "E"
        then 14
        else 15;

      hexToDec = s:
        hexDigit (builtins.substring 0 1 s) * 16 + hexDigit (builtins.substring 1 1 s);

      hexToRgba = hex: alpha: let
        h = builtins.substring 1 6 hex;
        r = toString (hexToDec (builtins.substring 0 2 h));
        g = toString (hexToDec (builtins.substring 2 2 h));
        b = toString (hexToDec (builtins.substring 4 2 h));
      in "rgba(${r}, ${g}, ${b}, ${toString (alpha * 100)}%)";
    in {
      "*" = {
        background = mkLiteral (hexToRgba c.surface e.surfaceAlpha);
        foreground = mkLiteral c.text;
        blue = mkLiteral c.accent;
        red = mkLiteral c.error;
        overlay = mkLiteral (hexToRgba c.text 0.05);
        background-color = mkLiteral "transparent";
        border-color = mkLiteral (hexToRgba c.border e.borderOpacity);
        separatorcolor = mkLiteral "transparent";
        spacing = s.s0;
        normal-background = mkLiteral "transparent";
        normal-foreground = mkLiteral "var(foreground)";
        alternate-normal-background = mkLiteral "transparent";
        alternate-normal-foreground = mkLiteral "var(foreground)";
        selected-normal-background = mkLiteral "var(blue)";
        selected-normal-foreground = mkLiteral c.surface;
        active-background = mkLiteral "var(overlay)";
        active-foreground = mkLiteral "var(blue)";
        alternate-active-background = mkLiteral "var(overlay)";
        alternate-active-foreground = mkLiteral "var(blue)";
        selected-active-background = mkLiteral "var(blue)";
        selected-active-foreground = mkLiteral c.surface;
        urgent-background = mkLiteral "transparent";
        urgent-foreground = mkLiteral "var(red)";
        alternate-urgent-background = mkLiteral "transparent";
        alternate-urgent-foreground = mkLiteral "var(red)";
        selected-urgent-background = mkLiteral "var(red)";
        selected-urgent-foreground = mkLiteral c.surface;
      };

      window = {
        width = mkLiteral "600px";
        padding = s.s6;
        background-color = mkLiteral "var(background)";
        border = mkLiteral "${toString b.w1}px solid";
        border-color = mkLiteral "var(border-color)";
      };

      mainbox = {
        padding = s.s0;
        border = b.none;
        spacing = s.s4;
      };

      inputbar = {
        padding = mkLiteral "${toString s.s3}px ${toString s.s4}px";
        spacing = s.s2;
        text-color = mkLiteral "var(normal-foreground)";
        background-color = mkLiteral "var(overlay)";
        border = mkLiteral "${toString b.w1}px solid";
        border-color = mkLiteral "var(border-color)";
        children = mkLiteral ''[ "prompt","textbox-prompt-colon","entry","overlay","num-filtered-rows","textbox-num-sep","num-rows","case-indicator" ]'';
      };

      prompt = {
        spacing = s.s0;
        padding = mkLiteral "0px ${toString s.s2}px 0px 0px";
        text-color = mkLiteral "var(blue)";
      };

      "textbox-prompt-colon" = {
        margin = mkLiteral "0px ${toString s.s1}px 0px 0px";
        expand = false;
        str = ":";
        text-color = mkLiteral "inherit";
      };

      entry = {
        text-color = mkLiteral "var(normal-foreground)";
        cursor = mkLiteral "text";
        spacing = s.s0;
        padding = s.s0;
        placeholder-color = mkLiteral "Gray";
        placeholder = "Type to filter...";
        vertical-align = mkLiteral "0.5";
      };

      "num-filtered-rows, num-rows, textbox-num-sep, case-indicator" = {
        expand = false;
        text-color = mkLiteral "Gray";
        vertical-align = mkLiteral "0.5";
      };

      "textbox-num-sep" = {
        str = "/";
      };

      overlay = {
        padding = mkLiteral "${toString s.s1}px 0.4em";
        background-color = mkLiteral "var(normal-foreground)";
        text-color = mkLiteral "var(normal-background)";
        margin = mkLiteral "0px 0.4em";
      };

      message = {
        padding = s.s3;
        background-color = mkLiteral "var(overlay)";
        border = b.none;
      };

      textbox = {
        text-color = mkLiteral "var(foreground)";
      };

      listview = {
        padding = s.s0;
        scrollbar = true;
        border = b.none;
        spacing = s.s1;
        fixed-height = s.s0;
        lines = mkLiteral "8";
      };

      element = {
        padding = mkLiteral "${toString s.s2}px ${toString s.s4}px";
        cursor = mkLiteral "pointer";
        spacing = s.s3;
        border = b.none;
      };

      "element normal.normal" = {
        background-color = mkLiteral "var(normal-background)";
        text-color = mkLiteral "var(normal-foreground)";
      };
      "element normal.urgent" = {
        background-color = mkLiteral "var(urgent-background)";
        text-color = mkLiteral "var(urgent-foreground)";
      };
      "element normal.active" = {
        background-color = mkLiteral "var(active-background)";
        text-color = mkLiteral "var(active-foreground)";
      };
      "element selected.normal" = {
        background-color = mkLiteral "var(selected-normal-background)";
        text-color = mkLiteral "var(selected-normal-foreground)";
      };
      "element selected.urgent" = {
        background-color = mkLiteral "var(selected-urgent-background)";
        text-color = mkLiteral "var(selected-urgent-foreground)";
      };
      "element selected.active" = {
        background-color = mkLiteral "var(selected-active-background)";
        text-color = mkLiteral "var(selected-active-foreground)";
      };
      "element alternate.normal" = {
        background-color = mkLiteral "var(alternate-normal-background)";
        text-color = mkLiteral "var(alternate-normal-foreground)";
      };
      "element alternate.urgent" = {
        background-color = mkLiteral "var(alternate-urgent-background)";
        text-color = mkLiteral "var(alternate-urgent-foreground)";
      };
      "element alternate.active" = {
        background-color = mkLiteral "var(alternate-active-background)";
        text-color = mkLiteral "var(alternate-active-foreground)";
      };

      "element-text" = {
        background-color = mkLiteral "transparent";
        cursor = mkLiteral "inherit";
        highlight = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
      };

      "element-icon" = {
        background-color = mkLiteral "transparent";
        size = mkLiteral "1.6em";
        cursor = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };

      scrollbar = {
        width = s.s1;
        padding = s.s0;
        handle-width = s.s1;
        border = b.none;
        handle-color = mkLiteral "var(border-color)";
        background-color = mkLiteral "transparent";
      };

      sidebar = {
        border = b.none;
      };

      button = {
        cursor = mkLiteral "pointer";
        spacing = s.s0;
        padding = s.s2;
        text-color = mkLiteral "var(normal-foreground)";
      };

      "button selected" = {
        background-color = mkLiteral "var(selected-normal-background)";
        text-color = mkLiteral "var(selected-normal-foreground)";
      };
    };
  };

  home.packages = with pkgs; [fd];
}
