{ pkgs, ... }:

{
  qt = {
    enable = true;
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.tokyo-night-gtk;
      name = "Tokyonight-Dark-B";
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
    iconTheme = {
      package = pkgs.reversal-icon-theme;
      name = "Tela";
    };
  };

}
