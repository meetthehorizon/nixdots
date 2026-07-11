{lib, ...}: let
  mkStrOption = default:
    lib.mkOption {
      type = lib.types.str;
      inherit default;
    };
in {
  options = {
    user = {
      name = {
        first = mkStrOption "John";
        middle = mkStrOption "";
        last = mkStrOption "Doe";
      };
      email = mkStrOption "kshitij.dev@proton.me";
    };
  };
}
