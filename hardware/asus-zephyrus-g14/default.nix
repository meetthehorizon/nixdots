{...}: {
  imports = [
    ./asus.nix
    ./nvidia.nix
  ];

  # Specific boot graphics modules for AMD + NVIDIA hybrid setup
  boot.initrd.kernelModules = ["amdgpu"];
}
