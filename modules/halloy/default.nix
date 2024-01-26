{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    halloy
  ];

  home.file = {
    ".config/halloy/config.yaml".source = ./config.yaml;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
