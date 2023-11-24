{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    swaylock
    swayidle
  ];

  home.file = {
    ".config/sway/config".source = ./config;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
