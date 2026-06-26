# Auto-generated secrets configuration. Do not edit manually.
let
  userKey = "age1fwrtqyn9cxcsmnsydq8v36frsjnk5gk8aclwun5nnc8hfzjm5sas4tlcm0";
  hostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILS9YISdkGd7QMXHjKXlLpdSCRXKzTg79W9NKtAT9vHO root@horizon";
  keys = if hostKey != "" then [ userKey hostKey ] else [ userKey ];
in
{
  "github-ssh-key.age".publicKeys = keys;
  "github-pat.age".publicKeys = keys;
}
