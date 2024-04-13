{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.rio = {
    enable = true;
    settings = {
      permformance = "Low";
      fonts = {
        family = "FiraCode Nerd Font Mono";
        size = 20;
      };
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
