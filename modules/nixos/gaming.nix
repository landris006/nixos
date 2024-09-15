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
