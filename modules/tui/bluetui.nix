{pkgs, ...}: {
  home.packages = with pkgs; [
    bluetui
  ];

  xdg.desktopEntries.bluetui = {
    name = "Bluetooth Manager";
    exec = ''sh -c "flock -n /tmp/bluetui.lock footclient bluetui"'';
    icon = "bluetoothradio";
    type = "Application";
    categories = ["System"];
  };
}
