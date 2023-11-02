{ config, pkgs, lib, ... }:

{
  services.sketchybar = {
    enable = true;
    config = lib.strings.fileContents ./sketchybarrc;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
