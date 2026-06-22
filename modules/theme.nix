{...}: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = ["IBM Plex Sans"];
      serif = ["IBM Plex Serif"];
      monospace = ["JetBrainsMono Nerd Font"];
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "IBM Plex Sans";
      size = 11;
    };
  };
}
