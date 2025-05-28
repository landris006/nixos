{
  pkgs,
  inputs,
  config,
  ...
}: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
    args = [
      "--rt"
      "--expose-wayland"
    ];
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [
      pkgs.proton-ge-bin
    ];
  };

  services.pipewire.lowLatency.enable = true;
  imports = with inputs.nix-gaming.nixosModules; [
    pipewireLowLatency
  ];

  environment.systemPackages = with pkgs; [
    lutris
    (xivlauncher-rb.override {
      useGameMode = true;
      nvngxPath = "${config.hardware.nvidia.package}/lib/nvidia/wine";
    })
    (wine.override {wineBuild = "wine64";})
    (
      appimageTools.wrapType2
      {
        pname = "awakened-poe-trade";
        version = "3.25.102";
        src = fetchurl {
          url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v3.25.102/Awakened-PoE-Trade-3.25.102.AppImage";
          hash = "sha256-lcdKJ+B8NQmyMsv+76+eeESSrfR/7Mq6svO5VKaoNUY=";
        };
      }
    )
    (
      appimageTools.wrapType2
      {
        pname = "wowup";
        version = "2.12.1-beta.2";
        src = fetchurl {
          url = "https://github.com/WowUp/WowUp/releases/download/v2.12.1-beta.2/WowUp-2.12.1-beta.2.AppImage";
          hash = "sha256-SIdI2L/w8PwGiECe6mVAC3QJoUNcQwRFYZsVKVnoAkU=";
        };
      }
    )
  ];
}
