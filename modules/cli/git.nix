{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    settings = let
      gpgConfig = config.secret.gpg;
    in
      {
        user = with config.settings;
          {
            name = "${firstName} ${lastName}";
            email = "${email}]";
          }
          // lib.optionalAttrs gpgConfig.enable {
            signingkey = gpgConfig.fingerprint;
          };

        core.editor = "nvim";
        init.defaultBranch = "master";
        pull.rebase = true;
        "url \"git@github.com:\"".insteadOf = "https://github.com/";
      }
      // lib.optionalAttrs gpgConfig.enable {
        commit = {
          gpgsign = true;
        };
        gpg = {
          program = "${pkgs.gnupg}/bin/gpg";
          format = "openpgp";
        };
      };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}
