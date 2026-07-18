{
  pkgs,
  config,
  ...
}:
with pkgs; let
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
    ];
    plugins = [pkgs.rofi-calc pkgs.rofi-emoji];
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      combi-modes = "drun,files";
      icon-theme = "${config.iconTheme}";
      show-icons = true;
      combi-hide-mode-prefix = true;
    };
  };

  home.packages = with pkgs; [fd];
}
