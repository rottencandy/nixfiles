{ config, pkgs, lib, ... }:

let

  # Toggle all hyprland animations & visuals for performance
  hyprland-perf = pkgs.writeShellScriptBin "hyperf" ''
  HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==2{print $2}')
  if [ "$HYPRGAMEMODE" = 1 ] ; then
      hyprctl --batch "\
          keyword animations:enabled 0;\
          keyword decoration:drop_shadow 0;\
          keyword decoration:blur:enabled 0;\
          keyword general:gaps_in 0;\
          keyword general:gaps_out 0;\
          keyword general:border_size 1;\
          keyword decoration:rounding 0"
      exit
  fi
  hyprctl reload
  '';

in
{

  home.packages = with pkgs; [
    hyprland-perf
    xdg-desktop-portal-hyprland
    hyprland
  ];

  home.file = {
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };

  # hyprland config
  #wayland.windowManager.hyprland = {
  #  enable = true;
  #  settings = {
  #    # use integrated GPU by default
  #    env = "WLR_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1";
  #    "$mod" = "SUPER";
  #    bind = [
  #      "$mod, ENTER, exec, wezterm"
  #      "$mod, D, exec, fuzzel"
  #    ];
  #  };
  #};

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 30;
        spacing = 4;
        modules-left = [ "hyprland/workspaces" ];
        #modules-center = [ "hyprland/window" ];
        modules-right = [ "idle_inhibitor" "network" "cpu" "memory" "temperature" "battery" "clock" "tray" ];
        keyboard-state = {
          numlock = true;
          capslock = true;
        };
        clock = {
          # timezone = "America/New_York";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%I:%M}";
          format-alt = "{:%h %d}";
        };
      };
    };
  };

}

# vim: fdm=marker:fdl=0:et:sw=2
