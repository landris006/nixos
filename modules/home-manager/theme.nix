{ pkgs, inputs, ... }:

let
  moreWaita = pkgs.stdenv.mkDerivation {
    name = "MoreWaita";
    src = inputs.more-waita;
    installPhase = ''
      mkdir -p $out/share/icons
      mv * $out/share/icons
    '';
  };

  nerdfonts = (pkgs.nerdfonts.override {
    fonts = [
      "Hack"
    ];
  });

  google-fonts = (pkgs.google-fonts.override {
    fonts = [
      # Sans
      "Gabarito"
      "Lexend"
      # Serif
      "Chakra Petch"
      "Crimson Text"
    ];
  });

  gtk-theme = "adw-gtk3-dark";
  cursor-theme = "Bibata-Modern-Classic";
  cursor-package = pkgs.bibata-cursors;
in
{
  home = {
    packages = with pkgs; [
      # themes
      adwaita-qt6
      adw-gtk3
      material-symbols
      nerdfonts
      noto-fonts
      noto-fonts-cjk-sans
      google-fonts
      moreWaita
      bibata-cursors
      # morewaita-icon-theme
      # papirus-icon-theme
      # qogir-icon-theme
      # whitesur-icon-theme
      # colloid-icon-theme
      # qogir-theme
      # yaru-theme
      # whitesur-gtk-theme
      # orchis-theme
    ];
    sessionVariables = {
      XCURSOR_THEME = cursor-theme;
      XCURSOR_SIZE = "24";
    };
    pointerCursor = {
      package = cursor-package;
      name = cursor-theme;
      size = 24;
      gtk.enable = true;
    };
    file = {
      ".local/share/fonts" = {
        recursive = true;
        source = "${nerdfonts}/share/fonts/truetype/NerdFonts";
      };
      ".fonts" = {
        recursive = true;
        source = "${nerdfonts}/share/fonts/truetype/NerdFonts";
      };
      # ".config/gtk-4.0/gtk.css" = {
      #   text = ''
      #     window.messagedialog .response-area > button,
      #     window.dialog.message .dialog-action-area > button,
      #     .background.csd{
      #       border-radius: 0;
      #     }
      #   '';
      # };
      ".local/share/icons/MoreWaita" = {
        source = "${moreWaita}/share/icons";
      };
    };
  };

  programs.eww = {
    enable = false;
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    # style = {
    #   package = pkgs.adwaita-qt;
    #   name = "adwaita-dark";
    # };
  };

  gtk = {
    enable = true;
    theme.name = gtk-theme;
    cursorTheme = {
      name = cursor-theme;
      package = cursor-package;
    };
    iconTheme.name = moreWaita.name;
  };
}
