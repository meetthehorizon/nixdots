{
  lib,
  pkgs,
  config,
  ...
}: let
  configPath = "${config.home.homeDirectory}/nixdots/users/${config.home.username}/config.json";
  parsedConfig =
    if builtins.pathExists configPath
    then builtins.fromJSON (builtins.readFile configPath)
    else {};

  # Robust font block parser (handles "font", "fonts", and nested "fonts")
  fontCfg = parsedConfig.font or parsedConfig.fonts or {};
  fontVals =
    if fontCfg ? fonts
    then fontCfg.fonts
    else fontCfg;

  # Font Packages Resolution
  fontPackageMap = with pkgs; {
    "Inter" = inter;
    "Lora" = lora;
    "JetBrainsMono Nerd Font" = nerd-fonts.jetbrains-mono;
  };
  getFontPkg = name: fontPackageMap.${name} or null;
  resolvedFontPackages = lib.filter (p: p != null) [
    (getFontPkg config.font.sans)
    (getFontPkg config.font.serif)
    (getFontPkg config.font.mono)
  ];

  # GTK Icon Package Resolution
  iconPackageMap = {
    "Papirus Dark" = pkgs.papirus-icon-theme;
    "Tela Circle" = pkgs.tela-circle-icon-theme;
  };
  getIconPkg = name: iconPackageMap.${name} or null;
  resolvedIconPackage = getIconPkg config.iconTheme;

  # GTK Cursor Package Resolution
  cursorPackageMap = {
    "Adwaita" = pkgs.adwaita-icon-theme;
    "Bibata-Modern-Ice" = pkgs.bibata-cursors;
    "Breeze" = pkgs.breeze-qt5;
  };
  getCursorPkg = name: cursorPackageMap.${name} or null;
  resolvedCursorPackage = getCursorPkg config.cursorTheme;

  # GTK Theme mapping based on config.color.style
  gtkThemeMap = {
    "tokyonight" = "Tokyonight";
    "catppuccin" = "Catppuccin";
    "gruvbox" = "Gruvbox";
  };
  activeGtkTheme = gtkThemeMap.${config.color.style} or "Adwaita";

  # GTK Theme Package Resolution
  gtkThemePackageMap = {
    "Adwaita" = pkgs.gnome-themes-extra;
    "Tokyonight" = pkgs.tokyonight-gtk-theme;
    "Catppuccin" = pkgs.catppuccin-gtk;
    "Gruvbox" = pkgs.gruvbox-gtk-theme;
  };
  getGtkThemePkg = name: gtkThemePackageMap.${name} or null;
  resolvedGtkThemePackage = getGtkThemePkg config.gtkTheme;

  # User name configuration helpers
  userCfg = parsedConfig.user or {};
  userNameCfg = userCfg.name or {};
in {
  options = {
    nixdotsPath = lib.mkOption {
      type = lib.types.str;
      default = "/home/conart/nixdots";
    };
  };

  config = {
    # Set structural options from the parsed JSON values
    color = parsedConfig.color or {};

    font = {
      sans = fontVals.sans or "Inter";
      serif = fontVals.serif or "Lora";
      mono = fontVals.mono or "JetBrainsMono Nerd Font";
      size = fontVals.size or {};
      weight = fontVals.weight or {};
    };

    iconTheme = parsedConfig.gtk.iconTheme or "Papirus Dark";
    cursorTheme = parsedConfig.gtk.cursorTheme or "Bibata-Modern-Ice";
    gtkTheme = activeGtkTheme;

    user = {
      name = {
        first = userNameCfg.first or userCfg.firstName or "John";
        middle = userNameCfg.middle or userCfg.middleName or "";
        last = userNameCfg.last or userCfg.lastName or "Doe";
      };
      email = userCfg.email or "kshitij.dev@proton.me";
    };

    ui = parsedConfig.ui or {};

    # Apply configuration to Home Manager settings
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ config.font.sans ];
        serif = [ config.font.serif ];
        monospace = [ config.font.mono ];
      };
    };

    gtk = {
      enable = true;
      font = {
        name = config.font.sans;
        size = config.font.size.xs;
      };
      iconTheme = lib.mkIf (resolvedIconPackage != null) {
        name = config.iconTheme;
        package = resolvedIconPackage;
      };
      cursorTheme = lib.mkIf (resolvedCursorPackage != null) {
        name = config.cursorTheme;
        package = resolvedCursorPackage;
      };
      theme = lib.mkIf (resolvedGtkThemePackage != null) {
        name = config.gtkTheme;
        package = resolvedGtkThemePackage;
      };
    };

    home.pointerCursor = lib.mkIf (resolvedCursorPackage != null) {
      name = config.cursorTheme;
      package = resolvedCursorPackage;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    home.packages = resolvedFontPackages
      ++ lib.optional (resolvedIconPackage != null) resolvedIconPackage
      ++ lib.optional (resolvedCursorPackage != null) resolvedCursorPackage
      ++ lib.optional (resolvedGtkThemePackage != null) resolvedGtkThemePackage;
  };
}
