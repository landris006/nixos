{ pkgs, ... }:

let
  nerdfonts = (pkgs.nerdfonts.override {
    fonts = [
      "Hack"
    ];
  });

  icon-theme = {
    name = "Papirus-Dark";
    package = (pkgs.catppuccin-papirus-folders.override {
      flavor = "mocha";
      accent = "lavender";
    });
  };

  gtk-theme = {
    name = "Catppuccin-Mocha-Standard-Blue-Dark";
    package = (pkgs.catppuccin-gtk.override {
      variant = "mocha";
    });
  };

  cursor-theme = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
  };
in
{
  home = {
    packages = [
      pkgs.nerdfonts
    ];
    file = {
      ".local/share/fonts" = {
        recursive = true;
        source = "${nerdfonts}/share/fonts/truetype/NerdFonts";
      };
      ".fonts" = {
        recursive = true;
        source = "${nerdfonts}/share/fonts/truetype/NerdFonts";
      };
    };
    sessionVariables = {
      XCURSOR_THEME = cursor-theme.name;
      XCURSOR_SIZE = "24";
    };
    pointerCursor = {
      name = cursor-theme.name;
      package = cursor-theme.package;
      size = 24;
      gtk.enable = true;
    };
  };

  programs.eww = {
    enable = false;
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  gtk = {
    enable = true;
    theme = gtk-theme;
    cursorTheme = cursor-theme;
    iconTheme = icon-theme;
  };
}
