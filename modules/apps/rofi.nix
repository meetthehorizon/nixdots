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
        "$wallpaper_dir" "$gif_dir" | ${coreutils}/bin/shuf | while IFS= read -r filepath; do
        printf '%s\0icon\x1f%s\n' "$filepath" "$filepath"
      done
    else
      ${pkgs.awww}/bin/awww img "$1" --transition-type center --transition-fps 120 --transition-step 30
      case "$1" in
        *.gif) ;;
        *) ${coreutils}/bin/ln -sf "$1" "$HOME/.cache/hyprlock-bg" ;;
      esac
    fi
  '';

  # --- Theme helpers ---
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

  # Design token aliases
  c = config.color;
  s = config.ui.spacing;
  b = config.ui.border;
  e = config.ui.effects;
  r = config.ui.radius;

  # --- Rasi theme strings ---
  customRasi = ''
    * {
        background: ${hexToRgba c.surface e.surfaceAlpha};
        foreground: ${c.text};
        blue: ${c.accent};
        red: ${c.error};
        overlay: ${hexToRgba c.text 0.05};
        background-color: transparent;
        border-color: ${hexToRgba c.border e.borderOpacity};
        separatorcolor: transparent;
        spacing: ${toString s.s0};
        normal-background: transparent;
        normal-foreground: var(foreground);
        alternate-normal-background: transparent;
        alternate-normal-foreground: var(foreground);
        selected-normal-background: var(blue);
        selected-normal-foreground: ${c.surface};
        active-background: var(overlay);
        active-foreground: var(blue);
        alternate-active-background: var(overlay);
        alternate-active-foreground: var(blue);
        selected-active-background: var(blue);
        selected-active-foreground: ${c.surface};
        urgent-background: transparent;
        urgent-foreground: var(red);
        alternate-urgent-background: transparent;
        alternate-urgent-foreground: var(red);
        selected-urgent-background: var(red);
        selected-urgent-foreground: ${c.surface};
    }

    window {
        width: 600px;
        padding: ${toString s.s6};
        background-color: var(background);
        border: ${toString b.w1}px solid;
        border-color: var(border-color);
    }

    mainbox {
        padding: ${toString s.s0};
        border: ${toString b.none};
        spacing: ${toString s.s4};
    }

    inputbar {
        padding: ${toString s.s3}px ${toString s.s4}px;
        spacing: ${toString s.s2};
        text-color: var(normal-foreground);
        background-color: var(overlay);
        border: ${toString b.w1}px solid;
        border-color: var(border-color);
        children: [ "prompt","textbox-prompt-colon","entry","overlay","num-filtered-rows","textbox-num-sep","num-rows","case-indicator" ];
    }

    prompt {
        spacing: ${toString s.s0};
        padding: 0px ${toString s.s2}px 0px 0px;
        text-color: var(blue);
    }

    textbox-prompt-colon {
        margin: 0px ${toString s.s1}px 0px 0px;
        expand: false;
        str: ":";
        text-color: inherit;
    }

    entry {
        text-color: var(normal-foreground);
        cursor: text;
        spacing: ${toString s.s0};
        padding: ${toString s.s0};
        placeholder-color: Gray;
        placeholder: "Type to filter...";
        vertical-align: 0.5;
    }

    num-filtered-rows, num-rows, textbox-num-sep, case-indicator {
        expand: false;
        text-color: Gray;
        vertical-align: 0.5;
    }

    textbox-num-sep {
        str: "/";
    }

    overlay {
        padding: ${toString s.s1}px 0.4em;
        background-color: var(normal-foreground);
        text-color: var(normal-background);
        margin: 0px 0.4em;
    }

    message {
        padding: ${toString s.s3};
        background-color: var(overlay);
        border: ${toString b.none};
    }

    textbox {
        text-color: var(foreground);
    }

    listview {
        padding: ${toString s.s0};
        scrollbar: true;
        border: ${toString b.none};
        spacing: ${toString s.s1};
        fixed-height: ${toString s.s0};
        lines: 8;
    }

    element {
        padding: ${toString s.s2}px ${toString s.s4}px;
        cursor: pointer;
        spacing: ${toString s.s3};
        border: ${toString b.none};
    }

    element normal.normal {
        background-color: var(normal-background);
        text-color: var(normal-foreground);
    }
    element normal.urgent {
        background-color: var(urgent-background);
        text-color: var(urgent-foreground);
    }
    element normal.active {
        background-color: var(active-background);
        text-color: var(active-foreground);
    }
    element selected.normal {
        background-color: var(selected-normal-background);
        text-color: var(selected-normal-foreground);
    }
    element selected.urgent {
        background-color: var(selected-urgent-background);
        text-color: var(selected-urgent-foreground);
    }
    element selected.active {
        background-color: var(selected-active-background);
        text-color: var(selected-active-foreground);
    }
    element alternate.normal {
        background-color: var(alternate-normal-background);
        text-color: var(alternate-normal-foreground);
    }
    element alternate.urgent {
        background-color: var(alternate-urgent-background);
        text-color: var(alternate-urgent-foreground);
    }
    element alternate.active {
        background-color: var(alternate-active-background);
        text-color: var(alternate-active-foreground);
    }

    element-text {
        background-color: transparent;
        cursor: inherit;
        highlight: inherit;
        text-color: inherit;
        vertical-align: 0.5;
    }

    element-icon {
        background-color: transparent;
        size: 1.6em;
        cursor: inherit;
        text-color: inherit;
    }

    scrollbar {
        width: ${toString s.s1};
        padding: ${toString s.s0};
        handle-width: ${toString s.s1};
        border: ${toString b.none};
        handle-color: var(border-color);
        background-color: transparent;
    }

    sidebar {
        border: ${toString b.none};
    }

    button {
        cursor: pointer;
        spacing: ${toString s.s0};
        padding: ${toString s.s2};
        text-color: var(normal-foreground);
    }

    button selected {
        background-color: var(selected-normal-background);
        text-color: var(selected-normal-foreground);
    }
  '';

  wallpaperRasi = ''
    @import "custom"

    window {
        width: 1050px;
    }

    listview {
        columns: 4;
        lines: 4;
        spacing: ${toString s.s2};
    }

    element {
        padding: ${toString s.s2}px;
        spacing: ${toString s.s1};
        orientation: vertical;
        border-radius: ${toString r.r2}px;
    }

    element-icon {
        size: 210px;
        border-radius: ${toString r.r2}px;
    }

    element-text {
        enabled: false;
    }
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
    theme = "custom";
  };

  xdg.configFile = {
    "rofi/custom.rasi".text = customRasi;
    "rofi/wallpapers.rasi".text = wallpaperRasi;
  };

  home.packages = with pkgs; [fd];
}
