# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  username,
  hostname,
  pkgs,
  ...
}: let
  updateRefreshRate = pkgs.writeShellScriptBin "update-refresh-rate" ''
    MONITOR="eDP-1"

    # TODO: make it only affect refresh rate (remember scale, resolution, etc.)
    REFRESH=60.00000
    PRETTY=false
    if [ "$(</sys/class/power_supply/ADP1/device/power_supply/ADP1/online)" -eq 0 ]; then
        REFRESH=60.00000
        PRETTY=false
    else
        REFRESH=165.00000
        PRETTY=true
    fi

    for dir in /run/user/*; do
      for hypr_dir in "$dir/hypr/"*/; do
        socket="$hypr_dir.socket.sock"
        if [[ -S $socket ]]; then
          echo -e "keyword monitor $MONITOR,2560x1600@$REFRESH,0x0,1.25" | ${pkgs.socat}/bin/socat - UNIX-CONNECT:"$socket"

          echo -e "keyword animations:enabled $PRETTY" | ${pkgs.socat}/bin/socat - UNIX-CONNECT:"$socket"
          echo -e "keyword decoration:shadow:enabled $PRETTY" | ${pkgs.socat}/bin/socat - UNIX-CONNECT:"$socket"
        fi
      done
    done
  '';
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/ssd.nix
    ../../modules/nixos/amd.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/spotify.nix
    ../../modules/nixos/draw.nix
    ../../modules/nixos/bluetooth.nix
    ../../modules/nixos/common.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = [
    updateRefreshRate
  ];

  # needs `loginctl enable-linger <username>`
  systemd.services.set-refresh-rate = {
    description = "Sets refresh rate based on power source";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${updateRefreshRate}/bin/update-refresh-rate";
    };
  };

  # 1. Rule: wakeup fix
  # 2. Rule: hidraw access (keyboard)

  # ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1022", ATTR{device}=="0x149c", ATTR{power/wakeup}="disabled"
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"

    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", TAG+="systemd", ENV{SYSTEMD_WANTS}="set-refresh-rate.service"
    SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}="set-refresh-rate.service"
  '';

  # TODO:
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 0;
      STOP_CHARGE_THRESH_BAT0 = 1;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel" "audio" "video" "render" "docker" "dialout" "plugdev"];
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
