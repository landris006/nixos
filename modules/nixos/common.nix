{
  inputs,
  pkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
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
    extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

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

  services.udev.packages = [pkgs.swayosd];
  systemd.services.swayosd-libinput-backend = {
    description = "SwayOSD LibInput backend for listening to certain keys like CapsLock, ScrollLock, VolumeUp, etc.";
    documentation = ["https://github.com/ErikReider/SwayOSD"];
    wantedBy = ["graphical.target"];
    partOf = ["graphical.target"];
    after = ["graphical.target"];

    serviceConfig = {
      Type = "dbus";
      BusName = "org.erikreider.swayosd";
      ExecStart = "${pkgs.swayosd}/bin/swayosd-libinput-backend";
      Restart = "on-failure";
    };
  };

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

  # Configure console keymap
  console.keyMap = "hu";

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (flameshot.override {
      enableWlrSupport = true;
    })
    nwg-displays
    reaper
    gnome-keyring
    vial
    bc
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
    vscode
    kdePackages.kate
    hyprpolkitagent
    gparted
    ffmpeg
    alacritty
    alsa-lib
    alsa-utils
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
    google-chrome
    neofetch
    neovim
    nodejs
    pavucontrol
    pkgs.nodePackages."@angular/cli"
    pkgs.nodePackages.nodemon
    playerctl
    killall
    discord
    vesktop
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
    slack
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

    # Firefox crashes under wayland + nvidia 555 (explicit sync)
    # MOZ_ENABLE_WAYLAND = 0;

    # GDK_SCALE = "1.25";
    # XCURSOR_SIZE = "32";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.sddm = {
      enableGnomeKeyring = true;
    };
  };
  services.gnome.gnome-keyring.enable = true;

  services.tumbler.enable = true; # for thunar thumbnails

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    gpu-screen-recorder = {
      enable = true;
      package = pkgs.gpu-screen-recorder.override {
        ffmpeg = pkgs.ffmpeg_6; # TODO: remove when gpu-screen-recorder gets updated
      };
    }; # avoid the prompt when starting pkgs.gpu-screen-recorder

    direnv.enable = true;

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
  services.openssh.enable = true;
}
