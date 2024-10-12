{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins;
      [
        hyprspace
        hyprexpo
      ];
    settings = {
      source = [
        "$HOME/.config/hypr/general.conf"
        "$HOME/.config/hypr/binds.conf"
        "$HOME/.config/hypr/monitors.conf"
      ];
    };
  };
}
