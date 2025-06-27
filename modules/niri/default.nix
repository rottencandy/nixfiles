{
  lib,
  pkgs,
  ...
}:

{
  imports = [ ../waybar.nix ];

  home.file = {
    ".config/niri/config.kdl" = {
      source = ./config.kdl;
    };
  };

  home.packages = with pkgs; [
    swaylock
    niri
    niriswitcher
    xwayland-satellite
    wayland-pipewire-idle-inhibit
  ];
}

# vim: fdm=marker:fdl=0:et:sw=2
