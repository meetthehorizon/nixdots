{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
  ];

  xdg.desktopEntries.btop = {
    name = "Resource Monitor";
    exec = "btop";
    terminal = true;
    type = "Application";
    categories = ["System"];
  };
}
