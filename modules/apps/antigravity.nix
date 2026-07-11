{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.antigravity.packages.${stdenv.hostPlatform.system}.antigravity
  ];
}
