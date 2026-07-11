{lib, ...}: let
  mkStrOption = default:
    lib.mkOption {
      type = lib.types.str;
      inherit default;
    };

  mkIntOption = default:
    lib.mkOption {
      type = lib.types.int;
      inherit default;
    };
in {
  options.font = {
    sans = mkStrOption "Inter";
    serif = mkStrOption "Lora";
    mono = mkStrOption "JetBrainsMono Nerd Font";

    size = {
      xs = mkIntOption 12;
      sm = mkIntOption 14;
      base = mkIntOption 16;
      lg = mkIntOption 18;
      xl = mkIntOption 20;
      "2xl" = mkIntOption 24;
      "3xl" = mkIntOption 30;
      "4xl" = mkIntOption 36;
      "8xl" = mkIntOption 72;
      "16xl" = mkIntOption 144;
    };

    weight = {
      thin = mkIntOption 100;
      light = mkIntOption 300;
      normal = mkIntOption 400;
      medium = mkIntOption 500;
      semibold = mkIntOption 600;
      bold = mkIntOption 700;
      black = mkIntOption 900;
    };
  };
}
