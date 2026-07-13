{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    docker-compose
    inputs.compose2nix.packages.${stdenv.hostPlatform.system}.default
  ];
}
