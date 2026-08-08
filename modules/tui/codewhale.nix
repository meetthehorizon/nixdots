{pkgs, ...}: let
  version = "0.9.4";

  codewBin = pkgs.fetchurl {
    url = "https://github.com/Hmbown/CodeWhale/releases/download/v${version}/codew-linux-x64";
    hash = "sha256-mLsMUEqs/jkfHb9FsoyhU5hBPulKtEZB9G3A1TC4ogQ=";
  };

  codewhaleBin = pkgs.fetchurl {
    url = "https://github.com/Hmbown/CodeWhale/releases/download/v${version}/codewhale-linux-x64";
    hash = "sha256-0WVMZ030Cx8UUWo9v4Er90Pri60nBPIE5PA0aWwRXK0=";
  };

  codewhaleTuiBin = pkgs.fetchurl {
    url = "https://github.com/Hmbown/CodeWhale/releases/download/v${version}/codewhale-tui-linux-x64";
    hash = "sha256-yJRnSAKVCUestzW1uH56bhw2FZX9tWnPZ2+IhcnYdJQ=";
  };
in {
  home.packages = [
    (pkgs.stdenvNoCC.mkDerivation {
      pname = "codewhale";
      inherit version;

      dontUnpack = true;

      nativeBuildInputs = [pkgs.autoPatchelfHook];

      installPhase = ''
        mkdir -p $out/bin
        cp ${codewBin} $out/bin/codew
        cp ${codewhaleBin} $out/bin/codewhale
        cp ${codewhaleTuiBin} $out/bin/codewhale-tui
        chmod +x $out/bin/*
      '';
    })
  ];

  xdg.desktopEntries.codewhale-tui = {
    name = "CodeWhale TUI";
    exec = ''sh -c "flock -n /tmp/codewhale-tui.lock footclient codewhale-tui"'';
    icon = "terminal";
    terminal = true;
    type = "Application";
    categories = ["Development"];
  };
}
