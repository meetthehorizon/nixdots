{
  pkgs,
  lib,
  ...
}: let
  mkImagePathOption = default:
    lib.mkOption {
      type = lib.types.either lib.types.path lib.types.package;
      inherit default;
    };
in {
  options = {
    assets = {
      userIcon = mkImagePathOption (pkgs.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/0/02/Sea_Otter_%28Enhydra_lutris%29_%2825169790524%29_crop.jpg";
        name = "userIcon.jpg";
        sha256 = "8fe16c456477d51c05fd907d852802b2cef2c659bfd6fd1911059178cdb4a11b";
      });

      homeIcon = mkImagePathOption (pkgs.fetchurl {
        url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/nixos.png";
        name = "homeIcon.png";
        sha256 = "20cf953237a3c2fd0227930c8b10165cf1cbf5a34cc31f8ae0d7f2d68a573876";
      });

      homeScreen = mkImagePathOption (pkgs.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/6/6d/Tokyo_Tower%2C_Minato_City.jpg";
        name = "homeScreen.png"; # Optional: updated name to match the variable
        sha256 = "3729ee5220090c54a9c12f79f99ea0bf7f46bdb88da2d61b4a712c52aaef2877";
      });

      lockScreen = mkImagePathOption (pkgs.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/6/6d/Tokyo_Tower%2C_Minato_City.jpg";
        name = "lockScreen.png";
        sha256 = "3729ee5220090c54a9c12f79f99ea0bf7f46bdb88da2d61b4a712c52aaef2877";
      });
    };
  };
}
