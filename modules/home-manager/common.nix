{pkgs, ...}: {
  imports = [
    # inputs.caelestia.homeManagerModules.default
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [];

  services.gammastep = {
    enable = true;
    tray = true;
    provider = "manual";
    latitude = 47.5;
    longitude = 19.0;
    temperature = {
      day = 6500;
      night = 4500;
    };
  };

  # programs.caelestia.enable = false;
  # programs.caelestia.cli.enable = config.programs.caelestia.enable;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
