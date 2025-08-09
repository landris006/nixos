{
  config,
  pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    DRI_PRIME = "pci-0000_01_00_0";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  hardware.graphics.extraPackages = with pkgs; [nvidia-vaapi-driver];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "575.51.02";
      sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
      sha256_aarch64 = "sha256-NNeQU9sPfH1sq3d5RUq1MWT6+7mTo1SpVfzabYSVMVI=";
      openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
      settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
      persistencedSha256 = "sha256-dgmco+clEIY8bedxHC4wp+fH5JavTzyI1BI8BxoeJJI=";
    };
  };
}
