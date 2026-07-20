{pkgs, ...}: {
  home.packages = with pkgs; [
    calcurse
  ];

  xdg.desktopEntries.calcurse = {
    name = "Calendar";
    exec = ''sh -c "flock -n /tmp/calcurse.lock footclient calcurse"'';
    icon = "calendar";
    type = "Application";
    categories = ["Office"];
  };
}
