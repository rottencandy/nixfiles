{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.file = {
    ".config/sketchybar/sketchybarrc" = {
      source = ./sketchybarrc;
      executable = true;
    };
    ".config/sketchybar/plugins" = {
      source = ./plugins;
      recursive = true;
      executable = true;
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
