# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  username,
  hostname,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/ssd.nix
    ../../modules/nixos/amd.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/spotify.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/common.nix
  ];

  # 1. Rule: wakeup fix
  # 2. Rule: hidraw access (keyboard)

  # ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1022", ATTR{device}=="0x149c", ATTR{power/wakeup}="disabled"
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  services.tlp.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel" "audio" "video" "render" "docker"];
  };
  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      inherit username;
      inherit hostname;
    };
    users = {
      "${username}" = import ./home.nix;
    };
    backupFileExtension = "backup";
  };

  nixpkgs.overlays = [
  ];

  systemd.user.tmpfiles.rules = [
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
