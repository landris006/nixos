# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{inputs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/common.nix
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andris = {
    isNormalUser = true;
    description = "andris";
    extraGroups = ["networkmanager" "wheel" "audio" "video" "render" "docker"];
    # packages = with pkgs; [ ];
  };
  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "andris" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };
  services.displayManager.sddm.settings.Autologin = {
    User = "andris";
    Session = "hyprland";
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  networking.hostName = "work"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # 1. Rule: hidraw access (keyboard)
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  systemd.user.tmpfiles.rules = [
    # "L %t/discord-ipc-0 - - - - .flatpak/dev.vencord.Vesktop/xdg-run/discord-ipc-0"
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
