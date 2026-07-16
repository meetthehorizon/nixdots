{pkgs, ...}: {
  home.packages = with pkgs; [
    calcurse
  ];

  xdg.desktopEntries.calcurse = {
    name = "Calendar";
    exec = "calcurse";
    terminal = true;
    type = "Application";
    categories = ["Office"];
  };
}
