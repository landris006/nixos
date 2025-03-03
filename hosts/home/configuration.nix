# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.default
    ./hardware-configuration.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/gaming.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = ["ntfs"];

  hardware.opentabletdriver.enable = true;

  services.pulseaudio.enable = false;
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

  services.postgresql.enable = true;

  services.flatpak.enable = true;

  services.gvfs.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  networking.hostName = "home"; # Define your hostname.
  networking.extraHosts = let
    path = "/etc/extra-hosts";
  in
    if builtins.pathExists path
    then builtins.readFile path
    else "";
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
    LANGUAGE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb = {
      layout = "hu";
      variant = "";
    };
    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        # i3blocks #if you are planning on using i3blocks over i3status
      ];
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
  '';

  environment.pathsToLink = ["/libexec"];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      Autologin = {
        User = "andris";
        Session = "hyprland";
      };
    };
  };

  services.libinput = {
    enable = true;
    mouse.accelProfile = "flat";
  };

  services.desktopManager = {
    plasma6.enable = false;
  };

  # Configure console keymap
  console.keyMap = "hu";

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

  nixpkgs.overlays = [
    (final: prev: {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [pkgs.libdbusmenu-gtk3];
      });
    })
  ];

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (flameshot.override {
      enableWlrSupport = true;
    })
    gnome-keyring
    openvpn
    azuredatastudio
    swappy
    nixd
    alejandra
    ags
    sassc
    bun
    transmission_4-gtk
    libreoffice
    syshud
    vesktop
    kate
    hyprpolkitagent
    gparted
    alacritty
    alsa-lib
    alsa-utils
    azure-cli
    azure-functions-core-tools
    btop
    cargo
    chromium
    dunst
    eww
    feh
    file-roller
    gammastep
    gcc
    git
    gnumake
    go
    go-tools
    grim
    hyprlock
    hyprls
    hyprshade
    hyprshot
    inotify-tools
    jq
    krita
    libnotify
    lz4
    neofetch
    neovim
    nodejs
    pavucontrol
    pkgs.nodePackages."@angular/cli"
    pkgs.nodePackages.nodemon
    playerctl
    pulseaudio
    python312Full
    poetry
    qt5.qtwayland
    libsForQt5.kio
    qt6.qtwayland
    remmina
    ripgrep
    rofi-wayland
    rustc
    slurp
    socat
    stow
    swaynotificationcenter
    swww
    teams-for-linux
    tmux
    unzip
    vlc
    waybar
    waybar-mpris
    wget
    wl-clipboard
    wf-recorder
    losslesscut-bin
    baobab
  ];

  systemd.user.tmpfiles.rules = [
    "L %t/discord-ipc-0 - - - - .flatpak/dev.vencord.Vesktop/xdg-run/discord-ipc-0"
  ];

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  environment.sessionVariables = {
    EDITOR = "nvim";
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = 0;
    # XDG_SESSION_TYPE = "wayland";
    # WLR_NO_HARDWARE_CURSORS = "1";

    __GL_GSYNC_ALLOWED = "1";
    NIXOS_OZONE_WL = "1";

    # Firefox crashes under wayland + nvidia 555 (explicit sync)
    # MOZ_ENABLE_WAYLAND = 0;

    # GDK_SCALE = "1.25";
    # XCURSOR_SIZE = "32";
  };

  security = {
    polkit.enable = true;
    pam.services.sddm = {
      enableGnomeKeyring = true;
    };
  };
  services.gnome.gnome-keyring.enable = true;

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

    firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
    };

    dconf.enable = true;

    nix-ld.enable = true;

    droidcam.enable = true;
  };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.hack
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
