{
  config,
  lib,
  ...
}: let
  username = config.home.username;
  userThemeFile = ../../theme.${username}.json;
  defaultThemeFile = ../../theme/catppuccin.json;
  themeFile =
    if builtins.pathExists userThemeFile
    then userThemeFile
    else defaultThemeFile;
in {
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    default = builtins.fromJSON (builtins.readFile themeFile);
    description = "User-specific theme configuration from theme.<username>.json";
  };
}
