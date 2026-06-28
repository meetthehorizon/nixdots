{pkgs, ...}: {
  home.packages = with pkgs; [
    # Archive utilities
    unzip
    zip
    bzip2
    gnutar

    # Document/PDF utilities
    img2pdf
    qpdf

    # Modern CLI / Productivity tools
    ripgrep
    fd
    jq
    bat
    tealdeer
  ];
}
