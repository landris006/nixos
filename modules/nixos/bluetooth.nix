{pkgs, ...}: {
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable BlueZ experimental features to unlock LE Audio / BAP (LC3 codec).
  # This lets the mic stay active without dropping audio from A2DP to HFP/HSP.
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };

  environment.systemPackages = with pkgs; [
    overskride
  ];
}
