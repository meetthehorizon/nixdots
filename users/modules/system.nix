{pkgs, ...}: {
  home.packages = with pkgs; [
    bluetui
    brightnessctl
    playerctl
    seahorse
  ];
}
