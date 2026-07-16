{lib, ...}:
with lib; {
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
      fingerprint = mkOption {
        type = types.str;
        default = "";
        description = "Fingerprint or Key ID for GPG Key";
      };
      file = mkOption {
        type = types.path;
        description = "Path to the age-encrypted GPG Private Token";
      };
    };
    deepseek = {
      enable = mkEnableOption "Deepseek API Key";
      file = mkOption {
        type = types.path;
        description = "Path to the age-encrypted Deepseek API Key";
      };
    };
  };
}
