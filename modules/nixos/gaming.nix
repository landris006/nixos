{ pkgs, inputs, ... }:

{
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
    platformOptimizations.enable = true;
  };

  services.pipewire.lowLatency.enable = true;

  imports = with inputs.nix-gaming.nixosModules; [
    pipewireLowLatency
    platformOptimizations
  ];

  environment.systemPackages = with pkgs; [
    lutris
    (wine.override { wineBuild = "wine64"; })
    (appimageTools.wrapType2
      {
        name = "awakened-poe-trade";
        src = fetchurl {
          url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v3.25.102/Awakened-PoE-Trade-3.25.102.AppImage";
          hash = "sha256-lcdKJ+B8NQmyMsv+76+eeESSrfR/7Mq6svO5VKaoNUY=";
        };
      }
    )
    (appimageTools.wrapType2
      {
        name = "wowup";
        src = fetchurl {
          url = "https://github.com/WowUp/WowUp/releases/download/v2.12.1-beta.2/WowUp-2.12.1-beta.2.AppImage";
          hash = "sha256-SIdI2L/w8PwGiECe6mVAC3QJoUNcQwRFYZsVKVnoAkU=";
        };
      }
    )
  ];
}
