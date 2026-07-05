{pkgs, ...}: {
  home.packages = with pkgs; [
    file-roller
    loupe
    mpv
  ];

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # --- Directories / File Explorer ---
      "inode/directory" = "yazi.desktop";

      # --- Web Links & HTML ---
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";

      # --- Video ---
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop"; # .mkv files
      "video/webm" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop"; # .mov files
      "video/x-flv" = "mpv.desktop";

      # --- PDFs (Handled by the programs.zathura module above) ---
      "application/pdf" = "org.pwmt.zathura.desktop";

      # --- Archives & Zips ---
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/x-rar" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";

      # --- Images ---
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";
    };
  };
}
