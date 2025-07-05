{pkgs, ...}: {
  home.packages = with pkgs; [
    hyprpolkitagent
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      hyprspace
    ];
    sourceFirst = false;
    settings = let
      mainMod = "ALT_L";
      scripts = import ./scripts.nix {inherit pkgs;};
    in {
      source = [
        "$HOME/.config/hypr/monitors.conf"
        "$HOME/.config/hypr/workspaces.conf"
        "$HOME/.config/hypr/extra.conf"
      ];

      exec-once = [
        "hyprctl dispatch workspace 1"
        "systemctl --user start hyprpolkitagent"

        "${pkgs.swaynotificationcenter}/bin/swaync -c $HOME/.config/swaync/config.json"
        "${pkgs.waybar}/bin/waybar"
        "${pkgs.swww}/bin/swww init"
        "${pkgs.networkmanagerapplet}/bin/nm-applet"
        "${pkgs.swayosd}/bin/swayosd-server"
        "${scripts.startReplay}"
        "${scripts.createConfigFiles}"
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
        gaps_in = 3;
        gaps_out = 5;
        border_size = 1;
        "col.active_border" = "rgba(bb9af7ee) rgba(c0caf5ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";
        no_focus_fallback = true;
        allow_tearing = false;
      };

      decoration = {
        active_opacity = 1;
        inactive_opacity = 1;

        rounding = 10;

        blur = {
          enabled = true;
          new_optimizations = true;
          size = 5;
          passes = 5;
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

      plugin = {
        # Hyprspace
        overview = {
          affectStrut = false;
          hideRealLayers = false;
          disableBlur = true;
        };
      };

      layerrule = [
        "blur, rofi"
        "ignorezero, rofi"

        "blur, waybar"
        "xray 1, waybar"
        "ignorezero, waybar"
      ];

      binds = {
        allow_workspace_cycles = false;
      };

      bind = [
        "${mainMod} CONTROL SHIFT, Q, exit"
        "${mainMod} CONTROL      , W, killactive"
        "${mainMod}              , V, togglefloating"
        "${mainMod}              , F, fullscreen"

        "${mainMod} CONTROL      , U, overview:toggle"

        "${mainMod} CONTROL, T, exec, ${pkgs.alacritty}/bin/alacritty"
        "${mainMod}        , O, exec, ${pkgs.rofi-wayland}/bin/rofi -mode run -show drun"
        "${mainMod}        , P, exec, ${pkgs.rofi-wayland}/bin/rofi -show window"
        "${mainMod}        , N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"
        "${mainMod}        , E, exec, thunar"
        "SUPER        SHIFT, S, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
        "SUPER             , L, exec, IMG=$(cat $(find ~/.cache/swww/ -type f | sort | head -n 1)) ${pkgs.hyprlock}/bin/hyprlock"

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

        "${mainMod}, F10, exec, ${scripts.saveReplay}"
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
