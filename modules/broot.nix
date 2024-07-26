{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.broot = {
    enable = true;
    enableBashIntegration = true;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
