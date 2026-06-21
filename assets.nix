# These are the public fallbacks. They will always be fetched and available.
{pkgs, ...}: {
  userIcon = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/8/8c/Undine_-_The_River_Mask.jpg";
    sha256 = "99f05f9e7a14417ac8a5bcdce71a5f5c30386bc34a6e442d2865f9ed1539f42d";
  };
  nixosIcon = pkgs.fetchurl {
    url = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/nixos.png";
    sha256 = "20cf953237a3c2fd0227930c8b10165cf1cbf5a34cc31f8ae0d7f2d68a573876";
  };
  homeScreen = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-dracula.png";
    sha256 = "4b291e1495c2ce479ac70d3a9e9d1090908adbc7b4937d0f758f190d57109e1e";
  };
  lockScreen = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/3/35/Minato_City%2C_Tokyo%2C_Japan.jpg";
    sha256 = "4b186ff5628c0d14f5c66b3c11ebef13ba8fa3468fe9d91f781ae7862db85bf9";
  };
}
