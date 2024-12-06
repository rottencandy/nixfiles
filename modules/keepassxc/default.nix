{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    keepassxc
    keepmenu
    wtype
  ];

  home.file = {
    ".config/keepmenu/config.ini" = {
      source = ./keepmenu-config.ini;
    };
  };
}

# vim: fdm=marker:fdl=0:et:sw=2
