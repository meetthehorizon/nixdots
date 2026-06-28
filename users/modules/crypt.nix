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

  options.secret = {
    githubPat = {
      enable = mkEnableOption "GitHub Personal Access Token decryption via Agenix";
      file = mkOption {
        type = types.path;
        description = "Path to the age-encrypted GitHub PAT file";
      };
    };
    gpg = {
      enable = mkEnableOption "GPG Private Token for Github Commits";
      file = mkOption {
        type = types.path;
        description = "Path to the age-encrypted GPG Private Token";
      };
    };
  };

  config = mkMerge [
    {
      home.packages = with pkgs; [
        seahorse
        inputs.agenix.packages.${stdenv.hostPlatform.system}.default
      ];
    }

    (mkIf cfg.githubPat.enable {
      age.secrets.github-pat = mkIf cfg.githubPat.enable {
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
  ];
}
