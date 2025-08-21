{pkgs, ...}: let
  cursor-theme = {
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
  };
in {
  home = {
    sessionVariables = {
      HYPRCURSOR_THEME = cursor-theme.name;
      HYPRCURSOR_SIZE = cursor-theme.size;

      # Not used on Hyprland, HYPRCURSOR values takes precedence
      XCURSOR_THEME = cursor-theme.name;
      XCURSOR_SIZE = cursor-theme.size;
    };
    pointerCursor = {
      name = cursor-theme.name;
      package = cursor-theme.package;
      size = cursor-theme.size;
      gtk.enable = true;
      hyprcursor.enable = true;
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
    theme = {
      name = "catppuccin-mocha-blue-standard";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
      };
    };
    cursorTheme = cursor-theme;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };
  };
}
