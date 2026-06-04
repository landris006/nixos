{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    plugins = with pkgs.yaziPlugins; {
      inherit git;
      inherit restore;
    };
  };

  home.file = {
    ".config/yazi/init.lua" = {
      source = ./init.lua;
    };
    ".config/yazi/keymap.toml" = {
      source = ./keymap.toml;
    };
    ".config/yazi/yazi.toml" = {
      source = ./yazi.toml;
    };
  };
}
