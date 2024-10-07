{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };

  programs.fzf.enable = true;

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  # programs.tmux.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      PATH=$HOME/.local/bin:$PATH
    '';
  };
}
