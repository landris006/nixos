{ config, ... }:

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

        # version = "550.40.53";
        # persistencedVersion = "550.54.14";
        # settingsVersion = "550.54.14";
        # sha256_64bit = "sha256-ZA5pb1xjzDyEBrf3UYHta4T9laCOCW7LHJwhcdjw6MA=";
        # openSha256 = "sha256-p4FL0j9Ev4SJ3YcjfhFLxbMbc77dBblkrTYK50+OYqA=";
        # settingsSha256 = "sha256-m2rNASJp0i0Ez2OuqL+JpgEF0Yd8sYVCyrOoo/ln2a4=";
        # persistencedSha256 = "sha256-XaPN8jVTjdag9frLPgBtqvO/goB5zxeGzaTU0CdL6C4=";
        # url = "https://developer.nvidia.com/downloads/vulkan-beta-5504053-linux";

        # version = "550.78";
        # sha256_64bit = "sha256-NAcENFJ+ydV1SD5/EcoHjkZ+c/be/FQ2bs+9z+Sjv3M=";
        # sha256_aarch64 = "sha256-2POG5RWT2H7Rhs0YNfTGHO64Q8u5lJD9l/sQCGVb+AA=";
        # openSha256 = "sha256-cF9omNvfHx6gHUj2u99k6OXrHGJRpDQDcBG3jryf41Y=";
        # settingsSha256 = "sha256-lZiNZw4dJw4DI/6CI0h0AHbreLm825jlufuK9EB08iw=";
        # persistencedSha256 = "sha256-qDGBAcZEN/ueHqWO2Y6UhhXJiW5625Kzo1m/oJhvbj4=";

        # version = "555.42.02";
        # sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
        # sha256_aarch64 = "sha256-ekx0s0LRxxTBoqOzpcBhEKIj/JnuRCSSHjtwng9qAc0=";
        # openSha256 = "sha256-3/eI1VsBzuZ3Y6RZmt3Q5HrzI2saPTqUNs6zPh5zy6w=";
        # settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
        # persistencedSha256 = "sha256-3ae31/egyMKpqtGEqgtikWcwMwfcqMv2K4MVFa70Bqs=";

        version = "560.35.03";
        sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
        sha256_aarch64 = "sha256-s8ZAVKvRNXpjxRYqM3E5oss5FdqW+tv1qQC2pDjfG+s=";
        openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
        settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
        persistencedSha256 = "sha256-E2J2wYYyRu7Kc3MMZz/8ZIemcZg68rkzvqEwFAL3fFs=";
      };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
