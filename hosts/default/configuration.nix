# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, ... }:


{
  imports =
    [
      # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.default
      ./hardware-configuration.nix
      ../../modules/nixos/nvidia.nix
      ../../modules/nixos/gaming.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };


  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hu_HU.UTF-8";
    LC_IDENTIFICATION = "hu_HU.UTF-8";
    LC_MEASUREMENT = "hu_HU.UTF-8";
    LC_MONETARY = "hu_HU.UTF-8";
    LC_NAME = "hu_HU.UTF-8";
    LC_NUMERIC = "hu_HU.UTF-8";
    LC_PAPER = "hu_HU.UTF-8";
    LC_TELEPHONE = "hu_HU.UTF-8";
    LC_TIME = "hu_HU.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "hu";
      variant = "";
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings = {
        Autologin = {
          User = "andris";
          Session = "hyprland";
        };
      };
    };
    desktopManager.plasma6.enable = true;
    libinput.enable = true;
  };

  # Configure console keymap
  console.keyMap = "hu";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andris = {
    isNormalUser = true;
    description = "andris";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "render" ];
    # packages = with pkgs; [ ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "andris" = import ./home.nix;
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    feh
    dunst
    grim
    slurp
    wl-clipboard
    rofi-wayland
    hyprpaper
    libnotify
    waybar
    wget
    btop
    neovim
    alacritty
    ripgrep
    gnumake
    git
    gcc
    unzip
    nodejs
    python3
    neofetch
    tmux
    tokyo-night-gtk
    pavucontrol
    pulseaudio
    alsaUtils
    alsa-lib
    hyprshade
  ];

  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-archive-plugin
      ];
    };

    firefox.enable = true;
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerdfonts
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
