{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.nixosModules.default
  ];

  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
    enabledCustomApps = with spicePkgs.apps; [
      newReleases
      reddit
      lyricsPlus
      marketplace
    ];
    # theme = {
    #   name = "Tokyo Night";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "evening-hs";
    #     repo = "Spotify-Tokyo-Night-Theme";
    #     rev = "d88ca06eaeeb424d19e0d6f7f8e614e4bce962be";
    #     hash = "sha256-cLj9v8qtHsdV9FfzV2Qf4pWO8AOBXu51U/lUMvdEXAk=";
    #   };
    #
    #   injectCss = true;
    #   injectThemeJs = true;
    #   replaceColors = true;
    #   homeConfig = true;
    #   overwriteAssets = false;
    #   additonalCss = "";
    # };
    # colorScheme = "Night";
  };

  # environment.systemPackages = with pkgs; [
  #   spotify
  # ];

  # Local discovery (https://nixos.wiki/wiki/Spotify)
  # To sync local tracks from your filesystem with mobile devices in the same network,
  # you need to open port 57621 by adding the following line to your configuration.nix:
  networking.firewall.allowedTCPPorts = [57621];
  # In order to enable discovery of Google Cast devices (and possibly other Spotify Connect devices)
  # in the same network by the Spotify app, you need to open UDP port 5353 by adding the following line to your configuration.nix:
  networking.firewall.allowedUDPPorts = [5353];
}
