let
  conartProtonMaster = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINymR2zHgnT0j68FmSg1gx5qHAMvv33opR6f+fJdOfhB master-backup";
  conart = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGAwqToRmkfhGHQK11czD+gPmcF+PZ21CIOo9v16Osf5 kshitij.dev@proton.me";
  # horizon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILS9YISdkGd7QMXHjKXlLpdSCRXKzTg79W9NKtAT9vHO root@horizon";
in {
  "../../.secrets/conart.github-pat.age" = {
    publicKeys = [conart conartProtonMaster];
    armor = true;
  };
  "../../.secrets/conart.gpg.age" = {
    publicKeys = [conart conartProtonMaster];
    armor = true;
  };
  "../../.secrets/conart.deepseek.age" = {
    publicKeys = [conart conartProtonMaster];
    armor = true;
  };
}
