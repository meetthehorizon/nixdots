{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    settings =
      {
        user = with config.settings;
          {
            name = "${firstName} ${lastName}";
            email = "${email}]";
          }
          // lib.optionalAttrs config.secret.gpg.enable {
            signingkey = config.secret.gpg.fingerprint;
          };
        alias = {
          st = "status";
          lg = "log -n 10 --oneline";
          ci = "commit";
          co = "checkout";
          br = "branch";
          fk = "commit --amend --no-edit";
          rb = "rebase";
          rbc = "rebase --continue";
          sq = "rebase -i --autosquash --root";
        };

        core.editor = "nvim";
        init.defaultBranch = "master";
        pull.rebase = true;
        "url \"git@github.com:\"".insteadOf = "https://github.com/";
      }
      // lib.optionalAttrs config.secret.gpg.enable {
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
