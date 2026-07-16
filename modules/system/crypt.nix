{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; let
  cfg = config.secret;
in {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  config = mkMerge [
    {
      assertions = [
        {
          assertion = !cfg.gpg.enable || cfg.gpg.fingerprint != "";
          message = "secret.gpg.fingerprint must be set when GPG is enabled";
        }
      ];
      home.packages = with pkgs; [
        seahorse
        inputs.agenix.packages.${stdenv.hostPlatform.system}.default
      ];
    }

    (mkIf cfg.githubPat.enable {
      age.secrets.github-pat = {
        file = cfg.githubPat.file;
      };
    })

    (mkIf cfg.gpg.enable {
      programs.gpg.enable = true;
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentry.package = pkgs.pinentry-qt;
        defaultCacheTtl = 34560000;
        maxCacheTtl = 34560000;
      };

      age.secrets.gpg = mkIf cfg.gpg.enable {
        file = cfg.gpg.file;
      };

      systemd.user.services.import-gpg-key = {
        Unit = {
          Description = "Import GPG private key from agenix";
          After = ["agenix.service"];
          Requires = ["agenix.service"];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.gnupg}/bin/gpg --batch --import ${config.age.secrets.gpg.path}";
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
    })

    (mkIf cfg.deepseek.enable {
      age.secrets.deepseek = {
        file = cfg.deepseek.file;
      };
    })
  ];
}
