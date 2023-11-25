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
  imports = [
    ./hyprland.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    hyprland-perf
    xdg-desktop-portal-hyprland
    hyprpaper
    swaylock
  ];

  home.file = {
    ".config/hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
