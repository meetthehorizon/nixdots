{ config, pkgs, ... }: {
  # Enable OpenGL / graphics support
  hardware.graphics.enable = true;

  # NVIDIA proprietary driver (nvidia-open kernel modules for RTX 4060)
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Use nvidia-open kernel modules (officially supported for Ada Lovelace / RTX 40xx)
    open = true;

    # Enable modesetting (required for Wayland/Hyprland)
    modesetting.enable = true;

    # Power management — let the GPU suspend when not in use
    powerManagement.enable = true;
    powerManagement.finegrained = true; # turn off GPU when no apps use it (PRIME offload)

    # Use the stable driver branch
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # PRIME offload: AMD iGPU renders by default, NVIDIA on-demand
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # creates `nvidia-offload` wrapper command
      };
      # Bus IDs (from lspci: NVIDIA=01:00.0, AMD=65:00.0)
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:101:0:0"; # 0x65 = 101 decimal
    };
  };

  # Blacklist nouveau to prevent conflicts
  boot.blacklistedKernelModules = [ "nouveau" ];
}
