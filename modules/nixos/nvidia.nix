{ config, pkgs, ... }:

{
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package =
      # let
      #   rcu_patch = pkgs.fetchpatch {
      #     url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
      #     hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
      #   };
      # in
      config.boot.kernelPackages.nvidiaPackages.mkDriver {
        # version = "535.154.05";
        # sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
        # sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
        # openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
        # settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
        # persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
        #
        # patches = [ rcu_patch ];

        # version = "545.29.02";
        # sha256_64bit = "sha256-RncPlaSjhvBFUCOzWdXSE3PAfRPCIrWAXyJMdLPKuIU=";
        # sha256_aarch64 = "sha256-Y2RDOuDtiIclr06gmLrPDfE5VFmFamXxiIIKtKAewro=";
        # openSha256 = "sha256-PukpOBtG5KvZKWYfJHVQO6SuToJUd/rkjpOlEi8pSmk=";
        # settingsSha256 = "sha256-zj173HCZJaxAbVV/A2sbJ9IPdT1+3yrwyxD+AQdkSD8=";
        # persistencedSha256 = "sha256-mmMi2pfwzI1WYOffMVdD0N1HfbswTGg7o57x9/IiyVU=";
        #
        # patches = [ rcu_patch ];

        version = "550.40.53";
        persistencedVersion = "550.54.14";
        settingsVersion = "550.54.14";
        sha256_64bit = "sha256-ZA5pb1xjzDyEBrf3UYHta4T9laCOCW7LHJwhcdjw6MA=";
        openSha256 = "sha256-p4FL0j9Ev4SJ3YcjfhFLxbMbc77dBblkrTYK50+OYqA=";
        settingsSha256 = "sha256-m2rNASJp0i0Ez2OuqL+JpgEF0Yd8sYVCyrOoo/ln2a4=";
        persistencedSha256 = "sha256-XaPN8jVTjdag9frLPgBtqvO/goB5zxeGzaTU0CdL6C4=";
        url = "https://developer.nvidia.com/downloads/vulkan-beta-5504053-linux";
      };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
