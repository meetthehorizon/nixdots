{
  description = "Quickshell Widgets";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    qsPkg = inputs.quickshell.packages.${system}.default;
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        qsPkg
        kdePackages.qtdeclarative
      ];

      shellHook = ''
        export QMLLS_BUILD_DIRS="${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${qsPkg}/lib/qt-6/qml/:$PWD"
        export QML_IMPORT_PATH="${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:$PWD:${qsPkg}/lib/qt-6/qml/:$PWD"
        export QML2_IMPORT_PATH=$QML_IMPORT_PATH
        echo " Quickshell Dev Environment Ready!"
      '';
    };
  };
}
