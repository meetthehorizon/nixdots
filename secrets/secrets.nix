# Auto-generated secrets configuration. Do not edit manually.
let
  userKey = "age1un9tnzc4gvwwq64449vkwkk08kzk7363k8ru2p9p8nxlna23699sm4zunl";
  hostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILS9YISdkGd7QMXHjKXlLpdSCRXKzTg79W9NKtAT9vHO root@horizon";
  keys =
    if hostKey != ""
    then [userKey hostKey]
    else [userKey];
in {
  "github-ssh-key.age".publicKeys = keys;
  "github-pat.age".publicKeys = keys;
}
