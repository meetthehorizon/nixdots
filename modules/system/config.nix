{
  config,
  lib,
  pkgs,
  ...
}: let
  userThemeFile = ../../users/conart/theme.json;
  userSettingsFile = ../../users/conart/settings.json;
  defaultThemeFile = ../../themes/tokyonight.json;

  assetsDir = ../../assets;

  themeFile =
    if builtins.pathExists userThemeFile
    then userThemeFile
    else defaultThemeFile;

  themeData = builtins.fromJSON (builtins.readFile themeFile);

  settingsData =
    if builtins.pathExists userSettingsFile
    then builtins.fromJSON (builtins.readFile userSettingsFile)
    else {};

  fontPackageMap = {
    "IBM Plex Sans" = pkgs.ibm-plex;
    "IBM Plex Serif" = pkgs.ibm-plex;
    "JetBrainsMono Nerd Font" = pkgs.nerd-fonts.jetbrains-mono;
    "FiraCode Nerd Font" = pkgs.nerd-fonts.fira-code;
    "Hack Nerd Font" = pkgs.nerd-fonts.hack;
    "Iosevka Nerd Font" = pkgs.nerd-fonts.iosevka;
    "Mononoki Nerd Font" = pkgs.nerd-fonts.mononoki;
    "Inter" = pkgs.inter;
    "Roboto" = pkgs.roboto;
    "Comic Mono" = pkgs.comic-mono;
  };

  resolveFont = name: fontPackageMap.${name} or null;

  activeFontPkgs = builtins.filter (p: p != null) [
    (resolveFont config.theme.fonts.sans)
    (resolveFont config.theme.fonts.serif)
    (resolveFont config.theme.fonts.mono)
  ];
in {
  options = {
    theme = {
      colors = {
        red = lib.mkOption {
          type = lib.types.str;
          default = "#ff0000";
        };
        green = lib.mkOption {
          type = lib.types.str;
          default = "#00ff00";
        };
        yellow = lib.mkOption {
          type = lib.types.str;
          default = "#ffff00";
        };
        blue = lib.mkOption {
          type = lib.types.str;
          default = "#0000ff";
        };
        magenta = lib.mkOption {
          type = lib.types.str;
          default = "#ff00ff";
        };
        cyan = lib.mkOption {
          type = lib.types.str;
          default = "#00ffff";
        };
        gray = lib.mkOption {
          type = lib.types.str;
          default = "#808080";
        };
        black = lib.mkOption {
          type = lib.types.str;
          default = "#000000";
        };
        white = lib.mkOption {
          type = lib.types.str;
          default = "#ffffff";
        };

        redRGB = lib.mkOption {
          type = lib.types.str;
          default = "rgb(255, 0, 0)";
        };
        greenRGB = lib.mkOption {
          type = lib.types.str;
          default = "rgb(0, 255, 0)";
        };
        yellowRGB = lib.mkOption {
          type = lib.types.str;
          default = "rgb(255, 255, 0)";
        };
        blueRGB = lib.mkOption {
          type = lib.types.str;
          default = "rgb(0, 0, 255)";
        };
        magentaRGB = lib.mkOption {
          type = lib.types.str;
          default = "rgb(255, 0, 255)";
        };
        cyanRGB = lib.mkOption {
          type = lib.types.str;
          default = "rgb(0, 255, 255)";
        };
        grayRGB = lib.mkOption {
          type = lib.types.str;
          default = "rgb(128, 128, 128)";
        };
        blackRGB = lib.mkOption {
          type = lib.types.str;
          default = "rgb(0, 0, 0)";
        };
        whiteRGB = lib.mkOption {
          type = lib.types.str;
          default = "rgb(255, 255, 255)";
        };

        background = lib.mkOption {
          type = lib.types.str;
          default = "#000000";
        };
        foreground = lib.mkOption {
          type = lib.types.str;
          default = "#ffffff";
        };
        accent = lib.mkOption {
          type = lib.types.str;
          default = "#0000ff";
        };
        accentRGB = lib.mkOption {
          type = lib.types.str;
          default = "rgb(0, 0, 255)";
        };
        accentRGBA = lib.mkOption {
          type = lib.types.str;
          default = "rgba(0, 0, 255, 1.0)";
        };
        backgroundRGBA = lib.mkOption {
          type = lib.types.str;
          default = "rgba(0, 0, 0, 1.0)";
        };
        foregroundRGB = lib.mkOption {
          type = lib.types.str;
          default = "rgb(255, 255, 255)";
        };
      };

      fonts = {
        sans = lib.mkOption {
          type = lib.types.str;
          default = "Inter";
        };
        serif = lib.mkOption {
          type = lib.types.str;
          default = "IBM Plex Serif";
        };
        mono = lib.mkOption {
          type = lib.types.str;
          default = "JetBrainsMono Nerd Font";
        };
        sizes = {
          gtk = lib.mkOption {
            type = lib.types.int;
            default = 11;
          };
          kitty = lib.mkOption {
            type = lib.types.int;
            default = 12;
          };
          mako = lib.mkOption {
            type = lib.types.int;
            default = 11;
          };
        };
      };

      opacity = {
        kitty = lib.mkOption {
          type = lib.types.str;
          default = "0.8";
        };
      };

      neovim = {
        colorscheme = lib.mkOption {
          type = lib.types.str;
          default = "0.8";
        };
        transparent = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };

      assets = {
        userIcon = lib.mkOption {
          type = lib.types.either lib.types.path lib.types.package;
          default = pkgs.fetchurl {
            url = "https://upload.wikimedia.org/wikipedia/commons/0/02/Sea_Otter_%28Enhydra_lutris%29_%2825169790524%29_crop.jpg";
            name = "userIcon.jpg";
            sha256 = "8fe16c456477d51c05fd907d852802b2cef2c659bfd6fd1911059178cdb4a11b";
          };
        };
        homeIcon = lib.mkOption {
          type = lib.types.either lib.types.path lib.types.package;
          default = pkgs.fetchurl {
            url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/nixos.png";
            name = "homeIcon.png";
            sha256 = "20cf953237a3c2fd0227930c8b10165cf1cbf5a34cc31f8ae0d7f2d68a573876";
          };
        };
        homeScreen = lib.mkOption {
          type = lib.types.either lib.types.path lib.types.package;
          default = pkgs.fetchurl {
            url = "https://upload.wikimedia.org/wikipedia/commons/6/6d/Tokyo_Tower%2C_Minato_City.jpg";
            name = "lockScreen.png";
            sha256 = "3729ee5220090c54a9c12f79f99ea0bf7f46bdb88da2d61b4a712c52aaef2877";
          };
        };
        lockScreen = lib.mkOption {
          type = lib.types.either lib.types.path lib.types.package;
          default = pkgs.fetchurl {
            url = "https://upload.wikimedia.org/wikipedia/commons/6/6d/Tokyo_Tower%2C_Minato_City.jpg";
            name = "lockScreen.png";
            sha256 = "3729ee5220090c54a9c12f79f99ea0bf7f46bdb88da2d61b4a712c52aaef2877";
          };
        };
      };
    };

    settings = {
      firstName = lib.mkOption {
        type = lib.types.str;
        default = "John";
      };
      middleName = lib.mkOption {
        type = lib.types.str;
        default = "Lorem";
      };
      lastName = lib.mkOption {
        type = lib.types.str;
        default = "Doe";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "username@hostname";
      };
      nixdotsPath = lib.mkOption {
        type = lib.types.str;
        default = "/home/${config.home.username}/nixdots";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (themeData ? colors) {theme.colors = themeData.colors;})
    (lib.mkIf (themeData ? fonts) {theme.fonts = themeData.fonts;})

    (lib.mkIf (themeData ? assets && themeData.assets ? userIcon) {
      theme.assets.userIcon = assetsDir + "/${themeData.assets.userIcon}";
    })
    (lib.mkIf (themeData ? assets && themeData.assets ? homeIcon) {
      theme.assets.homeIcon = assetsDir + "/${themeData.assets.homeIcon}";
    })
    (lib.mkIf (themeData ? assets && themeData.assets ? homeScreen) {
      theme.assets.homeScreen = assetsDir + "/${themeData.assets.homeScreen}";
    })
    (lib.mkIf (themeData ? assets && themeData.assets ? lockScreen) {
      theme.assets.lockScreen = assetsDir + "/${themeData.assets.lockScreen}";
    })

    (lib.mkIf (settingsData ? firstName) {settings.firstName = settingsData.firstName;})
    (lib.mkIf (settingsData ? middleName) {settings.middleName = settingsData.middleName;})
    (lib.mkIf (settingsData ? lastName) {settings.lastName = settingsData.lastName;})
    (lib.mkIf (settingsData ? email) {settings.email = settingsData.email;})

    {
      home.packages = activeFontPkgs;

      fonts.fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [config.theme.fonts.sans];
          serif = [config.theme.fonts.serif];
          monospace = [config.theme.fonts.mono];
        };
      };

      gtk = {
        enable = true;
        font = {
          name = config.theme.fonts.sans;
          size = config.theme.fonts.sizes.gtk;
        };
      };
    }
  ];
}
