{ config, pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # use integrated GPU by default
      env = [
        "WLR_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      monitor = [
        # https://wiki.hyprland.org/Configuring/Monitors/
        "eDP-1,preferred,1920x0,1"
        "HDMI-A-1,highrr,0x0,auto"
        "DP-1,highrr,0x0,auto"
        "DP-2,highrr,0x0,auto"
        # For quickly plugging random monitors
        ",preferred,auto,auto"
      ];

      exec-once = [
        "waybar & mako & hyprpaper & kdeconnect-indicator"
        # To eanble screen sharing with xdg-desktop-portal-hyprland
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];

      # https://wiki.hyprland.org/Configuring/Variables/
      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        repeat_rate = 64;
        repeat_delay = 400;

        touchpad = {
          natural_scroll = true;
        };

        # -1.0 - 1.0, 0 means no modification.
        sensitivity = 0;
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      # turn on screens when mouse or kb is pressed
      misc = {
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        rounding = 10;
        
        blur = {
            enabled = true;
            size = 3;
            passes = 1;
        };

        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = "yes";

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 0, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        pseudotile = "yes";
        # you probably want this
        preserve_split = "yes";
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true;
      };

      gestures = {
        workspace_swipe = "off";
      };

      "$mod" = "SUPER";
      "$volume_up" = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ && ~/.scripts/emit-vol-notif";
      "$volume_down" = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%- && ~/.scripts/emit-vol-notif";
      "$volume_toggle" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ~/.scripts/emit-vol-notif";
      "$mic_toggle" = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && ~/.scripts/emit-vol-notif";
      "$brightness_up" = "brightnessctl set 5%+ && ~/.scripts/emit-brightness-notif";
      "$brightness_down" = "brightnessctl set 5%- && ~/.scripts/emit-brightness-notif";
      "$lock" = "swaylock -f -c 000000 && sleep 5 && hyprctl dispatch dpms off";
      "$notif_clear" = "makoctl dismiss";
      "$notif_undo" = "makoctl restore";
      "$pass" = "~/.scripts/passmenu";
      "$nb" = "cd ~/nb && alacritty -e nvim _temp.md";

      # https://wiki.hyprland.org/Configuring/Binds
      # TODO set up misc binds
      # TODO set up auto lock, screen off timeouts
      # TODO look into keybind solution without keyd
      bind = [
        "$mod SHIFT, ESCAPE, exit,"
        "$mod SHIFT, SPACE, togglefloating,"
        "$mod, RETURN, exec, alacritty"
        "$mod SHIFT, Q, killactive,"
        "$mod, W, pseudo, # dwindle"
        "$mod, E, togglesplit, # dwindle"
        "$mod, I, pin,"
        "$mod, F, fullscreen,"
        "$mod, P, exec, $lock"

        "$mod, Y, exec, $notif_clear"
        "$mod SHIFT, Y, exec, $notif_undo"
        "$mod, M, exec, $pass"
        "$mod, N, exec, $nb"

        # Media key h/w controls
        ", XF86AudioRaiseVolume, exec, $volume_up"
        ", XF86AudioLowerVolume, exec, $volume_down"
        ", XF86AudioMute, exec, $volume_toggle"
        ", XF86AudioMicMute, exec, $mic_toggle"
        ", XF86MonBrightnessUp, exec, $brightness_up"
        ", XF86MonBrightnessDown, exec, $brightness_down"

        # Move focus with mod + hjkl keys
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"

        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod, TAB, focuscurrentorlast,"

        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
      ];

      bindr = [
        "$mod, D, exec, tofi-drun --width 800 --height 600 --num-results 9 --drun-launch=true"
        "$mod SHIFT, D, exec, tofi-drun --width 800 --height 600 --num-results 9 | xargs hyprctl dispatch exec"
      ];

      bindl = [
        # Media key h/w controls
        "$mod, F1, exec, $volume_up"
        "$mod, F2, exec, $volume_down"
        "$mod, F3, exec, $volume_toggle"
        "$mod, F4, exec, $mic_toggle"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
