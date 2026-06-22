# Auto-generated secrets configuration. Do not edit manually.
let
  userKey = "age1s2e0930h6taetzg0uhlh7swsz5lg54m7mrfaw5rxtj290j5yycys554q8w";
  hostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5kxBSaLi2HEincsTM2gdCu5eYrZtKBcpf9vV85CR46 root@horizon";
  keys = if hostKey != "" then [ userKey hostKey ] else [ userKey ];
in
{
  "github-ssh-key.age".publicKeys = keys;
}
