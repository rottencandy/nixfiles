{ config, pkgs, lib, ... }:

{
  home.file = {
    ".config/sketchybar/sketchybarrc".source = ./sketchybarrc;
    ".config/sketchybar/plugins" = {
      source = ./plugins;
      recursive = true;
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
