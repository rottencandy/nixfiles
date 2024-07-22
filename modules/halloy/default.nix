{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [ halloy ];

  home.file = {
    ".config/halloy/config.toml".source = ./config.toml;
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
