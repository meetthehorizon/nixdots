{lib, ...}: let
  mkStrOption = default:
    lib.mkOption {
      type = lib.types.str;
      inherit default;
    };
in {
  options = {
    iconTheme = mkStrOption "Papirus Dark";
    cursorTheme = mkStrOption "Bibata-Modern-Ice";
    gtkTheme = mkStrOption "Adwaita";
  };
}
