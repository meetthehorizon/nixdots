{config, ...}: let
  dotfilesDir = "${config.home.homeDirectory}/nixdots";
in {
  home = {
    username = "conart";
    homeDirectory = "/home/conart";
    file = {
      "Pictures".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/assets/Pictures";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  imports = [
    ../../modules
  ];

  secret = {
    githubPat = {
      enable = true;
      file = ../../.secrets/conart.github-pat.age;
    };
    gpg = {
      enable = true;
      fingerprint = "3A95CB5B608EA1CA";
      file = ../../.secrets/conart.gpg.age;
    };
    deepseek = {
      enable = true;
      file = ../../.secrets/conart.deepseek.age;
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Do not change this value unless you thoroughly read the release notes.
  home.stateVersion = "26.05";
}
