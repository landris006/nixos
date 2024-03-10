{ pkgs, ... }:

{
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    (appimageTools.wrapType2
      {
        name = "awakened-poe-trade";
        src = fetchurl {
          url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v3.23.10005/Awakened-PoE-Trade-3.23.10005.AppImage";
          hash = "sha256-5lnEWKbu2jpNuzvjmW4j4Z895GPRRNdV2IbYE37518Q=";
        };
      }
    )
  ];
}
