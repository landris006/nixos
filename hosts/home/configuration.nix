# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  username,
  hostname,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/ssd.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/spotify.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/draw.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # 1. Rule: wakeup fix
  # 2. Rule: hidraw access (keyboard)
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1022", ATTR{device}=="0x149c", ATTR{power/wakeup}="disabled"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

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
  services.displayManager.sddm.settings.Autologin = {
    User = username;
    Session = "hyprland";
  };

  nixpkgs.overlays = [
    (final: prev: {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [pkgs.libdbusmenu-gtk3];
      });
    })
  ];

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
