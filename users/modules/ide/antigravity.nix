{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.antigravity-nix.packages.${stdenv.hostPlatform.system}.google-antigravity-no-fhs
  ];
}
