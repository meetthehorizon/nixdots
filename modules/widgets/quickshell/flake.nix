{
  description = "Quickshell Widgets";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
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
        # 1. Point the language server to BOTH Qt's standard modules and Quickshell's custom modules
        export QMLLS_BUILD_DIRS="${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:${qsPkg}/lib/qt-6/qml/"

        # 2. Set import paths for standard running/linting
        export QML_IMPORT_PATH="${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml/:$PWD:${qsPkg}/lib/qt-6/qml/"
        export QML2_IMPORT_PATH=$QML_IMPORT_PATH

        echo "🦊 Quickshell Dev Environment Ready!"
      '';
    };
  };
}
