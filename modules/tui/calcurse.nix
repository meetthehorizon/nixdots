{pkgs, ...}: {
  home.packages = with pkgs; [
    calcurse
  ];

  xdg.desktopEntries.calcurse = {
    name = "Calendar";
    exec = "footclient calcurse";
    icon = "calendar";
    type = "Application";
    categories = ["Office"];
  };
}
