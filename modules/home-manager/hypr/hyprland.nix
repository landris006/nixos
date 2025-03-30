{pkgs, ...}: {
  home.packages = with pkgs; [
    hyprpolkitagent
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # plugins = with pkgs.hyprlandPlugins; [
    #   # hyprspace
    #   # hyprexpo
    # ];
    sourceFirst = false;
    settings = let
      mainMod = "ALT_L";
      startReplay = pkgs.writeShellScriptBin "start-replay" ''
        pidof -q gpu-screen-recorder && exit 0
        video_path="$HOME/Videos/gpu-screen-recorder"
        mkdir -p "$video_path"
        ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder \
          -w screen \
          -f 60 \
          -a "default_output|default_input" \
          -c mkv \
          -bm cbr -q 45000 \
          -r 180 \
          -o "$video_path" \
          -sc ${saveVideo}/bin/save-video
      '';
      saveVideo = pkgs.writeShellScriptBin "save-video" ''
        notify-send -u low -- "GPU Screen Recorder" "Saving replay..."

        video_path=$1
        video_directory=$(dirname "$video_path")

        window_name="$(hyprctl activewindow -j | jq -r '.initialTitle')"
        if [[ "$window_name" == "null" ]]; then
          window_name="Desktop"
        fi

        mkdir -p "$video_directory/$window_name"
        mv "$1" "$video_directory/$window_name"

        notify-send -u low -- "GPU Screen Recorder" "Replay saved to $video_directory/$window_name"
      '';
      saveReplay = pkgs.writeShellScriptBin "save-replay" ''
        killall -SIGUSR1 gpu-screen-recorder
      '';
    in {
      source = [
        "$HOME/.config/hypr/monitors.conf"
        "$HOME/.config/hypr/overrides.conf"
      ];

      exec-once = [
        "hyprctl switchxkblayout current next"
        "hyprctl dispatch workspace 1"
        "${pkgs.swaynotificationcenter}/bin/swaync -c $HOME/.config/swaync/config.json"
        "${pkgs.waybar}/bin/waybar"
        "${pkgs.swww}/bin/swww init"
        "systemctl --user start hyprpolkitagent"
        "${pkgs.swww}/bin/swww img ~/.config/hypr/wallpapers/city.png --transition-fps 165 --transition-type grow --transition-pos 0.8,0.9"
        "${pkgs.swayosd}/bin/swayosd-server"
        "${startReplay}/bin/start-replay"
      ];

      input = {
        kb_layout = "us,hu";
        kb_variant = "";
        kb_model = "";
        kb_options = "grp:alt_space_toggle";
        kb_rules = "";

        follow_mouse = 1;
        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        # force_no_accel = true
        accel_profile = "flat";

        touchpad = {
          natural_scroll = "no";
        };
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(bb9af7ee) rgba(c0caf5ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";
        no_focus_fallback = true;
        allow_tearing = false;
      };

      decoration = {
        active_opacity = 1;
        rounding = 2;

        blur = {
          enabled = true;
          new_optimizations = true;
          size = 10;
          passes = 2;
        };

        shadow = {
          enabled = 1;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      render = {
        explicit_sync = 2;
        explicit_sync_kms = 0;
      };

      opengl = {
        nvidia_anti_flicker = 0;
        force_introspection = 2;
      };

      debug = {
        damage_tracking = 0;
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      };

      cursor = {
        no_hardware_cursors = true;
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = false;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      misc = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        vrr = 1;
        vfr = 0;
      };

      binds = {
        allow_workspace_cycles = false;
      };

      bind = [
        "${mainMod} CONTROL SHIFT, Q, exit"
        "${mainMod} CONTROL      , W, killactive"
        "${mainMod}              , V, togglefloating"
        "${mainMod}              , F, fullscreen"

        "${mainMod} CONTROL, T, exec, ${pkgs.alacritty}/bin/alacritty"
        "${mainMod}        , O, exec, ${pkgs.rofi-wayland}/bin/rofi -mode run -show drun"
        "${mainMod}        , P, exec, ${pkgs.rofi-wayland}/bin/rofi -show window"
        "${mainMod}        , N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"
        "${mainMod}        , E, exec, thunar"
        "SUPER        SHIFT, S, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
        "SUPER             , L, exec, ${pkgs.hyprlock}/bin/hyprlock"

        # Alt + Tab
        "${mainMod}, tab, focuscurrentorlast"

        # Move focus with mainMod + vim keys
        "${mainMod} CONTROL, h, movefocus, l"
        "${mainMod} CONTROL, l, movefocus, r"
        "${mainMod} CONTROL, k, movefocus, u"
        "${mainMod} CONTROL, j, movefocus, d"

        # Move window with mainMod + vim keys
        "${mainMod} SHIFT, Left,  movewindow, l"
        "${mainMod} SHIFT, Right, movewindow, r"
        "${mainMod} SHIFT, Up,    movewindow, u"
        "${mainMod} SHIFT, Down,  movewindow, d"

        # Switch workspaces with mainMod + [0-9]
        "${mainMod}, 1, workspace, 1"
        "${mainMod}, 2, workspace, 2"
        "${mainMod}, 3, workspace, 3"
        "${mainMod}, 4, workspace, 4"
        "${mainMod}, 5, workspace, 5"
        "${mainMod}, 6, workspace, 6"
        "${mainMod}, 7, workspace, 7"
        "${mainMod}, 8, workspace, 8"
        "${mainMod}, 9, workspace, 9"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "${mainMod} CONTROL, 1, movetoworkspacesilent, 1"
        "${mainMod} CONTROL, 2, movetoworkspacesilent, 2"
        "${mainMod} CONTROL, 3, movetoworkspacesilent, 3"
        "${mainMod} CONTROL, 4, movetoworkspacesilent, 4"
        "${mainMod} CONTROL, 5, movetoworkspacesilent, 5"
        "${mainMod} CONTROL, 6, movetoworkspacesilent, 6"
        "${mainMod} CONTROL, 7, movetoworkspacesilent, 7"
        "${mainMod} CONTROL, 8, movetoworkspacesilent, 8"
        "${mainMod} CONTROL, 9, movetoworkspacesilent, 9"

        "${mainMod}, F10, exec, ${saveReplay}/bin/save-replay"
      ];

      bindm = [
        "${mainMod} CONTROL, mouse:272, movewindow"
        "${mainMod} CONTROL, mouse:273, resizewindow"
      ];

      bindl = [
        ",XF86AudioRaiseVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume raise"
        ",XF86AudioLowerVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume lower"
        ",XF86AudioMute,        exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle"

        ",XF86MonBrightnessUp,   exec, ${pkgs.swayosd}/bin/swayosd-client --brightness raise"
        ",XF86MonBrightnessDown, exec, ${pkgs.swayosd}/bin/swayosd-client --brightness lower"

        ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next "
        ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
      ];
    };
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
