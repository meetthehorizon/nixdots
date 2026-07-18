{pkgs, ...}: {
  home.packages = with pkgs; [
    bluetui
  ];

  xdg.desktopEntries.bluetui = {
    name = "Bluetooth Manager";
    exec = "footclient bluetui";
    icon = "bluetoothradio";
    type = "Application";
    categories = ["System"];
  };
}
