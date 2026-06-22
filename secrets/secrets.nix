# Auto-generated secrets configuration. Do not edit manually.
let
  userKey = "age1q24yu0gcry6d3t62wn7d5khkne2hcknz0tzw9mejckktnhzjuv7qu4nqgs";
  hostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5kxBSaLi2HEincsTM2gdCu5eYrZtKBcpf9vV85CR46 root@horizon";
  keys = if hostKey != "" then [ userKey hostKey ] else [ userKey ];
in
{
  "github-ssh-key.age".publicKeys = keys;
  "github-pat.age".publicKeys = keys;
}
