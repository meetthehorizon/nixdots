{pkgs, ...}: let
  version = "0.8.67";

  codewBin = pkgs.fetchurl {
    url = "https://github.com/Hmbown/CodeWhale/releases/download/v${version}/codew-linux-x64";
    hash = "sha256-fFK++mV/jlUxlSgS7rFbtfdYZG4laUi0Kf73l6laK5M=";
  };

  codewhaleBin = pkgs.fetchurl {
    url = "https://github.com/Hmbown/CodeWhale/releases/download/v${version}/codewhale-linux-x64";
    hash = "sha256-xl02Q6a1/+XI+YdfHDDfgZl2W2TLna9muDg9Rdn8q0s=";
  };

  codewhaleTuiBin = pkgs.fetchurl {
    url = "https://github.com/Hmbown/CodeWhale/releases/download/v${version}/codewhale-tui-linux-x64";
    hash = "sha256-JkUeBFM/dennS6l0pi7mgbPQA3eTOUcYDhEydOGXBBs=";
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
    exec = "codewhale-tui";
    icon = "terminal";
    terminal = true;
    type = "Application";
    categories = ["Development"];
  };
}
