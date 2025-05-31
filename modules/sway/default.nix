{
  config,
  lib,
  pkgs,
  ...
}:

let
  mod = "Mod4";
  tofiFontPath = "${pkgs.nerd-fonts.fira-code.outPath}/share/fonts/truetype/NerdFonts/FiraCode/FiraCodeNerdFont-Medium.ttf";
  volumeUp = "exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ && ~/.scripts/emit-vol-notif";
  volumeDown = "exec wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%- && ~/.scripts/emit-vol-notif";
  volumeToggle = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && ~/.scripts/emit-vol-notif";
  micToggle = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && ~/.scripts/emit-vol-notif";
  lockScreen = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
in
{
  imports = [ ../waybar.nix ];

  home.packages = with pkgs; [ swaylock ];

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = lockScreen;
      }
      {
        event = "lock";
        command = lockScreen;
      }
      {
        event = "unlock";
        command = "pkill --signal SIGUSR1 swaylock";
      }
    ];
    timeouts = [
      {
        timeout = 120;
        command = lockScreen;
      }
      {
        timeout = 130;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];
  };

  wayland.windowManager.sway.enable = true;
  # temporary workaround to https://github.com/nix-community/home-manager/issues/5311
  wayland.windowManager.sway.checkConfig = false;
  wayland.windowManager.sway.config = {
    modifier = mod;
    menu = "tofi-run";
    output = {
      eDP-1 = {
        pos = "1920 0";
      };
      HDMI-A-1 = {
        pos = "0 0";
      };
      DP-1 = {
        pos = "0 0";
      };
      "*" = {
        bg = "~/Pictures/wall.jpg fill";
      };
    };
    input = {
      "*" = {
        repeat_rate = "200";
        repeat_delay = "400";
      };
      "1267:12410:ELAN1203:00_04F3:307A_Touchpad" = {
        natural_scroll = "enabled";
      };
    };
    keybindings = lib.mkOptionDefault {
      "${mod}+Return" = "exec ghostty";
      "${mod}+Shift+Return" = "exec foot";
      "${mod}+p" = "exec ${lockScreen}";
      "${mod}+Shift+r" = "reload";
      "${mod}+f" = "fullscreen";
      "${mod}+d" =
        "exec tofi-drun --width 800 --height 600 --num-results 9 --drun-launch=true --font ${tofiFontPath}";
      "${mod}+n" = "exec cd ~/nb && ghostty -e nvim _temp.md";
      "${mod}+m" = "exec keepmenu -C";
      "${mod}+y" = "exec dunstctl close";
      "${mod}+Shift+y" = "exec dunstctl history-pop";
      "${mod}+Shift+q" = "kill";
      "${mod}+Shift+Escape" =
        "exec swaynag -t warning -m 'Really exit sway?' -b 'Yes, exit sway' 'swaymsg exit'";
      "${mod}+Up" = "focus up";
      "${mod}+Down" = "focus down";
      "${mod}+Left" = "focus left";
      "${mod}+Right" = "focus right";
      "${mod}+Shift+Up" = "move up";
      "${mod}+Shift+Down" = "move down";
      "${mod}+Shift+Left" = "move left";
      "${mod}+Shift+Right" = "move right";
      "${mod}+1" = "workspace number 1";
      "${mod}+2" = "workspace number 2";
      "${mod}+3" = "workspace number 3";
      "${mod}+4" = "workspace number 4";
      "${mod}+5" = "workspace number 5";
      "${mod}+6" = "workspace number 6";
      "${mod}+7" = "workspace number 7";
      "${mod}+8" = "workspace number 8";
      "${mod}+9" = "workspace number 9";
      "${mod}+0" = "workspace number 10";
      "${mod}+Shift+1" = "move container to workspace number 1";
      "${mod}+Shift+2" = "move container to workspace number 2";
      "${mod}+Shift+3" = "move container to workspace number 3";
      "${mod}+Shift+4" = "move container to workspace number 4";
      "${mod}+Shift+5" = "move container to workspace number 5";
      "${mod}+Shift+6" = "move container to workspace number 6";
      "${mod}+Shift+7" = "move container to workspace number 7";
      "${mod}+Shift+8" = "move container to workspace number 8";
      "${mod}+Shift+9" = "move container to workspace number 9";
      "${mod}+Shift+0" = "move container to workspace number 10";
      "${mod}+b" = "splith";
      "${mod}+v" = "splitv";
      "${mod}+s" = "layout stacking";
      "${mod}+w" = "layout tabbed";
      "${mod}+e" = "layout toggle split";
      "${mod}+space" = "focus mode_toggle";
      "${mod}+o" = "focus parent";
      "${mod}+i" = "focus child";

      "${mod}+F1" = volumeUp;
      "${mod}+F2" = volumeDown;
      "${mod}+F3" = volumeToggle;
      "${mod}+F4" = micToggle;
      "XF86AudioRaiseVolume" = volumeUp;
      "XF86AudioLowerVolume" = volumeDown;
      "XF86AudioMute" = volumeToggle;
      "XF86AudioMicMute" = micToggle;
      "XF86MonBrightnessDown" = "exec brightnessctl set 5%- && ~/.scripts/emit-brightness-notif";
      "XF86MonBrightnessUp" = "exec brightnessctl set 5%+ && ~/.scripts/emit-brightness-notif";
    };
    window.commands =
      map
        (cls: {
          command = "floating enable";
          criteria = {
            class = cls;
          };
        })
        [
          "pcsx2-qt"
          "yuzu"
          "steam"
          "steam_app.*"
          "gamescope"
          "dolphin-emu"
          "PPSSPPSDL"
          "Godot"
          "Surge XT"
          "LosslessCut"
          "fontforge"
          "Codium"
        ]
      ++
        map
          (id: {
            command = "floating enable";
            criteria = {
              app_id = id;
            };
          })
          [
            "lutris"
            # winetricks
            "zenity"
            # protonup
            "net.davidotek.pupgui2"
            "gamescope"
            "info.cemu.Cemu"
            ".blueman-manager-wrapped"
            "org.kde.dolphin"
            "org.qbittorrent.qBittorrent"
            "org.keepassxc.KeePassXC"
            "org.gnome.Boxes"
          ]
      ++
        map
          (title: {
            command = "floating enable";
            criteria = {
              title = title;
            };
          })
          [
            "^Picture-in-Picture$"
            "VCV Rack Free 2.6.4"
          ];
    gaps = {
      inner = 5;
      smartGaps = true;
    };
    bars = [
      {
        id = "default";
        command = "${pkgs.waybar}/bin/waybar";
      }
    ];
    #bars = [
    #  {
    #    id = "default";
    #    mode = "dock";
    #    position = "bottom";
    #    hiddenState = "hide";
    #    workspaceButtons = true;
    #    workspaceNumbers = true;
    #    statusCommand = "i3status-rs config-default.toml";
    #    fonts = {
    #      names = [ "monospace" ];
    #      size = 8.0;
    #    };
    #    trayOutput = "primary";
    #    colors = {
    #      background = "#000000";
    #      statusline = "#ffffff";
    #      separator = "#666666";
    #      focusedWorkspace = {
    #        border = "#4c7899";
    #        background = "#285577";
    #        text = "#ffffff";
    #      };
    #      activeWorkspace = {
    #        border = "#333333";
    #        background = "#5f676a";
    #        text = "#ffffff";
    #      };
    #      inactiveWorkspace = {
    #        border = "#333333";
    #        background = "#222222";
    #        text = "#888888";
    #      };
    #      urgentWorkspace = {
    #        border = "#2f343a";
    #        background = "#900000";
    #        text = "#ffffff";
    #      };
    #      bindingMode = {
    #        border = "#2f343a";
    #        background = "#900000";
    #        text = "#ffffff";
    #      };
    #    };
    #  }
    #];
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
