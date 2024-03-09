{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  # programs.tmux.enable = true;

  programs.bash.enable = true;
}
